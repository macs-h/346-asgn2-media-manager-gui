//
//  MainViewParentViewController.swift
//  MediaLibraryManagerGUI
//
//  Created by Sam Paterson on 5/10/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa

class MainViewParentViewController: NSViewController {

    var topBarVC = NSViewController()
    var mainBarVC = NSViewController()
    
            var bottomBarVC = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "BottomBarVC")) as! BottomBarViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let storyb = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        topBarVC = storyb.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "MainTopVC")) as! MainTopViewController
        self.addChildViewController(topBarVC)
        self.view.addSubview(topBarVC.view)
        topBarVC.view.frame = NSRect(x: 0, y: 720-50, width: 1280, height: 50)
        
        
        mainBarVC = storyb.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "MainVC")) as! MainViewController
        self.addChildViewController(mainBarVC)
        self.view.addSubview(mainBarVC.view)
        mainBarVC.view.frame = NSRect(x: 0, y: 0, width: 1280, height: 670)
        
//        self.addChildViewController(bottomBarVC)
//        self.view.addSubview(bottomBarVC.view)
//        bottomBarVC.view.frame = CGRect(x: 0, y:  0, width: 1280, height: 100)
//        bottomBarVC.viewWillAppear();
        
        

//

        
    }
    
    func openBottom(){
//        self.bottomBarVC = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "BottomBarVC")) as! BottomBarViewController
////
////        let bottomBarVC = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "BottomBarVC")) as! BottomBarViewController
//
//        self.addChildViewController(bottomBarVC)
//        self.view.addSubview(bottomBarVC.view)
//        bottomBarVC.view.frame = CGRect(x: 0, y:  0, width: 1280, height: 100)
//        bottomBarVC.viewWillAppear();
        
        
        
//
//                self.addChildViewController(bottomBarVC)
//                self.view.addSubview(bottomBarVC.view)
//                bottomBarVC.view.frame = CGRect(x: 0, y:  0, width: 1280, height: 100)
//        let bottomBarVC = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "BottomBarVC")) as! BottomBarViewController
//        bottomBarVC.view.layer?.removeAllAnimations()
//        self.addChildViewController(bottomBarVC)
//        self.view.addSubview(bottomBarVC.view)
//        bottomBarVC.view.frame = CGRect(x: 0, y:  0, width: 1280, height: 100)
//        bottomBarVC.view.wantsLayer = true
//        let animation = CABasicAnimation(keyPath: "position")
//        let startingPoint = CGRect(x: 0, y: -100, width: 1280, height: 100)
//        let endingPoint = CGRect(x: 0, y: 0, width: 1280, height: 100)
//        animation.fromValue = startingPoint
//        animation.toValue = endingPoint
//        animation.repeatCount = 1
//        animation.duration = 0.3
//        bottomBarVC.view.layer?.add(animation, forKey: "linearMovement")
    }
    
}
