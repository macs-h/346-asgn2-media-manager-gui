//
//  PreviewViewController.swift
//  MediaLibraryManagerGUI
//
//  Created by Sam Paterson on 21/09/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa

class PreviewViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    var file = MM_File()

    @IBOutlet weak var PreviewImage: NSImageView!

    @IBOutlet weak var fileNameLabel: NSTextField!


    @IBOutlet weak var metadataTable: NSTableView!
    
    @IBOutlet weak var notesLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        fileNameLabel.stringValue = file.filename
        //asign pic if it has one
        //assign notes if it has any
        
        metadataTable.dataSource = self
        metadataTable.delegate = self
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        print("num of rows called")
        return file.metadata.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        print("making cell \(row)")
        let fileCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "fileID"), owner: nil) as! NSTableCellView //FileCell
        
        fileCell.textField!.stringValue = file.metadata[row].value //might need to show key in another coloumn aswell
        //file.file = collection[row]
        print("file text \(fileCell.textField!.stringValue)")
        return fileCell
    }
}
