//
//  MediaChangeVC.swift
//  MediaLibraryManagerGUI
//
//  Created by Max Huang on 2/10/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa

class MediaChangeVC: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        let mediaType = Model.instance.currentFile?.fileType
        
        if mediaType == "image" {
            performSegue(withIdentifier: "SegueToImage", sender: self)
        } else if mediaType == "document" {
            performSegue(withIdentifier: "SegueToDocument", sender: self)
        } else if mediaType == "audio" {
            performSegue(withIdentifier: "SegueToAudio", sender: self)
        } else if mediaType == "video" {
            performSegue(withIdentifier: "SegueToVideo", sender: self)
        } else {
            NSLog("Media type \"\(String(describing: mediaType))\" does not exist")
        }
        
    }
    
}
