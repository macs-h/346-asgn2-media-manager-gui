//
//  FileOpenViewController.swift
//  MediaLibraryManagerGUI
//
//  Created by Fire Breathing Rubber Duckies on 29/09/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

// DOUBLE CHECK

import Cocoa

/**
    FileOpenViewController controls most things when it comes to a open file
 */
class FileOpenViewController: NSViewController, OpenFileModelDegate {
    
    var bookmarkKeys: [String] = []
    var bookmarkValues: [String] = []
    var mainTopVC = MainTopViewController()
    
    @IBOutlet weak var bookmarkTable: NSTableView!
    @IBOutlet weak var notesLabel: NSTextField!
    @IBOutlet weak var bookmarksView: NSView!
    @IBOutlet weak var deleteBookmarkButton: NSButton!
    
    
    //called when view is loaded and sets up controller
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.frame = NSRect(x: 0, y: 100, width: 1280, height: 570)
        bookmarkTable.delegate = self
        bookmarkTable.dataSource = self
        bookmarkTable.doubleAction = #selector(doubleClickOnRow)
        bookmarkTable.action = #selector(clickOnRow)
        mainTopVC = (self.parent?.childViewControllers[0]) as! MainTopViewController
        mainTopVC.openVC = self
        Model.instance.openFileDelegate = self
        Model.instance.showBottomBar(sender: self.parent!)
        changeViewsBasedOnType(type: Model.instance.currentFile!.fileType)
        showMediaContent()
    }
    
    //Tells the Model that it is no longer active
    override func viewDidDisappear() {
        Model.instance.openFileDelegate = nil
    }

    
    // Called when the user presses enter on notes text box.
    @IBAction func NotesAction(_ sender: NSTextFieldCell) {
        print(sender.stringValue)
        Model.instance.addNotes(notes: sender.stringValue)
        //save value by sending metadata to model with key: Notes
    }
 
    
    //------------------------------------------------------------------------80
    // Delegate functions
    //------------------------------------------------------------------------80
    
    /**
        Called by the model to update UI elements.
     
        - parameters:
            - currentFile: currentFile open
            - notes: notes that are loaded and displayed in textfield
            - bookmarks: bookmarks that are added to bookmark table
     */
    func updateOutets(currentFile: MMFile, notes: String, bookmarks: [String:String]) {
        self.notesLabel.stringValue = notes
        self.bookmarkKeys = Array(bookmarks.keys)
        self.bookmarkValues = Array(bookmarks.values)
        bookmarkTable.reloadData()
    }
    
    
    /**
        Decouples the media from the main window.
     */
    func DecoupleMedia() {
        performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "ShowMediaContentSegue"), sender: self)
        self.view.subviews[4].removeFromSuperview() //removes embeded player and shows image behind
    }
    
    
    /**
        Changes the view of the main window depending on the type of media.
     
        - parameter type: The type of document.
     */
    func changeViewsBasedOnType(type: String) {
        if type == "image" || type == "document"{
            //remove bookmarks and adjust media vc
            bookmarksView.isHidden = true //hides the view (might need to remove from superView
        }
    }

    
    // Deletes the selected boomarks
    @IBAction func DeleteBookmarkAction(_ sender: NSButton) {
        let keyToDelete = bookmarkKeys[sender.tag]
        Model.instance.deleteBookmark(keyToDelete: keyToDelete)
    }
}


extension FileOpenViewController : NSTableViewDelegate, NSTableViewDataSource {
    
    /**
        Gets the number of items in the bookmarks panel.
     
        - parameter in: The table to count rows in.
        - returns: The number of items stored in bookmarks.
     */
    func numberOfRows(in tableView: NSTableView) -> Int {
        return bookmarkKeys.count
    }
    
    
    /**
        // TableView delegate function used to populate bookmark table with bookmarks
     
        - parameters:
            - tableView: what table view
            - tableColumn: what column
            - row: what row is currently being populated
        - returns:
     */
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if tableColumn?.title == "KeyColumn"{
            let file = bookmarkTable.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "KeyID"), owner: nil) as! NSTableCellView
            
            file.textField!.stringValue = bookmarkKeys[row]
            return file
        } else {
            let file = bookmarkTable.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ValueID"), owner: nil) as! NSTableCellView
            
            file.textField!.stringValue = bookmarkValues[row]
            return file
        }
    }
    
   
    // Called when user single clicks on a bookmark row (gives option to delete)
    @objc func clickOnRow() {
        //allow users to delete bookmark
        if bookmarkTable.clickedRow != -1 {
            deleteBookmarkButton.isHidden = false
            deleteBookmarkButton.tag = bookmarkTable.clickedRow
        } else {
            //cant delete a bookmark when none is selected
            deleteBookmarkButton.isHidden = true
        }
    }
    
    
    // Called when user double clicks and takes the media to that time
    @objc func doubleClickOnRow() {
        let time = bookmarkValues[bookmarkTable.clickedRow]
        Model.instance.mediaJumpToTime(jumpTo: time)
    }
    
    
    // Used to decouple the window and show the media content from the same time stamp
    func showMediaContent() {
        //shows the media content in the current window
        let mediaType = Model.instance.currentFile?.fileType
        var vc = ""
        switch mediaType {
        case "image":
            vc = "MediaWindowImageVC"
        case "video":
            vc = "MediaWindowVideoVC"
        case "audio":
            vc = "MediaWindowAudioVC"
        case "document":
            vc = "MediaWindowDocumentVC"
        default:
            print("unknown type \(String(describing: mediaType))")
        }
        let newVC = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: vc)) as! NSViewController
        print("before meida subviews \(self.view.subviews)")
        self.view.addSubview(newVC.view)
        let x = (self.view.frame.width/2) - 390
        let y = (self.view.frame.height/2) - 285
        newVC.view.frame = CGRect(x: x, y: y, width: 780, height: 570)
        if mediaType == "video"{
            //to remove the controls
            let mediaPlayerVC = newVC as! MediaWindowVideoVC
            mediaPlayerVC.playerView.controlsStyle = .none
        } else if mediaType == "audio" {
            let mediaPlayerVC = newVC as! MediaWindowAudioVC
            mediaPlayerVC.playerView.controlsStyle = .none
        }
    }
    
}
