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
    var openVC = NSViewController(){ //the open vc (either main or open file) will assign itself to this
        didSet{
            if openVC.title == "MainVC"{
                //main VC is open
                backButton.isEnabled = false
                if Model.instance.currentFile != nil{
                    forwardButton.isEnabled = true
                }
            }else{
                //openfileVC is open
                backButton.isEnabled = true
                forwardButton.isEnabled = false
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
       Model.instance.addFile()
    }
    
    
    @IBAction func forward_BackPressed(_ sender: NSButton) {
        
        if sender.tag == 0{
            //back button pressed
             Model.instance.switchVC(sourceController: openVC, segueName: "MainViewSegue", fileIndex: -1)
        }else{
            //forwardButton pressed
            Model.instance.switchVC(sourceController: openVC, segueName: "FileOpenSegue", fileIndex: -1)
        }
    }
    
    
}
