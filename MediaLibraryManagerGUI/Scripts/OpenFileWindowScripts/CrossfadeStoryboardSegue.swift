//
//  CrossfadeStoryboardSegue.swift
//  MediaLibraryManagerGUI
//
//  Created by Fire Breathing Rubber Duckies on 29/09/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

// DOUBLE CHECK

import Cocoa

/**
    Custom segue used to change between the two main views while staying in the same window
 */
class CrossfadeStoryboardSegue: NSStoryboardSegue {
    //Called when performSegue() is called
    override func perform() {
        let sourceViewController = self.sourceController as! NSViewController
        let destinationViewController = self.destinationController as! NSViewController
        let containerViewController = sourceViewController.parent!
        if sourceViewController.title == "FileOpenVC"{
            sourceViewController.removeFromParentViewController()
            sourceViewController.view.removeFromSuperview()
        }else{
            containerViewController.addChildViewController(destinationViewController)
            containerViewController.view.addSubview(destinationViewController.view)
        }
    }
}
