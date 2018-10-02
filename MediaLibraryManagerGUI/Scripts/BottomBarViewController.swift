//
//  BottomBarViewController.swift
//  MediaLibraryManagerGUI
//
//  Created by Sam Paterson on 2/10/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa

class BottomBarViewController: NSViewController {

    @IBOutlet weak var previousButton: NSButton!
    @IBOutlet weak var play_pauseButton: NSButton!
    @IBOutlet weak var nextButton: NSButton!
    @IBOutlet weak var bookmarkButton: NSButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        print(">>> bar is load")
    }
    
    @IBAction func PreviousAction(_ sender: NSButton) {
        //tell model to change the file to the new file
        Model.instance.selectFile(fileIndex: Model.instance.currentFileIndex![0]-1)
    }
    @IBAction func play_pauseAction(_ sender: NSButton) {
        //tell the model to play the media
        Model.instance.openFile()
    }
    
    
    @IBAction func nextAction(_ sender: NSButton) {
        //tell the model to change to file to the new file
        print("next action")
        Model.instance.selectFile(fileIndex: Model.instance.currentFileIndex![0]+1)
        
    }
    
    @IBAction func bookmarkAction(_ sender: NSButton) {
        //tell the model to create a bookmark
        Model.instance.addBookmark()
    }
    
    
    @IBAction func test(_ sender: Any) {
        print("---test")
    }
    
    func updateOutlets(){
//        if Model.instance.currentFileIndex![0]+1 >= Model.instance.subLibrary.all().count{
//            //hide forward button
//            nextButton.isEnabled = false
//        }else{
//            nextButton.isEnabled = true
//        }
//        if Model.instance.currentFileIndex![0]-1 < 0{
//            //hide backwards button
//            previousButton.isEnabled = false
//        }else{
//            previousButton.isEnabled = true
//        }
    }
    
}
