//
//  FileOpenViewController.swift
//  MediaLibraryManagerGUI
//
//  Created by Sam Paterson on 29/09/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa

class FileOpenViewController: NSViewController, OpenFileModelDegate {

    var bookmarks: [String] = [] //----unsure about type (depends on what media player takes)
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
    @IBAction func previousButtonAction(_ sender: NSButton) {
        //tell model to change the file to the new file
        Model.instance.selectFile(fileIndex: Model.instance.currentFileIndex![0]-1)
    }
    
    @IBAction func playButtonAction(_ sender: Any) {
        //tell the model to play the media
        Model.instance.openFile()
    }


    @IBAction func nextButtonAction(_ sender: NSButton) {
        //tell the model to change to file to the new file
        Model.instance.selectFile(fileIndex: Model.instance.currentFileIndex![0]+1)
    }


    @IBAction func addBookmarksAction(_ sender: NSButton) {
       //tell the model to create a bookmark
        Model.instance.addBookmark()
    }
    
    
    
    //--- degate functions
    /**
     Called by the model to update ui elements
     */
    func updateOutets(currentFile: MMFile, notes: String, bookmarks: [String]) {
        self.notesLabel.stringValue = currentFile.filename//notes
        self.bookmarks = bookmarks
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
        return bookmarks.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        print("making cell \(row)")
        let file = bookmarkTable.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "BookmarkID"), owner: nil) as! NSTableCellView
        
        file.textField!.stringValue = String(bookmarks[row])
        print("file text \(file.textField!.stringValue)")
        return file
    }
    
    @objc func doubleClickOnRow(){
        print("double click on bookmark table \(bookmarkTable.clickedRow)")
    }
    
    @objc func clickOnRow(){
        print("single click on bookmark table \(bookmarkTable.clickedRow)")
    }
    
}
