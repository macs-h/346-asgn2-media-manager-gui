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
    @IBOutlet weak var label: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        print("fileOpenVC called")
        
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
            let destinationVC = segue.destinationController as! MainViewController
        }
    }
}
