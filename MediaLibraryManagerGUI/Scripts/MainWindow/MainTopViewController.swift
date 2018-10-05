//
//  MainTopViewController.swift
//  MediaLibraryManagerGUI
//
//  Created by Samuel Paterson on 9/27/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa

class MainTopViewController: NSViewController {
    @IBOutlet weak var logoImage: NSImageView!
    
    @IBOutlet weak var fileNameLabel: NSTextField!
    
    @IBOutlet weak var addFileButton: NSButton! //when file is open disable this button
    @IBOutlet weak var backButton: NSButton!
    @IBOutlet weak var forwardButton: NSButton!
    @IBOutlet weak var searchBar: NSSearchField!
    
    
    var splitView: NSViewController = NSViewController()
    
    var openVC = NSViewController(){ //the open vc (either main or open file) will assign itself to this
        didSet{
            if openVC.title == "MainVC"{
                //main VC is open
                backButton.isEnabled = false
                if Model.instance.currentFile != nil{
                    forwardButton.isEnabled = true
                }
                logoImage.isHidden = false
                fileNameLabel.isHidden = true
                searchBar.isHidden = false
            }else{
                //openfileVC is open
                backButton.isEnabled = true
                forwardButton.isEnabled = false
                fileNameLabel.stringValue = Model.instance.currentFile!.filename
                logoImage.isHidden = true
                fileNameLabel.isHidden = false
                searchBar.isHidden = true
            }
        }
    }
    
   
    
    @IBAction func addFiles(_ sender: Any) {
       Model.instance.addFile(sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        splitView = self.parent as! MainViewParentViewController
        
        self.view.window?.styleMask = .texturedBackground
        self.view.window?.backgroundColor = .black
       
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
}
