//
//  MediaWindowWC.swift
//  MediaLibraryManagerGUI
//
//  Created by Fire Breathing Rubber Duckies on 29/09/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa

/**
    Decides which view controller should be shown when a file is opened.
 */
class MediaWindowWC: NSWindowController, NSWindowDelegate {

    /**
        Chooses which view controller should be shown in the main window
        depending on the type of media being opened.
     */
    override func windowDidLoad() {
        super.windowDidLoad()
        let mediaType = Model.instance.currentFile?.fileType
        var vc = ""
        switch mediaType {
        case "image":
            vc = "MediaWindowImageVC"
        case "video":
            vc = "MediaWindowVideoVC"
        case "audio":
            vc = "MediaWindowAudioVC"
        case "document":
            vc = "MediaWindowDocumentVC"
        default:
            print("unknown type \(String(describing: mediaType))")
        }
        
        let newVC = NSStoryboard(name: NSStoryboard.Name(rawValue: "MediaWindow"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: vc)) as! NSViewController
        self.contentViewController = newVC
    }
    
    func windowWillClose(_ notification: Notification) {
        Model.instance.returnFileToMainWindow()
    }

}
