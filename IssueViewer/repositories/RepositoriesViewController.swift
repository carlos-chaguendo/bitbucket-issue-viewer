//
//  RepositoriesViewController.swift
//  IssueViewer
//
//  Created by carlos chaguendo on 15/06/17.
//  Copyright © 2017 Chasan. All rights reserved.
//

import UIKit

class RepositoriesViewController: UIViewController {

	@IBOutlet weak var flowCard: FlowCard!


	override func viewDidLoad() {
		super.viewDidLoad()

		flowCard.backgroundColor = UIColor(patternImage: UIImage(named: "katy")!)
		flowCard.userImage.image = UIImage(named: "katy")


		// Do any additional setup after loading the view.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
