//
//  MainViewParentViewController.swift
//  MediaLibraryManagerGUI
//
//  Created by Sam Paterson on 5/10/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa


//class the holds the subviewControllers and are swaped in and out at run time
class MainViewParentViewController: NSViewController {

    var topBarVC = NSViewController()
    var mainVC = NSViewController()
    var bottomBarVC = NSViewController()
    
    //called when loaded and used to instantiate the first 3 views seen on screen (top, middle, bottom)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let storyb = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        topBarVC = storyb.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "MainTopVC")) as! MainTopViewController
        self.addChildViewController(topBarVC)
        self.view.addSubview(topBarVC.view)
        topBarVC.view.frame = NSRect(x: 0, y: 720-50, width: 1280, height: 50)
        
        
        mainVC = storyb.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "MainVC")) as! MainViewController
        self.addChildViewController(mainVC)
        self.view.addSubview(mainVC.view)
        mainVC.view.frame = NSRect(x: 0, y: 100, width: 1280, height: 570)
        
        
        bottomBarVC = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "BottomBarVC")) as! BottomBarViewController
        self.addChildViewController(bottomBarVC)
        self.view.addSubview(bottomBarVC.view)
        bottomBarVC.view.frame = CGRect(x: 0, y:  0, width: 1280, height: 100)
    }
}
