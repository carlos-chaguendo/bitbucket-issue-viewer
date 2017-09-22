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

    public class func comments(of: String, inRepository repository: String, forIssue: Int, page: Int = 1, refreshFromServer: Bool? = false) -> Promise<SearchResult<IssueComment>?> {
        return Http.request(.get, route: "/2.0/repositories/\(of)/\(repository)/issues/\(forIssue)/comments")
    }


    /**
     */
    public class func assigne(to: Assignee, issue: Issue, of: String, inRepository repository: String) -> Promise<IssueEdited?> {
        let parameters: [String: Any] = ["responsible": to.username!]
        let url = Http.unwrapurl(route: "/1.0/repositories/\(of)/\(repository)/issues/\(issue.id)")
        return Http.request(.put, route: url, parameters: parameters, encoding: URLEncoding(), headers: [:], manager: Http.sharedInstance)
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
                try! realm.write({
                    realm.delete(realm.objects(Issue.self))
                })
            }

            let predicate = NSPredicate(format: " page = %i AND repository.uuid = %@", page, repository.uuid!)
            let localdata = realm.objects(Issue.self).filter(predicate).sorted(byKeyPath: "id", ascending: false)

            //Si existen datos almacenados localmente no se requiere ir hast el servidor
            if(refreshFromServer == false && localdata.count > 0) {
                let issues = localdata.map({ Issue(value: $0) })
                let result = SearchResult<Issue>()
                result.values.append(contentsOf: issues)
                resolve(result)
                return
            }

            var route = "/2.0/repositories/\(team.username!)/\(repository.slug!)/issues?page=\(page)&sort=-updated_on"
            var filter: [String: String] = [:]

            if assigne != nil {
                filter["assignee.username"] = "\"\(assigne!.username!)\""
            }

            if whitStatus.count > 0 {
                var status = whitStatus.map { "\"\($0)\"" }.joined(separator: " OR state=")
                status = "\(status))"
                filter["(state"] = status
            }

            // se crean todos los filtros de busqueda
            let p = filter.map({ "\($0)=\($1)" }).joined(separator: " AND ")
            print("query = \(p)")
            let q = p.encodeURIComponent()!
            route = "\(route)&q=\(q)"

            let origin: Promise<SearchResult<Issue>?> = Http.request(.get, route: route)
            origin.then(execute: { (result) -> Void in
                resolve(result)

                if let issues = result?.values {

                    try! realm.write({
                        issues
                            .map({ Issue(value: $0) })
                            .forEach({ (issue) in
                                issue.page = page
                                realm.add(issue, update: true)
                            })

                    })

                }

            }).catch(execute: reject)

        }


    }

}
