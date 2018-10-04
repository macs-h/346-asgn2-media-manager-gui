//
//  MediaWindowDocumentVC.swift
//  MediaLibraryManagerGUI
//
//  Created by Max Huang on 2/10/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa
import Quartz

class MediaWindowDocumentVC: NSViewController, bottomBarDelegate {

    @IBOutlet weak var docView: PDFView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        print("LOADED")
        
        loadDoc()
        
        //makes the below functions work
        Model.instance.bottomBarVC?.delegte = self
    }
    
    func play() {
        //!!!!DONT IMPLEMENT
    }
    
    func pause() {
        //!!!!DONT IMPLEMENT
    }
    
    func next() {
        loadDoc()
        print("Next called")
    }
    
    func previous() {
        loadDoc()
        print("Previous called")
    }
    
    @objc fileprivate func loadDoc() {
        Model.instance.loadDocument(self, docView: docView)
    }
    
}
