//
//  MediaWindowVideoVC.swift
//  MediaLibraryManagerGUI
//
//  Created by Max Huang on 2/10/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa
import AVKit

class MediaWindowVideoVC: NSViewController {

    @IBOutlet weak var playerView: AVPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        NSLog("MediaWindowVideoVC loaded")
        
        Model.instance.loadVideoPlayer(self, playerView: playerView)
        
//        let url = URL(fileURLWithPath: (Model.instance.currentFile?.fullpath)!)
//
//        let player = AVPlayer(url: url)
//        playerView.player = player
//
//        print("---", player.currentTime())
        
//        Model.instance.showControls(sender: self)
    }
    
}
