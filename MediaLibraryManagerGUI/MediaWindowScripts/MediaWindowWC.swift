//
//  MediaWindowWC.swift
//  MediaLibraryManagerGUI
//
//  Created by Max Huang on 29/09/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa

class MediaWindowWC: NSWindowController, NSWindowDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()
        let mediaType = Model.instance.currentFile?.fileType
        var vc = ""
        switch mediaType {
        case "image":
            vc = "MediaWindowImageVC"
            break
        case "video":
            vc = "MediaWindowVideoVC"
            break
        case "audio":
            vc = "MediaWindowAudioVC"
            break
        case "document":
            vc = "MediaWindowDocumentVC"
            break
        default:
            print("unknown type \(mediaType)")
        }
        
        let newVC = NSStoryboard(name: NSStoryboard.Name(rawValue: "MediaWindow"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: vc)) as! NSViewController
        self.contentViewController = newVC
        
    }
    
    func windowWillClose(_ notification: Notification) {
        //tell the model that the window is no longer open
        Model.instance.currentFileOpen = nil
        
    }
    
//    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
//        print("child controllers:",contentViewController!.view.subviews)
//        let docVC = contentViewController!.view.subviews[0] as! MediaWindowDocumentVC
//        
//        docVC.docView.frame.size = frameSize
//        return frameSize
//    }

}
