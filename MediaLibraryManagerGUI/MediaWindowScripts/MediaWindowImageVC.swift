//
//  MediaWindowImageVC.swift
//  MediaLibraryManagerGUI
//
//  Created by Fire Breathing Rubber Duckies on 30/09/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa

/**
    View controller for displaying the image media files.
 */
class MediaWindowImageVC: NSViewController, NSWindowDelegate, bottomBarDelegate {
   
    @IBOutlet weak var mediaImageView: NSImageView!
    
    // Loads the selected image file.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImage()
        
        // Provides functionality for the following functions.
        Model.instance.bottomBarVC?.delegte = self
    }
    
    
    // These two functions are only used for audio/video files.
    func play() {}
    func pause() {}

    
    // Advances to the next image, if one exists.
    func next() {
        loadImage()
    }

    
    // Backs up to the previous image, if one exists.
    func previous() {
        loadImage()
    }
    
    
    // Loads the image into the image view.
    @objc fileprivate func loadImage() {
        Model.instance.loadImage(self, imageView: mediaImageView)
    }
}
