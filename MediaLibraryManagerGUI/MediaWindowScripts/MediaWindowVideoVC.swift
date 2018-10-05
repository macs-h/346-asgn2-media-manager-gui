//
//  MediaWindowVideoVC.swift
//  MediaLibraryManagerGUI
//
//  Created by Fire Breathing Rubber Duckies on 2/10/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa
import AVKit

/**
    View controller for displaying the video media files.
 */
class MediaWindowVideoVC: NSViewController, bottomBarDelegate {

    @IBOutlet weak var playerView: AVPlayerView!
    
    // Loads the selected video file.
    override func viewDidLoad() {
        super.viewDidLoad()
        loadVideo()
        
        // Provides functionality for the following functions.
        Model.instance.bottomBarVC?.delegte = self
    }

    
    // Plays the video.
    func play() {
        playPauseVideo()
    }

    
    // Pauses the video.
    func pause() {
        playPauseVideo()
    }
    
    
    // Advances to the next video, if one exists.
    func next() {
        loadVideo()
    }

    
    // Backs up to the previous video, if one exists.
    func previous() {
        loadVideo()
    }

    
    // Loads the video into the AV Player view.
    @objc private func loadVideo() {
        Model.instance.loadMediaPlayer(self, playerView: playerView)
    }
    
    
    // Toggles the playing state of the video.
    @objc private func playPauseVideo() {
        let player = playerView.player!
        if player.timeControlStatus == AVPlayerTimeControlStatus.paused {
            player.play()
        } else {
            player.pause()
        }
    }
    
}
