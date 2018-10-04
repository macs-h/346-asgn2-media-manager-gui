//
//  MediaWindowAudioVC.swift
//  MediaLibraryManagerGUI
//
//  Created by Max Huang on 2/10/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa
import AVKit

class MediaWindowAudioVC: NSViewController, bottomBarDelegate {
    
    @IBOutlet weak var playerView: AVPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        loadAudio()
        
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
    
    @objc fileprivate func loadAudio() {
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
