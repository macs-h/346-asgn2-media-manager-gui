//
//  ViewController.swift
//  MediaLibraryManagerGUI
//
//  Created by Fire Breathing Rubber Duckies on 20/09/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa
import AppKit

/**
    MainViewController is the first large view that is displayed so deals with
    some init activities
 */
class MainViewController: NSViewController, MainViewModelDegate {
    
    @IBOutlet weak var fileTable: NSTableView!
    @IBOutlet weak var categoryTable: NSTableView!
    
    var files: [MMFile] = []
    var previewVC: PreviewViewController?
    let categories = ["Images", "Audio", "Video", "Documents"]
    
    // Called When view first loads and sets up viewController to work as intended
    override func viewDidLoad() {
        super.viewDidLoad()
        fileTable.dataSource = self
        fileTable.delegate = self
        fileTable.doubleAction = #selector(doubleClickOnRow)
        fileTable.action = #selector(clickOnRow)
        
        categoryTable.dataSource = self
        categoryTable.delegate = self
        categoryTable.action = #selector(clickOnCategory)
        
        let mainTopVC = (self.parent?.childViewControllers[0]) as! MainTopViewController
        mainTopVC.openVC = self
        Model.instance.mainViewDegate = self
        let indexPath = IndexSet(arrayLiteral: Model.instance.currentCategoryIndex)
        categoryTable.selectRowIndexes(indexPath, byExtendingSelection: false)
        if let currentIndex = Model.instance.currentFileIndex{
            previewVC = Model.instance.showPreview(sender: self, preview_VC: previewVC, fileIndex: currentIndex[0])
        }
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
    /**
        Called by the Model to tell this controller that somethings have changed
        it should check to see if it is affected (and do something if it is)
     */
    func updateOutets(files: [MMFile]) {
        self.files = files
        fileTable.reloadData()
        if let currentIndex = Model.instance.currentFileIndex {
            if Model.instance.currentCategoryIndex == currentIndex[1] {
                let indexPath = IndexSet(arrayLiteral: currentIndex[0])
                fileTable.selectRowIndexes(indexPath, byExtendingSelection: false)
            }
        }
        if Model.instance.currentCategoryIndex == -1{
            categoryTable.deselectAll(self)
        }
        
    }

    
    /**
        Called when a single click is performed on the category table which changes
        Category
     */
    @objc func clickOnCategory(_ sender: NSButton) {
       Model.instance.changeCategory(catIndex: categoryTable.clickedRow)
        
        if previewVC != nil{
            Model.instance.removePreview(sender: self, previewVC: previewVC!) //if we want to remove the preview if another category is selected
            previewVC = nil
        }
    }
    
    
    /**
        Called when user double clicks on file in table,
        opens that file in new view by notifying model
     */
    @objc func doubleClickOnRow() {
        if fileTable.clickedRow == -1 {
            //not clicked on a file
        } else {
            //open file
            //cancel preview showing
            Model.instance.switchVC(sourceController: self, segueName: "FileOpenSegue", fileIndex: fileTable.clickedRow)
        }
    }

    
    /**
        Called when user single clicks on a row and shows the preview of that file
     */
    @objc func clickOnRow() {

        if fileTable.clickedRow == -1 {
            //not clicked on a file
            if previewVC != nil {
                Model.instance.removePreview(sender: self, previewVC: previewVC!)
                previewVC = nil
            }
        } else {
             //send file to preview
            if previewVC == nil {
                //not active
                previewVC = Model.instance.showPreview(sender: self, preview_VC: previewVC, fileIndex: fileTable.clickedRow)
            }else{
                //update data
                previewVC = Model.instance.showPreview(sender: self, preview_VC: previewVC, fileIndex: fileTable.clickedRow)
            }
        }
    }

}

extension MainViewController: NSTableViewDataSource, NSTableViewDelegate {
    /**
        TableView delegate function used to tell tableView how many rows to make
     */
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == fileTable {
            return files.count
        } else {
            return categories.count
        }
    }

    
    /**
        TableView delegate function used to populate the rows with approprate data
     */
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableView == fileTable {
            //file table
            let file = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "fileID"), owner: nil) as! NSTableCellView
            
            file.textField!.stringValue = files[row].filename
            print("file text \(file.textField!.stringValue)")
            return file
        } else {
            //CategoryTableView
            let cat = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CategoryID"), owner: nil) as! NSTableCellView
            cat.textField!.stringValue = categories[row]
            return cat
        }
    }

}
