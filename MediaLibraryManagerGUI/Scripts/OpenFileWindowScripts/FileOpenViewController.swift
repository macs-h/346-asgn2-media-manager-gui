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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        print("fileOpenVC called")
        bookmarkTable.delegate = self
        bookmarkTable.dataSource = self
        bookmarkTable.doubleAction = #selector(doubleClickOnRow)
        bookmarkTable.action = #selector(clickOnRow)
        mainTopVC = (self.parent?.childViewControllers[0]) as! MainTopViewController
        mainTopVC.openVC = self
        Model.instance.openFileDelegate = self
        Model.instance.showBottomBar(sender: self.parent!)
        changeViewsBasedOnType(type: Model.instance.currentFile!.fileType)
    }
    
    override func viewDidDisappear() {
        Model.instance.openFileDelegate = nil
    }
//
    
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
        self.notesLabel.stringValue = currentFile.filename//notes
        self.bookmarkKeys = Array(bookmarks.keys)
        self.bookmarkValues = Array(bookmarks.values)
        bookmarkTable.reloadData()
    }
    
    func openMedia(file: MMFile) {
        
        performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "ShowMediaContentSegue"), sender: self)
    }
    
    func changeViewsBasedOnType(type: String){
        if type == "image" || type == "document"{
            //remove bookmarks and adjust media vc
            bookmarksView.isHidden = true //hides the view (might need to remove from superView
            
        }
    }

}

extension FileOpenViewController : NSTableViewDelegate, NSTableViewDataSource{
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return bookmarkKeys.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        print("making cell \(row)")
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
    
    @objc func doubleClickOnRow(){
        print("double click on bookmark table \(bookmarkTable.clickedRow)")
        if Model.instance.currentFileOpen == nil{
            //no file currently playing so open one
            Model.instance.openFile()
        }
        var time = bookmarkValues[bookmarkTable.clickedRow]
        Model.instance.mediaJumpToTime(jumpTo: time)
    }
    
    @objc func clickOnRow(){
        print("single click on bookmark table \(bookmarkTable.clickedRow)")
        //allow users to delete bookmark
        
    }
    
}
