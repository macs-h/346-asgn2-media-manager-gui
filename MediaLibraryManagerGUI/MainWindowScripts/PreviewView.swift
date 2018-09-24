//
//  PreviewView.swift
//  MediaLibraryManagerGUI
//
//  Created by Samuel Paterson on 9/24/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa

class PreviewView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        NSColor.white.setFill()
        dirtyRect.fill()
        // Drawing code here.
    }
    
}
