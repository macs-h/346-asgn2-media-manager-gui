////
////  MediaChangeVC.swift
////  MediaLibraryManagerGUI
////
////  Created by Fire Breathing Rubber Duckies on 2/10/18.
////  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
////
//
//import Cocoa
//
//class MediaChangeVC: NSViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do view setup here.
//        
//        let mediaType = Model.instance.currentFile?.fileType
//        var vc = ""
//        switch mediaType {
//        case "image":
//            vc = "MediaWindowImageVC"
//            break
//        case "video":
//            vc = "MediaWindowVideoVC"
//            break
//        case "audio":
//            vc = "MediaWindowAudioVC"
//            break
//        case "document":
//            vc = "MediaWindowDocumentVC"
//            break
//        default:
//            print("unknown type \(String(describing: mediaType))")
//        }
//        
//        let newVC = NSStoryboard(name: NSStoryboard.Name(rawValue: "MediaWindow"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: vc)) as! NSViewController
//        newVC.view.frame = CGRect(x: 0, y: 0, width: 800, height: 450)
//    }
//    
//}
