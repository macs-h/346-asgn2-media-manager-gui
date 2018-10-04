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
        
        loadVideo()
        
//        Model.instance.mediaJumpToTime(self, playerView: playerView, time: Utility.instance.convertSecondsToCMTime(8, 1))
        
        //makes the below functions work
        Model.instance.bottomBarVC?.delegte = self
    }
    
    func play() {
        playPauseVideo()
        print("Play called")
    }
    
    func pause() {
        playPauseVideo()
        print("Pause called")
    }
    
    func next() {
        loadVideo()
        print("Next called")
    }
    
    func previous() {
        loadVideo()
        print("Previous called")
    }
    
    @objc fileprivate func loadVideo() {
        Model.instance.loadMediaPlayer(self, playerView: playerView)
    }
    
    @objc fileprivate func playPauseVideo() {
        let player = playerView.player!
        if (player.timeControlStatus == AVPlayerTimeControlStatus.paused) {
            player.play()
        } else {
            player.pause()
        }
    }
    
}
