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
	public class func members(of teamName: String, page: Int = 1, rowsPerPage: Int = 10) -> Promise<SearchResult<Assignee>?> {
		return Http.request(.get, route: "/teams/\(teamName)/members?page=\(page)&pagelen=\(rowsPerPage)&sort=-display_name")
	}

}


