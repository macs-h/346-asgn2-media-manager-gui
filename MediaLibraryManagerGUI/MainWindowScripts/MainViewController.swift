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
    //var collection = [MM_File()]
    var fileIsSelected = false // indicates if a file is selected -----(needs an observer so we know when to remove the preview)
    var selectedFile: MMFile?{
        didSet{
            mainTopVC.currentFile = selectedFile
            Model.instance.currentFile = selectedFile
        }
    }
    var fileTypeSelected = ""
    var mainTopVC = MainTopViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        fileTable.dataSource = self
        fileTable.delegate = self
        fileTable.doubleAction = #selector(doubleClickOnRow)
        fileTable.action = #selector(clickOnRow)
        mainTopVC = (self.parent?.children[0]) as! MainTopViewController
        selectedFile = Model.instance.currentFile
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
            fileTypeSelected = "Image"
        } else if sender.tag == 1 {
            //video button
            print("video button pressed")
            fileTypeSelected = "Video"
        } else if sender.tag == 2 {
            //music button
            print("music button pressed")
            fileTypeSelected = "Music"
        } else {
            //other button
            print("other button pressed")
            fileTypeSelected = "Other"
        }
    }
    @objc func doubleClickOnRow() {
        print("doubleClickOnRow \(fileTable.clickedRow)")
        if fileTable.clickedRow == -1 {
            //not clicked on a file
            fileIsSelected = false
        } else {
            //open file
            fileIsSelected = true //might need to set to false so preview is nolonger open when pressing back
//            openFileVC()
            performSegue(withIdentifier: "FileOpenSegue", sender: self)
            print("trying to segue no")
        }
    }
    
//    func openFileVC(){
//        let openFileVC = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "OpenFileVC") as! FileOpenViewController
//        self.insertChild(openFileVC, at: 0)
//        self.view.addSubview(openFileVC.view)
//        self.view.replaceSubview(self.view, with: openFileVC.view)
//        self.view.frame = openFileVC.view.frame
//        print("controller opened")    }
    
    
    //opens a new window (kinda) rather that opening in same one
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {

        if segue.identifier == "FileOpenSegue" {
            print("trying to segue")
            let destinationVC = segue.destinationController as! FileOpenViewController
            destinationVC.setUp(file: selectedFile!, type: fileTypeSelected)
        }
    }

    @objc func clickOnRow() {
        print("clickOnRow \(fileTable.clickedRow)")
        
        if fileTable.clickedRow == -1 {
            //not clicked on a file
            fileIsSelected = false
            selectedFile = nil
        } else {
             //send file to preview
            fileIsSelected = true
            let tempFile = MM_File()
            tempFile.filename = String(fileTable.clickedRow)
            selectedFile = tempFile
            //            fileSelected = Model.instance.subLibary.collection[fileTable.clickedRow]
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
