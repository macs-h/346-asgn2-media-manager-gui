//
//  MediaWindowImageVC.swift
//  MediaLibraryManagerGUI
//
//  Created by Max Huang on 30/09/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa

class MediaWindowImageVC: NSViewController, NSWindowDelegate, bottomBarDelegate {
   
    
    
    @IBOutlet weak var mediaImageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        NSLog("MediaWindowImageVC loaded")
        // get size of frame print it be sure it is the same aaslways
//        print("-- self.view.frame:", self.view.frame)
//
//
//        //--------------------
//        // read your image
//        var image = NSImage(contentsOfFile: (Model.instance.currentFile?.fullpath)!)
//        //--------------------
//
//
//        // transfor image scale width and height to view
//        mediaImageView.frame = self.view.frame
//        print("-- mediaImageView.frame:", self.view.frame)
//
//        print("-- image size:", image?.size)
//
//        // scaling imaghe
//        image = image?.resizeMaintainingAspectRatio(withSize: NSSize(width: 800, height: 450))
//
//        print("-- image size:", image?.size)
//
//        // fit the image to the view
//        mediaImageView.image = image
        
        Model.instance.loadImage(self, imageView: mediaImageView)
        
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
