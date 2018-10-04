//
//  MediaWindowAudioVC.swift
//  MediaLibraryManagerGUI
//
//  Created by Max Huang on 2/10/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa

class MediaWindowAudioVC: NSViewController, bottomBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        //makes the below functions work
        Model.instance.bottomBarVC?.delegte = self
    }
    
    func play() {
        print("Play called")
    }
    
    func pause() {
        print("Pause called")
    }
    
    func next() {
        print("Next called")
    }
    
    func previous() {
        print("Previous called")
    }

}
