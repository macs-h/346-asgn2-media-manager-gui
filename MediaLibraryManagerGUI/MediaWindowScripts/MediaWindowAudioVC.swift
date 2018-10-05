//
//  MediaWindowAudioVC.swift
//  MediaLibraryManagerGUI
//
//  Created by Fire Breathing Rubber Duckies on 2/10/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa
import AVKit

/**
    View controller for displaying the audio media files.
 */
class MediaWindowAudioVC: NSViewController, bottomBarDelegate {
    
    @IBOutlet weak var playerView: AVPlayerView!
    
    // Loads the selected audio file.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAudio()
        
        // Provides functionality for the following functions.
        if !Model.instance.bottomBarVC!.windowIsOpen{
            Model.instance.bottomBarVC?.delegte = self
        }
            
    }
    
    
    
    // Plays the audio.
    func play() {
        playerView.player?.play()
    }

    
    // Pauses the audio.
    func pause() {
        playerView.player?.pause()
    }
    
    
    // Advances to the next audio, if one exists.
    func next() {
        loadAudio()
    }
    
    
    // Backs up to the previous audio, if one exists.
    func previous() {
        loadAudio()
    }
    
    
    // Loads the audio into the AV Player view.
    @objc private func loadAudio() {
        
        Model.instance.loadMediaPlayer(self, playerView: playerView)
        
    }
    
    
    // Toggles the playing state of the audio.
    @objc private func playPauseAudio() {
        let player = playerView.player!
        if player.timeControlStatus == AVPlayerTimeControlStatus.paused {
            player.play()
        } else {
            player.pause()
        }
    }

}
