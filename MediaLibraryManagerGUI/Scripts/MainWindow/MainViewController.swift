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

class MainViewController: NSViewController, MainViewModelDegate {
    
    @IBOutlet weak var fileTable: NSTableView!
    @IBOutlet weak var categoryTable: NSTableView!
    
    var files: [MMFile] = []
    var previewVC: PreviewViewController?
    let categories = ["Images","Audio","Video", "Documents"]
    
    
    
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
    
    func updateOutets(files: [MMFile]) {
        self.files = files
        fileTable.reloadData()
        if let currentIndex = Model.instance.currentFileIndex{
            if Model.instance.currentCategoryIndex == currentIndex[1]{
                let indexPath = IndexSet(arrayLiteral: currentIndex[0])
                fileTable.selectRowIndexes(indexPath, byExtendingSelection: false)
                //previewVC = Model.instance.showPreview(sender: self, preview_VC: previewVC, fileIndex: currentIndex[0])
            }
        }
        if Model.instance.currentCategoryIndex == -1{
            categoryTable.deselectAll(self)
        }
        
    }

    @objc func clickOnCategory(_ sender: NSButton) {
       Model.instance.changeCategory(catIndex: categoryTable.clickedRow)
        
        if previewVC != nil{
            Model.instance.removePreview(sender: self, previewVC: previewVC!) //if we want to remove the preview if another category is selected
            previewVC = nil
        }
    }
    
    @objc func doubleClickOnRow() {
        //print("doubleClickOnRow \(fileTable.clickedRow)")
        if fileTable.clickedRow == -1 {
            //not clicked on a file
        } else {
            //open file
            //cancel preview showing
            Model.instance.switchVC(sourceController: self, segueName: "FileOpenSegue", fileIndex: fileTable.clickedRow)
        }
    }

    @objc func clickOnRow() {
        //print("clickOnRow \(fileTable.clickedRow)")

        if fileTable.clickedRow == -1 {
            //not clicked on a file
            //previewVC?.view.removeFromSuperview()
            if previewVC != nil{
                Model.instance.removePreview(sender: self, previewVC: previewVC!)
                previewVC = nil
            }
        } else {
             //send file to preview
            if previewVC == nil{
                //not active
                previewVC = Model.instance.showPreview(sender: self, preview_VC: previewVC, fileIndex: fileTable.clickedRow)
            }else{
                //update data
                previewVC = Model.instance.showPreview(sender: self, preview_VC: previewVC, fileIndex: fileTable.clickedRow)
            }
        }
    }
    //listen for clicks and remove preview if no files were clicked

}

extension MainViewController: NSTableViewDataSource, NSTableViewDelegate {
    //dataSource function
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == fileTable{
            return files.count//Model.instance.library.collection.count //subLibrary.all().count
        }else{
            return categories.count
        }
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableView == fileTable{
            //print("making cell \(row)")
            let file = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "fileID"), owner: nil) as! NSTableCellView //FileCell
            
            file.textField!.stringValue = files[row].filename//Model.instance.library.collection[row].filename//subLibrary.all()[row].filename
            //file.file = collection[row]
            print("file text \(file.textField!.stringValue)")
            return file
        }else{
            //CategoryTableView
            let cat = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CategoryID"), owner: nil) as! NSTableCellView
            cat.textField!.stringValue = categories[row]
            return cat
        }
    }

}
