//
//  TeamsService.swift
//  test-ios
//
//  Created by carlos chaguendo on 17/05/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//




import UIKit
import Alamofire
import RealmSwift
import PromiseKit
import ObjectMapper
import AlamofireObjectMapper

public class TeamsService: Service {

    /**
     * __https://api.bitbucket.org/2.0/teams/?role=member
     */
    public class func teams(refreshFromServer: Bool = false) -> Promise<SearchResult<User>?> {
        return Promise<SearchResult<User>?> { (resolve, reject) -> Void in
            let localdata = realm.objects(User.self).filter("type = %@",User.Origin.team.rawValue)
            if(refreshFromServer == false && localdata.count > 0) {
                let result = SearchResult<User>()
                result.values = localdata.map({ User(value: $0) })
                resolve(result)
            } else {
        
                Http.request(.get, route: "/2.0/teams/?role=member")
                    .then(execute: { (teamsFromServer: SearchResult<User>?) -> Void in

                        
               
                        
                        let result = SearchResult<User>()
                        result.values = teamsFromServer!.values.map({ User(value: $0) })
                        
           
                        resolve(result)


                        //Save local
                        try! realm.write {

                            // elimina la informacion vieja
                            realm.delete(localdata)

                            for el in teamsFromServer!.values {
                                realm.add(el, update: true);
                            }
                        }

                    }).catch(execute: reject)
            }
        }

    }

    /**
     Ya que el servicoo es de contar rowsPerPage = 0
     */
    public class func count(membersOf team: User, page: Int = 1, rowsPerPage: Int = 0, refreshFromServer: Bool = false) -> Promise<Int> {
        return Promise<Int> { (resolve, reject) -> Void in
            let localdata = realm.objects(TeamMember.self).filter("team.accountId = %@", team.accountId!)
            if(refreshFromServer == false && localdata.count > 0) {
                resolve(localdata.count)
            } else {

                Http.request(.get, route: "/2.0/teams/\(team.username!)/members?page=\(page)&pagelen=\(rowsPerPage)")
                    .then(execute: { (searchResult: SearchResult<User>?) -> Void in

                        resolve(searchResult?.size ?? 0)
                        //Save local
                        try! realm.write {
                            team.numberOfmebers = "\(searchResult!.size)"
                            realm.add(team, update: true);
                        }

                    }).catch(execute: reject)
            }
        }
    }

    /**
     Ya que el servicoo es de contar rowsPerPage = 0
     */
    public class func count(repositoriesOf team: User, page: Int = 1, rowsPerPage: Int = 0, refreshFromServer: Bool = false) -> Promise<Int> {
        return Promise<Int> { (resolve, reject) -> Void in

            let localdata = realm.objects(TeamRepository.self).filter("team.accountId = %@", team.accountId!)
            if(refreshFromServer == false && localdata.count > 0) {
                resolve(localdata.count)
            } else {

                Http.request(.get, route: "/2.0/repositories/\(team.username!)?page=\(page)&pagelen=\(rowsPerPage)&q=has_issues%3Dtrue")
                    .then(execute: { (searchResult: SearchResult<Repository>?) -> Void in

                        resolve(searchResult?.size ?? 0)
                        //Save local
                        try! realm.write {
                            team.numberOfRepositories = "\(searchResult!.size)"
                            realm.add(team, update: true);
                        }

                    }).catch(execute: reject)
            }
        }
    }


    /**
     * __https://api.bitbucket.org/2.0/repositories/
     */
    public class func members(of teamName: String, page: Int = 1, rowsPerPage: Int = 10, refreshFromServer: Bool = false) -> Promise<SearchResult<Assignee>?> {

        return Promise<SearchResult<Assignee>?> { (resolve, reject) -> Void in

            let localdata = realm.objects(Assignee.self).sorted(byKeyPath: "displayName")
            //Si existen datos almacenados localmente no se requiere ir hast el servidor
            if(refreshFromServer == false && localdata.count > 0) {
                let result = SearchResult<Assignee>()
                result.values = localdata.map({ Assignee(value: $0) })
                resolve(result)
            } else {

                Http.request(.get, route: "/2.0/teams/\(teamName)/members?page=\(page)&pagelen=\(rowsPerPage)&sort=-display_name")
                    .then(execute: { (teamsFromServer: SearchResult<Assignee>?) -> Void in

                        let result = SearchResult<Assignee>()
                        result.values = teamsFromServer!.values.map({ Assignee(value: $0) })
                        resolve(result)


                        //Save local
                        try! realm.write {
                            for el in teamsFromServer!.values {
                                realm.add(el, update: true);
                            }
                        }

                    }).catch(execute: reject)

            }
        }
    }


    public class func currentFilters(of team: User) -> TeamIssuesFilters? {
        print("Buscando filtros de \( team.accountId!)")
        let localdata = realm.objects(TeamIssuesFilters.self).filter("team.accountId = %@", team.accountId!)
        guard let filter = localdata.first else {
            return nil
        }

        return TeamIssuesFilters(value: filter);
    }

    public class func update(filtersOf team: User, inReporsitory repository: Repository, assigneTo assigne: Assignee?, whitStatus: [String]) -> Void {
        try! realm.write({
            let filters = TeamsService.currentFilters(of: team) ?? TeamIssuesFilters(team: team, repository: repository)
            filters.repository = realm.object(ofType: Repository.self, forPrimaryKey: repository.uuid!) ?? repository
            filters.status = whitStatus.joined(separator: ",")
            filters.assigne = assigne
            realm.add(filters, update: true)
        })
    }


}


