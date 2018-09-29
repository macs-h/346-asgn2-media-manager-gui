//
//  FileOpenViewController.swift
//  MediaLibraryManagerGUI
//
//  Created by Sam Paterson on 29/09/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa

class FileOpenViewController: NSViewController {
    var file: MMFile!
    var bookmarks: [float_t] = [0.0, 0.1, 0.2] //----unsure about type (depends on what media player takes)
    @IBOutlet weak var bookmarkTable: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        print("fileOpenVC called")
        bookmarkTable.delegate = self
        bookmarkTable.dataSource = self
        bookmarkTable.doubleAction = #selector(doubleClickOnRow)
        bookmarkTable.action = #selector(clickOnRow)
    }
    
    /**
     ----This could go the model???
    */
    func setUp(file: MMFile, type: String){
        self.file = file
        if type == "Video" {
            //play the video
        }else if type == "Image" {
            //show the image
            //disable play button
        }else if type == "Music" {
            //play the music
        }else{
            //show other
        }
    }
    /**
        Called when the user presses enter on text box
    */
    @IBAction func NotesAction(_ sender: NSTextFieldCell) {
        print(sender.stringValue)
        //save value by sending metadata to model with key: Notes
    }
    @IBAction func previousButtonAction(_ sender: NSButton) {
        //tell model to change the file to the new file
    }
    
    @IBAction func playButtonAction(_ sender: Any) {
        //tell the model to play the media
    }
    
    
    @IBAction func nextButtonAction(_ sender: NSButton) {
        //tell the model to change to file to the new file
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MainViewSegue" {
            print("trying to segue")
            //let destinationVC = segue.destinationController as! MainViewController
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
