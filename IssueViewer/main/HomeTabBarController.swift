//
//  HomeTabBarController.swift
//  IssueViewer
//
//  Created by Carlos Chaguendo on 20/09/17.
//  Copyright © 2017 Chasan. All rights reserved.
//

import UIKit
import IoniconsSwift


@IBDesignable
class ProfileTabBarItem: UITabBarItem {

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        image = Ionicons.androidPerson.image(24)
        selectedImage = Ionicons.androidPerson.image(24, color: Colors.primary)
    }
}

@IBDesignable
class SettingsTabBarItem: UITabBarItem {

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        image = Ionicons.androidSettings.image(24)
        selectedImage = Ionicons.androidSettings.image(24, color: Colors.primary)
    }
}

@IBDesignable
class IssuesTabBarItem: UITabBarItem {

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        image = Ionicons.network.image(24)
        selectedImage = Ionicons.network.image(24, color: Colors.primary)
    }
}

@IBDesignable
class TeamsTabBarItem: UITabBarItem {

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        image = Ionicons.androidContacts.image(24)
        selectedImage = Ionicons.androidContacts.image(24, color: Colors.primary)
    }
}


class HomeTabBarController: UITabBarController {


    let tabBarTopBorder = CALayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        tabBar.tintColor = Colors.TapBar.tint
        tabBar.barTintColor = Colors.TapBar.background

        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()


        tabBarTopBorder.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 0.5)
        tabBarTopBorder.backgroundColor = Colors.TapBar.topBorder.cgColor
        tabBarTopBorder.isHidden = true
        tabBar.layer.addSublayer(tabBarTopBorder)

        
//
//        HairPowder.instance.spread()
//
//
//
//        if let window = UIApplication.shared.keyWindow {
//            if #available(iOS 11.0, *) {
//                print(" window  \(window.safeAreaInsets)")
//                if window.safeAreaInsets.top > 0 {
//
//                    let x = CALayer()
//
//                    let w = UIScreen.main.bounds.width
//                    x.frame = CGRect(x: 0, y: 0, width: w, height: window.safeAreaInsets.top)
//                    x.backgroundColor = UIColor.black.cgColor
//
//                    UIApplication.shared.statusBarView?.layer.insertSublayer(x, at: 0)
//
//                }
//
//
//            }
//        }
        

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)


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

extension HomeTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController is  RepositoriesTableViewController {
            tabBarTopBorder.isHidden = true
        }else {
            tabBarTopBorder.isHidden = false
        }
        
        print("Should select viewController: \(viewController.title.or(else: "xxx")!) ?")
        return true;
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("didSelect" )
    }


}
