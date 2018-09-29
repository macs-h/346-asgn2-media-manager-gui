//
//  MainTopViewController.swift
//  MediaLibraryManagerGUI
//
//  Created by Samuel Paterson on 9/27/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa

class MainTopViewController: NSViewController {
    var splitView: NSViewController = NSViewController()
    var currentFile: MMFile?{
        didSet{
            if currentFile == nil{
                forwardButton.isEnabled = false
            }else{
                forwardButton.isEnabled = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        splitView = self.parent!
    }
    @IBOutlet weak var addFileButton: NSButton! //when file is open disable this button
    
    @IBOutlet weak var backButton: NSButton!
    
    @IBOutlet weak var forwardButton: NSButton!
    
    @IBAction func addFiles(_ sender: Any) {
    }
    
    
    @IBAction func forward_BackPressed(_ sender: NSButton) {
        
        if sender.tag == 0{
            //back button pressed
            
            //exits a file but keeps it selected (can press forward)
            
            let openFileVC = splitView.children[1]
            openFileVC.performSegue(withIdentifier: "MainViewSegue", sender: self)
        }else{
            //forwardButton pressed
            let mainFileVC = splitView.children[1]
            print("child 1: \(mainFileVC.identifier)")
            mainFileVC.performSegue(withIdentifier: "FileOpenSegue", sender: self)
            //opens a file if selected, otherwise disabled
        }
    }
    
    
}
