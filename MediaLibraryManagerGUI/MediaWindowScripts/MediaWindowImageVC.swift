//
//  MediaWindowImageVC.swift
//  MediaLibraryManagerGUI
//
//  Created by Max Huang on 30/09/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa

class MediaWindowImageVC: NSViewController, NSWindowDelegate {
    
    @IBOutlet weak var mediaImageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        NSLog("MediaWindowImageVC loaded")
        // get size of frame print it be sure it is the same aaslways
        print("-- self.view.frame:", self.view.frame)
        // read your imaghe
        var image = NSImage(contentsOfFile: (Model.instance.currentFile?.fullpath)!)
        
        // transfor image scale width and height to view
        mediaImageView.frame = self.view.frame
        print("-- mediaImageView.frame:", self.view.frame)
        
        print("-- image size:", image?.size)
        // scaling imaghe
        image = image?.resizeMaintainingAspectRatio(withSize: NSSize(width: 800, height: 450))
        
        print("-- image size:", image?.size)
        
        // fit the image to the view
        mediaImageView.image = image

//        mediaImageView.image = NSImage(contentsOfFile: (Model.instance.currentFile?.fullpath)!)
//        mediaImageView.imageScaling = .scaleProportionallyUpOrDown
        
        
//        mediaImageView.frame = NSRect(x: 0, y: 0, width: 800, height: 450)
    }
    
//    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
//        mediaImageView.frame = NSRect(x: mediaImageView.frame.minX, y: mediaImageView.frame.minY, width: frameSize.width, height: frameSize.height)
//        return frameSize
//    }
    
    
    
    
}
