//
//  MainTopViewController.swift
//  MediaLibraryManagerGUI
//
//  Created by Fire Breathing Rubber Duckies on 9/27/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

// DOUBLE CHECK

import Cocoa

/**
    // ---------------- COMMENT THIS ---------------------
 */
class MainTopViewController: NSViewController {
    var splitView: NSViewController = NSViewController()
    var openVC = NSViewController() { // the open vc (either main or open file) will assign itself to this
        didSet {
            if openVC.title == "MainVC" {
                //main VC is open
                backButton.isEnabled = false
                if Model.instance.currentFile != nil {
                    forwardButton.isEnabled = true
                }
                logoImage.isHidden = false
                fileNameLabel.isHidden = true
            } else {
                //openfileVC is open
                backButton.isEnabled = true
                forwardButton.isEnabled = false
                fileNameLabel.stringValue = Model.instance.currentFile!.filename
                logoImage.isHidden = true
                fileNameLabel.isHidden = false
            }
        }
    }
    
    @IBOutlet weak var logoImage: NSImageView!
    @IBOutlet weak var fileNameLabel: NSTextField!
    @IBOutlet weak var addFileButton: NSButton! //when file is open disable this button
    @IBOutlet weak var backButton: NSButton!
    @IBOutlet weak var forwardButton: NSButton!
    @IBAction func addFiles(_ sender: Any) {
        Model.instance.addFile()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitView = self.parent!
        
        self.view.window?.styleMask = .texturedBackground
        self.view.window?.backgroundColor = .black
        Model.instance.mainTopbar = self
    }
    
    
    /**
        // ---------------- COMMENT THIS ---------------------
     */
    @IBAction func forward_BackPressed(_ sender: NSButton) {
        if sender.tag == 0{
            // back button pressed
             Model.instance.switchVC(sourceController: openVC, segueName: "MainViewSegue", fileIndex: -1)
        } else {
            // forward button pressed
            Model.instance.switchVC(sourceController: openVC, segueName: "FileOpenSegue", fileIndex: -1)
        }
    }
    
    
    /**
        // ---------------- COMMENT THIS ---------------------
     */
    @IBAction func searchAcion(_ sender: NSSearchField) {
        let searchTerms = sender.stringValue.components(separatedBy: " ")
        Model.instance.searchStrings(searchTerms: searchTerms)
    }
}
