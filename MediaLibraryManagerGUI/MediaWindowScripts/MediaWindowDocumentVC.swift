//
//  MediaWindowDocumentVC.swift
//  MediaLibraryManagerGUI
//
//  Created by Max Huang on 2/10/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa

class MediaWindowDocumentVC: NSViewController, bottomBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        print("LOADED")
        
        //makes the below functions work
        Model.instance.bottomBarVC?.delegte = self
    }
    
    func play() {
        //!!!!DONT IMPLEMENT
    }
    
    func pause() {
        //!!!!DONT IMPLEMENT
    }
    
    func next() {
        print("Next called")
    }
    
    func previous() {
        print("Previous called")
    }
    
}
