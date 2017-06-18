//
//  HomeTabBarViewController.swift
//  Rattit
//
//  Created by DINGKaile on 6/17/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class HomeTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let contentFlowSB: UIStoryboard = UIStoryboard(name: "ContentFlow", bundle: nil)
        let contentFlowNavVC = contentFlowSB.instantiateViewController(withIdentifier: "ContentFlowNavigationVC") as UIViewController
        contentFlowNavVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "contentTab"), tag: 0)
        
        let searchSB: UIStoryboard = UIStoryboard(name: "Search", bundle: nil)
        let searchNavVC = searchSB.instantiateViewController(withIdentifier: "SearchNavigationVC") as UIViewController
        searchNavVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "searchTab"), tag: 1)
        
        let loveSB: UIStoryboard = UIStoryboard(name: "Love", bundle: nil)
        let loveContainerVC = loveSB.instantiateViewController(withIdentifier: "LoveContainerVC") as UIViewController
        loveContainerVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "heartTab"), tag: 2)
        
        let flySB: UIStoryboard = UIStoryboard(name: "Fly", bundle: nil)
        let flyNavigationVC = flySB.instantiateViewController(withIdentifier: "FlyNavigationVC") as UIViewController
        flyNavigationVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "planeTab"), tag: 3)
        
        self.viewControllers = [contentFlowNavVC, searchNavVC, loveContainerVC, flyNavigationVC]
        self.selectedIndex = 0
        self.delegate = self
        
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
