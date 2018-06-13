//
//  RepositoryService.swift
//  test-ios
//
//  Created by carlos chaguendo on 20/04/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//


import UIKit
import Alamofire
import RealmSwift
import PromiseKit
import ObjectMapper
import AlamofireObjectMapper


public class RepositoryService: Service {


    /// <#Description#>
    ///
    /// - Parameters:
    ///   - username: Username
    ///   - page: Pagina actual
    ///   - rowsPerPage: resultados esperados por pagina
    /// - Returns: `SearchResult<Repository>`
    public class func repositories(for username: String, page: Int = 1, rowsPerPage: Int = 10) -> Promise<SearchResult<Repository>?> {
        let server = "/2.0/repositories/\(username)?page=\(page)&pagelen=\(rowsPerPage)&q=has_issues%3Dtrue"
        // Reposiorios con issues que pertenescan a usuario
        let query = _q(" has_issues = true AND ownerUsername = %@  AND page = %i ", [ username, page])

        return Promise<SearchResult<Repository>?> { (resolve, reject) in

            select(from: RepositoryInCache.self,
                   where: query,
                   decoreBeforeSaving: { $0.page = page },
                   orConnectTo: server)
                .then (execute: {
                    resolve(SearchResult<Repository>(values: $0!.values))
                }).catch(execute: reject)

        }
    }

    /// Obtiene las versiones de un repositorio
    ///
    /// - Parameters:
    ///   - of: Team Equipo
    ///   - repository: slug
    ///   - refresh: forza la consulta al servidor
    ///    - Returns: `SearchResult<IssueCommen
    public class func versions(of username: String, inRepository repository: String, refresh: Bool = false) -> Promise<SearchResult<Version>?> {
        let server = "/2.0/repositories/\(username)/\(repository)/versions"
        let query = _q(" repository.name = %@  ", [repository])
        
        // Reporsitorio local
        let repository = realm.objects(Repository.self).filter(_q("name = %@", [repository])).first!
        
        return Promise<SearchResult<Version>?> { (resolve, reject) in
            select(from: Version.self,
                   where: query,
                   decoreBeforeSaving: { $0.repository = repository },
                   orConnectTo: server,
                   refresh: refresh)
                .then (execute: {
                    resolve(SearchResult<Version>(values: $0!.values))
                }).catch(execute: reject)
        }
    }







}
