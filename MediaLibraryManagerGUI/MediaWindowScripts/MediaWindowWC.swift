//
//  MediaWindowWC.swift
//  MediaLibraryManagerGUI
//
//  Created by Max Huang on 29/09/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa

class MediaWindowWC: NSWindowController, NSWindowDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()
        
    }
    
    func windowWillClose(_ notification: Notification) {
        //tell the model that the window is no longer open
        Model.instance.currentFileOpen = nil
    }

}
