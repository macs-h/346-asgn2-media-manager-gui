//
//  MainTopViewController.swift
//  MediaLibraryManagerGUI
//
//  Created by Samuel Paterson on 9/27/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa

class MainTopViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
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
            let splitView = self.parent
            let openFileVC = splitView?.children[1]
            performSegue(withIdentifier: "MainViewSegue", sender: openFileVC)
            print("trying to go back in button")
        }else{
            //forwardButton pressed
            
            //opens a file if selected, otherwise disabled
        }
    }
    
    //opens a new window (kinda) rather that opening in same one
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MainViewSegue" {
            print("trying to segue")
            let destinationVC = segue.destinationController as! MainViewController
            print("trying to go back")
        }
    }
    
}
