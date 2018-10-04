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
        
//        Model.instance.loadImage(self, imageView: mediaImageView)
        loadImage()
        
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
        loadImage()
        print("Next called")
    }
    
    func previous() {
        loadImage()
        print("Previous called")
    }
    
    @objc fileprivate func loadImage() {
        Model.instance.loadImage(self, imageView: mediaImageView)
    }
}
