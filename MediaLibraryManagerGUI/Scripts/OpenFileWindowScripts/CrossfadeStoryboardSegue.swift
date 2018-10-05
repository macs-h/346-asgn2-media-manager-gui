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
    // ---------------- COMMENT THIS ---------------------
 */
class CrossfadeStoryboardSegue: NSStoryboardSegue {
    
    override func perform() {
        let sourceViewController = self.sourceController as! NSViewController
        let destinationViewController = self.destinationController as! NSViewController
        let containerViewController = sourceViewController.parent!
//        print("source \(sourceViewController.title),---- destination \(destinationViewController),---- container  \(sourceViewController.parent) ")
        //containerViewController.removeChildViewController(at: 1)    //removeChild(at: 1)
        if sourceViewController.title == "FileOpenVC"{
            sourceViewController.removeFromParentViewController()
            sourceViewController.view.removeFromSuperview()
        }else{
            containerViewController.addChildViewController(destinationViewController)
            containerViewController.view.addSubview(destinationViewController.view)
        }
        
        
        
        
       // destinationViewController.view.frame = NSRect(x: 0, y: 0, width: 1280, height: 670)
        //insertChild(destinationViewController, at: 1)
//
//        var targetSize = destinationViewController.view.frame.size
//        var targetWidth = destinationViewController.view.frame.size.width
//        var targetHeight = destinationViewController.view.frame.size.height
//
//        sourceViewController.view.wantsLayer = true
//        sourceViewController.view.superview?.wantsLayer = true
//        destinationViewController.view.wantsLayer = true
//
//        containerViewController.transition(from: sourceViewController, to: destinationViewController,
//                                           options: NSViewController.TransitionOptions.crossfade, completionHandler: nil)
//        print("------after break in vc")
//        sourceViewController.view.animator().setFrameSize(targetSize)
//        destinationViewController.view.animator().setFrameSize(targetSize)
//
////        var currentFrame = containerViewController.view.window?.frame
////        var currentRect = NSRectToCGRect(currentFrame!)
////
////        var horizontalChange = (targetWidth - containerViewController.view.frame.size.width)/2
////        var verticalChange = (targetHeight - containerViewController.view.frame.size.height)/2
////
////        var newWindowRect = NSMakeRect(currentRect.origin.x - horizontalChange,
////                                       currentRect.origin.y - verticalChange, targetWidth, targetHeight)
////
////        containerViewController.view.window?.setFrame(newWindowRect, display: true, animate: false)
//        //for child in containerViewController.children{
//           // print("list of children \(child.title)")
//        //}
//        containerViewController.removeChild(at: 2)
    }
}
