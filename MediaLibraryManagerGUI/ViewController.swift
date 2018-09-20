//
//  ViewController.swift
//  MediaLibraryManagerGUI
//
//  Created by Fire Breathing Rubber Duckies on 20/09/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var fileTable: NSTableView!
    
    var files  = ["image 1", "image 2", "image 3", "image 4"]
    override func viewDidLoad() {
        super.viewDidLoad()
        fileTable.dataSource = self
        fileTable.delegate = self
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func changeCategoryAction(_ sender: NSButton) {
        if(sender.tag == 0){
            //image button
            print("image button pressed")
        }else if (sender.tag == 1){
            //video button
            print("video button pressed")
        }else if (sender.tag == 2){
            //music button
            print("music button pressed")
        }else{
            //other button
            print("other button pressed")
        }
    }
    
}

extension ViewController: NSTableViewDataSource, NSTableViewDelegate{
    //dataSource function
    func numberOfRows(in tableView: NSTableView) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        print("making cell \(row)")
        let file = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as! NSTableCellView
        file.textField!.stringValue = files[row]
        print("file text \(file.textField!.stringValue)")
        return file
    }
}

