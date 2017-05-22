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



	/**
     * __https://api.bitbucket.org/2.0/repositories/
     */
	public class func repositories(for username: String, page: Int = 1, rowsPerPage: Int = 10) -> Promise<SearchResult<Repository>?> {
		return Http.request(.get, route: "/repositories/\(username)?page=\(page)&pagelen=\(rowsPerPage)&q=has_issues%3Dtrue")
	}

}
