//
//  MediaWindowVideoVC.swift
//  MediaLibraryManagerGUI
//
//  Created by Max Huang on 2/10/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa
import AVKit

class MediaWindowVideoVC: NSViewController, bottomBarDelegate {

    @IBOutlet weak var playerView: AVPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        NSLog("MediaWindowVideoVC loaded")
        
        Model.instance.loadVideoPlayer(self, playerView: playerView)
        
        
        Model.instance.mediaJumpToTime(self, playerView: playerView, time: Utility.convertSecondsToCMTime(8, 1))
        
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
