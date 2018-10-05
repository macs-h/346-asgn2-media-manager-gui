//
//  PreviewView.swift
//  MediaLibraryManagerGUI
//
//  Created by Fire Breathing Rubber Duckies on 30/09/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

// DOUBLE CHECK

import Cocoa

/**
    // ---------------- COMMENT THIS ---------------------
 */
class PreviewView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        NSColor.gridColor.setFill()
        NSBezierPath.fill(self.bounds)
    }   
}
