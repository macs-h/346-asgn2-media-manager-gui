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
        
        
        Model.instance.mediaJumpToTime(self, playerView: playerView, time: Utility.instance.convertSecondsToCMTime(8, 1))
    }
    
}
