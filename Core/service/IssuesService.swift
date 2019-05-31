//
//  IssuesService.swift
//  test-ios
//
//  Created by carlos chaguendo on 20/04/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RealmSwift
import PromiseKit
import ObjectMapper
import AlamofireObjectMapper

public class IssuesService: Service {

    /// Obtiene los comentarios de un issue guardados localmente que tengan un mensaje
    ///
    /// - Parameters:
    ///   - team: Team Equipo
    ///   - repository: slug
    ///   - issueId: identificador del Issue
    ///   - page: pagina cuando se consulta al servidor
    ///   - refreshFromServer: forza la consulta al servidor
    /// - Returns: `SearchResult<IssueComment>`
    private class func loadComments(of team: String, inRepository repository: String, forIssue issueId: Int, page: Int = 1, refreshFromServer: Bool? = false) -> Promise<SearchResult<IssueComment>?> {
        let server = "/2.0/repositories/\(team)/\(repository)/issues/\(issueId)/comments?qr=content.raw!%3Dnull"
        return select(from: IssueComment.self, where: `where`("issueId = %@ and type = %@", ["\(issueId)", "issue_comment"]), decoreBeforeSaving: {
            $0.type = "issue_change"
        }, orConnectTo: server)
    }

    /// Obtiene los cambios de un issue guardados localmente que tengan un mensaje
    ///
    /// - Parameters:
    ///   - team: Team Equipo
    ///   - repository: slug
    ///   - issueId: identificador del Issue
    ///   - page: pagina cuando se consulta al servidor
    ///   - refreshFromServer: forza la consulta al servidor
    /// - Returns: `SearchResult<IssueComment>`
    private class func loadChanges(of team: String, inRepository repository: String, forIssue issueId: Int, page: Int = 1, refreshFromServer: Bool? = false) -> Promise<SearchResult<IssueComment>?> {
        let server = "/2.0/repositories/\(team)/\(repository)/issues/\(issueId)/changes?qr=message.raw!%3Dnull"
        return select(from: IssueComment.self, where: `where`("issueId = %@", ["\(issueId)"]), decoreBeforeSaving: {
            $0.type = "issue_change"
            _ = $0.changes?.html /// genera la descripcion de los cambios
        }, orConnectTo: server)
    }

    public class func comments(of team: String, inRepository repository: String, forIssue issueId: Int, page: Int = 1, refreshFromServer: Bool? = false) -> Promise<SearchResult<IssueComment>?> {
        return loadChanges(of: team, inRepository: repository, forIssue: issueId, refreshFromServer: refreshFromServer)
            .then { _ -> Promise<SearchResult<IssueComment>?> in
                return loadComments(of: team, inRepository: repository, forIssue: issueId, refreshFromServer: refreshFromServer)
            }.then { _ -> Promise<SearchResult<IssueComment>?> in
                let allValues: [IssueComment] = realm.objects(IssueComment.self).filter(`where`("issueId = %@", ["\(issueId)"])).detached
                let result = SearchResult<IssueComment>(values: allValues)
                return Promise.value(result)
        }
    }

    /// Reasigna un issue
    ///
    /// - Parameters:
    ///   - assigne: Destinatario del issue
    ///   - issue: issue
    ///   - team: equipo al que pertenece el repositorio del issue
    ///   - repository: repositorio
    /// - Returns: Issue Editado
    public class func assigne(to assigne: Assignee, issue: Issue) -> Promise<Issue?> {

        guard let repositoryId = issue.repository?.uuid, let assigneId = assigne.uuid else {
            return Promise.init(error: Service.Error.labeled(" Assigne do not have id field"))
        }

        return RepositoryService.get(id: repositoryId)
            .then { repository -> Promise<Issue?> in

                guard let repository = repository else {
                    throw Service.Error.labeled(" repository \(repositoryId) not found")
                }
                let parameters: [String: Any] = ["assignee": ["uuid": assigneId]]
                let url = Http.unwrapurl(route: "/2.0/repositories/\(repository.fullName.orEmpty)/issues/\(issue.id)")
                return Http.request(.put, route: url, parameters: parameters, encoding: JSONEncoding())

            }.then { edited -> Promise<Issue?> in

                if let local = realm.object(ofType: Issue.self, forPrimaryKey: issue.id),
                    let assigne = realm.object(ofType: Assignee.self, forPrimaryKey: assigneId) {
                    try realm.write { local.assignee = assigne }
                }
                return .value(edited)
        }
    }

    public class func issue(_ id: String, of team: String, inRepository repository: String) -> Promise<Issue?> {
        return Http.request(.get, route: "/2.0/repositories/\(team)/\(repository)/issues/\(id)")
    }

    /**
     * __https://api.bitbucket.org/2.0/repositories/mayorgafirm/adivantus-iphone/issues__
     */
    public class func issues(of team: User, inRepository repository: Repository, assigneedTo assigne: Assignee? = nil, whitStatus: [String] = [], page: Int = 1, refreshFromServer: Bool? = false) -> Promise<SearchResult<Issue>?> {
        return Promise<SearchResult<Issue>?> { (resolve, reject) -> Void in

            // Se actualizan los filtros actuales de busqueda
            TeamsService.update(filtersOf: team, inReporsitory: repository, assigneTo: assigne, whitStatus: whitStatus)

            /**
             Cuando se recarga del servidor se debe eliminar todos los registros para
             que se cargen las sigientes paginas cuando se hace loive scroll
             */
            if refreshFromServer == true {
                try realm.write {
                    realm.delete(realm.objects(Issue.self))
                }
            }

            let predicate = NSPredicate(format: " page = %i AND repository.uuid = %@", page, repository.uuid!)
            let localdata = realm.objects(Issue.self).filter(predicate).sorted(byKeyPath: "id", ascending: false)

            //Si existen datos almacenados localmente no se requiere ir hast el servidor
            if refreshFromServer == false && localdata.count > 0 {
                let issues = localdata.map({ Issue(value: $0) })
                let result = SearchResult<Issue>()
                result.values.append(contentsOf: issues)
                resolve(result)
                return
            }

            var route = "/2.0/repositories/\(team.username!)/\(repository.slug!)/issues?page=\(page)&sort=-updated_on"
            var filter: [String: String] = [:]

            if let uuid = assigne?.uuid {
                filter["assignee.uuid"] = "\"\(uuid)\""
            }

            if whitStatus.count > 0 {
                var status = whitStatus.map { "\"\($0)\"" }.joined(separator: " OR state=")
                status = "\(status))"
                filter["(state"] = status
            }

            // se crean todos los filtros de busqueda
            let queryString = filter.map({ "\($0)=\($1)" }).joined(separator: " AND ")
            Logger.info("query = \(queryString)")
            let quey = queryString.encodeURIComponent()!
            route = "\(route)&q=\(quey)"

            let origin: Promise<SearchResult<Issue>?> = Http.request(.get, route: route)
            origin
                .done { (result) -> Void in

                    resolve(result)
                    if let issues = result?.values {
                        try realm.write {
                            issues
                                .map({ Issue(value: $0) })
                                .forEach({ (issue) in
                                    issue.page = page
                                    realm.add(issue, update: true)
                                })

                        }
                    }

                }.catch(execute: reject)

        }

    }

}
