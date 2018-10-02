//
//  MediaWindowVideoVC.swift
//  MediaLibraryManagerGUI
//
//  Created by Max Huang on 2/10/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa
import AVKit
import AVFoundation

class MediaWindowVideoVC: NSViewController {

    @IBOutlet weak var playerView: AVPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        let url = URL(fileURLWithPath: (Model.instance.currentFile?.fullpath)!)
        
        let player = AVPlayer(url: url)
        playerView.player = player
        
//        Model.instance.showControls(sender: self)
    }
    
}
