//
//  MediaChangeVC.swift
//  MediaLibraryManagerGUI
//
//  Created by Max Huang on 2/10/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa

class MediaChangeVC: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
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
        
        var newVC = NSStoryboard(name: NSStoryboard.Name(rawValue: "MediaWindow"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: vc)) as! NSViewController
        self.view.addSubview(newVC.view)
        newVC.view.frame = CGRect(x: 0, y: 0, width: 800, height: 450)
//        if mediaType == "image" {
//            performSegue(withIdentifier: "SegueToImage", sender: self)
//        } else if mediaType == "document" {
//            performSegue(withIdentifier: "SegueToDocument", sender: self)
//        } else if mediaType == "audio" {
//            performSegue(withIdentifier: "SegueToAudio", sender: self)
//        } else if mediaType == "video" {
//            performSegue(withIdentifier: "SegueToVideo", sender: self)
//        } else {
//            NSLog("Media type \"\(String(describing: mediaType))\" does not exist")
//        }
        
    }
    
}
