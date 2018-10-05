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
    MainTopViewController class used for controlling the top bar controls
 */
class MainTopViewController: NSViewController {
    
    @IBOutlet weak var fileNameLabel: NSTextField!
    
    @IBOutlet weak var addFileButton: NSButton! //when file is open disable this button
    @IBOutlet weak var backButton: NSButton!
    @IBOutlet weak var forwardButton: NSButton!
    @IBOutlet weak var searchBar: NSSearchField!
    
    
    var splitView: NSViewController = NSViewController()
    
    //changes what is enabled or disabled because of what screen your on
    var openVC = NSViewController(){ //the open vc (either main or open file) will assign itself to this
        didSet{
            if openVC.title == "MainVC"{
                //main VC is open
                backButton.isEnabled = false
                if Model.instance.currentFile != nil {
                    forwardButton.isEnabled = true
                }
                fileNameLabel.isHidden = true
                searchBar.isHidden = false
            }else{
                //openfileVC is open
                backButton.isEnabled = true
                forwardButton.isEnabled = false
                fileNameLabel.stringValue = Model.instance.currentFile!.filename
                fileNameLabel.isHidden = false
                searchBar.isHidden = true
            }
        }
    }
    
   
    //import a new json file by clicking + button
    @IBAction func addFiles(_ sender: Any) {
        Model.instance.addFile()
    }
    
    //Called when the view was loaded to set up the controller
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        splitView = self.parent as! MainViewParentViewController
        
        self.view.window?.styleMask = .texturedBackground
        self.view.window?.backgroundColor = .black
        Model.instance.mainTopbar = self
    }
    
    
    /**
        Called by both buttons and moves to the other view depending on what was pressed
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
        Controlled by search bar, updated after every string change making it able to "live" search
     */
    @IBAction func searchAcion(_ sender: NSSearchField) {
        if sender.stringValue != ""{
            let searchTerms = sender.stringValue.components(separatedBy: " ")
            Model.instance.searchStrings(searchTerms: searchTerms)
        }else{
            var catIndex = 0
            if let index = Model.instance.currentFileIndex{
                catIndex = index[1]
            }
            Model.instance.changeCategory(catIndex: catIndex)
            let mainVC = Model.instance.mainViewDegate as! MainViewController
            let indexPath = IndexSet(arrayLiteral: catIndex)
            mainVC.categoryTable.selectRowIndexes(indexPath, byExtendingSelection: false)
        }
    }
    
    func updateTopBar(){
        fileNameLabel.stringValue = (Model.instance.currentFile?.filename)!
    }
}
