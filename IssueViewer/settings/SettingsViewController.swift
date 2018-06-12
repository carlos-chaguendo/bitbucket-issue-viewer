//
//  SettingsViewController.swift
//  IssueViewer
//
//  Created by Carlos Chaguendo on 20/09/17.
//  Copyright © 2017 Chasan. All rights reserved.
//

import UIKit
import IoniconsSwift
import Core

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TeamsService.teams(refreshFromServer: false).then { (result) -> Void in
            print(">>>>>")
            
            for d in result!.values{
                print("sss \(d.displayName!)")
            }
        }.end()
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
