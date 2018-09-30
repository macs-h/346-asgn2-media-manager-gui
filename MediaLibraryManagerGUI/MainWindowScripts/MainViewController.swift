//
//  ViewController.swift
//  MediaLibraryManagerGUI
//
//  Created by Fire Breathing Rubber Duckies on 20/09/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

// swiftlint:disable force_cast

import Cocoa
import AppKit

class MainViewController: NSViewController {

    @IBOutlet weak var fileTable: NSTableView!

    var files  = ["image 1", "image 2", "image 3", "image 4"]

    override func viewDidLoad() {
        super.viewDidLoad()
        fileTable.dataSource = self
        fileTable.delegate = self
        fileTable.doubleAction = #selector(doubleClickOnRow)
        fileTable.action = #selector(clickOnRow)
        let mainTopVC = (self.parent?.children[0]) as! MainTopViewController
        mainTopVC.openVC = self
        //selectedFile = Model.instance.currentFile
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func changeCategoryAction(_ sender: NSButton) {
        if sender.tag == 0 {
            //image button
            print("image button pressed")
            //fileTypeSelected = "Image"
        } else if sender.tag == 1 {
            //video button
            print("video button pressed")
            //fileTypeSelected = "Video"
        } else if sender.tag == 2 {
            //music button
            print("music button pressed")
            //fileTypeSelected = "Music"
        } else {
            //other button
            print("other button pressed")
            //fileTypeSelected = "Other"
        }
    }
    
    @objc func doubleClickOnRow() {
        print("doubleClickOnRow \(fileTable.clickedRow)")
        if fileTable.clickedRow == -1 {
            //not clicked on a file
        } else {
            //open file
            Model.instance.switchVC(sourceController: self, segueName: "FileOpenSegue", fileIndex: fileTable.clickedRow)
        }
    }

    @objc func clickOnRow() {
        print("clickOnRow \(fileTable.clickedRow)")

        if fileTable.clickedRow == -1 {
            //not clicked on a file
            
        } else {
             //send file to preview
        }
    }
    //listen for clicks and remove preview if no files were clicked

}

extension MainViewController: NSTableViewDataSource, NSTableViewDelegate {
    //dataSource function
    func numberOfRows(in tableView: NSTableView) -> Int {
        print("num of rows called")
        return files.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        print("making cell \(row)")
        let file = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "fileID"), owner: nil) as! NSTableCellView //FileCell
        
        file.textField!.stringValue = files[row]
        //file.file = collection[row]
        print("file text \(file.textField!.stringValue)")
        return file
    }

}
