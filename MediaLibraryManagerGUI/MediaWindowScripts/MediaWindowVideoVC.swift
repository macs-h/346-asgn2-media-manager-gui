//
//  MediaWindowVideoVC.swift
//  MediaLibraryManagerGUI
//
//  Created by Max Huang on 2/10/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa

class MediaWindowVideoVC: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        Model.instance.showControls(sender: self)
    }
    
}
