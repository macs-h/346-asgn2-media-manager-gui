//
//  PreviewView.swift
//  MediaLibraryManagerGUI
//
//  Created by Sam Paterson on 30/09/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa

class PreviewView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSColor.gridColor.setFill()
        //NSRectFill(dirtyRect)
        NSBezierPath.fill(self.bounds)
    }
    
}
