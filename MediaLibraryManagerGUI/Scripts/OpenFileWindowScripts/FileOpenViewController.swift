//
//  FileOpenViewController.swift
//  MediaLibraryManagerGUI
//
//  Created by Sam Paterson on 29/09/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa

class FileOpenViewController: NSViewController, OpenFileModelDegate {
    
    var bookmarkKeys: [String] = []
    var bookmarkValues: [String] = []
    @IBOutlet weak var bookmarkTable: NSTableView!
    @IBOutlet weak var notesLabel: NSTextField!
    var mainTopVC = MainTopViewController()
    @IBOutlet weak var bookmarksView: NSView!
    
    @IBOutlet weak var deleteBookmarkButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        bookmarkTable.delegate = self
        bookmarkTable.dataSource = self
        bookmarkTable.doubleAction = #selector(doubleClickOnRow)
        bookmarkTable.action = #selector(clickOnRow)
        mainTopVC = (self.parent?.childViewControllers[0]) as! MainTopViewController
        mainTopVC.openVC = self
        Model.instance.openFileDelegate = self
        print("open parent \(self.parent)")
        Model.instance.showBottomBar(sender: self.parent as! MainViewParentViewController)
        changeViewsBasedOnType(type: Model.instance.currentFile!.fileType)
        showMediaContent()
    }
    
    override func viewDidDisappear() {
        Model.instance.openFileDelegate = nil
    }

    
    /**
        Called when the user presses enter on notes text box
    */
    @IBAction func NotesAction(_ sender: NSTextFieldCell) {
        print(sender.stringValue)
        Model.instance.addNotes(notes: sender.stringValue)
        //save value by sending metadata to model with key: Notes
    }
 
    
    
    
    //--- degate functions
    /**
     Called by the model to update ui elements
     */
    func updateOutets(currentFile: MMFile, notes: String, bookmarks: [String:String]) {
        self.notesLabel.stringValue = notes
        self.bookmarkKeys = Array(bookmarks.keys)
        self.bookmarkValues = Array(bookmarks.values)
        bookmarkTable.reloadData()
    }
    
    func DecoupleMedia() {
        
        performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "ShowMediaContentSegue"), sender: self)
        self.view.subviews[4].removeFromSuperview() //removes embeded player and shows image behind
    }
    
    func changeViewsBasedOnType(type: String){
        if type == "image" || type == "document"{
            //remove bookmarks and adjust media vc
            bookmarksView.isHidden = true //hides the view (might need to remove from superView
            
        }
    }

    @IBAction func DeleteBookmarkAction(_ sender: NSButton) {
        let keyToDelete = bookmarkKeys[sender.tag]
        Model.instance.deleteBookmark(keyToDelete: keyToDelete)
    }
}

extension FileOpenViewController : NSTableViewDelegate, NSTableViewDataSource{
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return bookmarkKeys.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if tableColumn?.title == "KeyColumn"{
            let file = bookmarkTable.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "KeyID"), owner: nil) as! NSTableCellView
            
            file.textField!.stringValue = bookmarkKeys[row]
            //print("file text \(file.textField!.stringValue)")
            return file
        }else{
            let file = bookmarkTable.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ValueID"), owner: nil) as! NSTableCellView
            
            file.textField!.stringValue = bookmarkValues[row]
            //print("file text \(file.textField!.stringValue)")
            return file
        }
    }
    
   
    @objc func clickOnRow(){
        //allow users to delete bookmark
        if bookmarkTable.clickedRow != -1{
            deleteBookmarkButton.isHidden = false
            deleteBookmarkButton.tag = bookmarkTable.clickedRow
        }else{
            //cant delete a bookmark when none is selected
            deleteBookmarkButton.isHidden = true
        }
    }
    
    
    @objc func doubleClickOnRow(){
//        if Model.instance.currentFileOpen == nil{
//            //no file currently playing so open one
//            Model.instance.openFile()
//        }
        let time = bookmarkValues[bookmarkTable.clickedRow]
        Model.instance.mediaJumpToTime(jumpTo: time)
    }
    
    

    func showMediaContent(){
        //shows the media content in the current window
        let mediaType = Model.instance.currentFile?.fileType
        var vc = ""
        switch mediaType {
        case "image":
            vc = "MediaWindowImageVC"
            break
        case "video":
            vc = "MediaWindowVideoVC"
            break
        case "audio":
            vc = "MediaWindowAudioVC"
            break
        case "document":
            vc = "MediaWindowDocumentVC"
            break
        default:
            print("unknown type \(String(describing: mediaType))")
        }
        let newVC = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: vc)) as! NSViewController
        self.view.addSubview(newVC.view)
        let x = (self.view.frame.width/2) - 390
        let y = (self.view.frame.height/2) - 235
        newVC.view.frame = CGRect(x: x, y: y, width: 780, height: 570)
        if mediaType == "video"{
            //to remove the controls
            let mediaPlayerVC = newVC as! MediaWindowVideoVC
            mediaPlayerVC.playerView.controlsStyle = .none
        }else if mediaType == "audio"{
            let mediaPlayerVC = newVC as! MediaWindowAudioVC
            mediaPlayerVC.playerView.controlsStyle = .none
        }
    }
    
}
