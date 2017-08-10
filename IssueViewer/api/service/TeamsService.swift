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
     * __https://api.bitbucket.org/2.0/repositories/
     */
//	public class func members(of teamName: String, page: Int = 1, rowsPerPage: Int = 10, refreshFromServer:Bool = false) -> Promise<SearchResult<Assignee>?> {
//		return Http.request(.get, route: "/teams/\(teamName)/members?page=\(page)&pagelen=\(rowsPerPage)&sort=-display_name")
//	}
    
    public class func members(of teamName: String, page: Int = 1, rowsPerPage: Int = 10,refreshFromServer:Bool = false) -> Promise<SearchResult<Assignee>?> {
        
        return Promise<SearchResult<Assignee>?> { (resolve, reject) -> Void in
            
            let localdata = realm.objects(Assignee.self).sorted(byKeyPath: "displayName")
            //Si existen datos almacenados localmente no se requiere ir hast el servidor
            if(refreshFromServer == false && localdata.count > 0) {
                let result  = SearchResult<Assignee>()
                result.values = localdata.map({Assignee(value:$0)})
                resolve(result)
            } else {
                
                Http.request(.get, route: "/teams/\(teamName)/members?page=\(page)&pagelen=\(rowsPerPage)&sort=-display_name")
                    .then(execute: { (teamsFromServer:SearchResult<Assignee>?) -> Void in
                        
                        let result  = SearchResult<Assignee>()
                        result.values = teamsFromServer!.values.map({Assignee(value:$0)})
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


}


