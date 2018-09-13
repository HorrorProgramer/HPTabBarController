//
//  BasicTabBarController.swift
//  HPTabBarController_Example
//
//  Created by PangJunJie on 2018/9/13.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import HPTabBarController
import HPTabBarController

class BasicTabBarController: HPTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v1 = ViewController()
        let v2 = ViewController01()
        let v3 = ViewController02()
        
        let v1BarItem = HPTabBarItem.init(title: nil,
                                          image: UIImage(named: "home"),
                                          selectedImage: UIImage(named: "home_1"))
        v1BarItem.contentView?.renderingMode = .alwaysOriginal
        v1.tabBarItem = v1BarItem
        
        let v2BarItem = HPTabBarItem.init(title: nil,
                                          image: UIImage(named: "favor"),
                                          selectedImage: UIImage(named: "favor_1"))
        v2BarItem.contentView?.renderingMode = .automatic
        v2.tabBarItem = v2BarItem
        let v3BarItem = HPTabBarItem.init(title: nil,
                                          image: UIImage(named: "find"),
                                          selectedImage: UIImage(named: "find_1"))
        v3BarItem.contentView?.renderingMode = .automatic
        v3.tabBarItem = v3BarItem
        
        viewControllers = [v1, v2, v3]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
