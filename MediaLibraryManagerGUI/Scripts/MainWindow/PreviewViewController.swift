//
//  PreviewViewController.swift
//  MediaLibraryManagerGUI
//
//  Created by Sam Paterson on 21/09/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa

class PreviewViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    var file = MM_File() //assigned by mainVC before this is opened
    var metadata: [MMMetadata] = []
    @IBOutlet weak var previewImage: NSImageView!

    @IBOutlet weak var fileNameLabel: NSTextField!

    @IBOutlet weak var metadataTable: NSTableView!
    
    @IBOutlet weak var notesLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        //asign pic if it has one
        //assign notes if it has any
        
        metadataTable.dataSource = self
        metadataTable.delegate = self
    }
    
    func setup(file: MMFile){

        self.file = file as! MM_File
        fileNameLabel.stringValue = file.filename
        
        let notesMetadataIndex = file.searchMetadata(keyword: "notes")
        if notesMetadataIndex != -1 {
            let notes = file.metadata[notesMetadataIndex].value
            notesLabel.stringValue = notes
        }
        metadata.removeAll()
        for meta in file.metadata{
            if meta.keyword != "bookmarks" && meta.keyword != "notes"{
                metadata.append(meta)
            }
        }
        metadataTable.reloadData()
        
        let image = NSImage(contentsOfFile: file.fullpath)
        if image == nil{
            //show default image by using the type
        }
        previewImage.image = image
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return metadata.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableColumn?.title == "Key" {
            //key column
            //print("making cell \(row)")
            let keyCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MetadataKeyCol"), owner: nil) as! NSTableCellView //FileCell
            keyCell.textField!.stringValue = metadata[row].keyword //might need to show key in another coloumn aswell
            keyCell.textField?.textColor = NSColor.gray
            keyCell.textField?.alignment = NSTextAlignment.right
            
            return keyCell
        }else{
            //value column
            //print("making cell \(row)")
            let valueCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MetadataValueCol"), owner: nil) as! NSTableCellView //FileCell
            valueCell.textField!.stringValue = metadata[row].value //might need to show key in another coloumn aswell
            return valueCell
        }
    }
}
