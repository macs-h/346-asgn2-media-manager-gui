//
//  MediaWindowDocumentVC.swift
//  MediaLibraryManagerGUI
//
//  Created by Fire Breathing Rubber Duckies on 2/10/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa
import Quartz

/**
    View controller for displaing the document media files.
 */
class MediaWindowDocumentVC: NSViewController, bottomBarDelegate {

    @IBOutlet weak var docView: PDFView!
    
    // Loads the selected document file.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDoc()
        
        // Provides functionality for the following functions.
        Model.instance.bottomBarVC?.delegte = self
    }
    
    
    // These two functions are only used for audio/video functions.
    func play() {}
    func pause() {}
    
    
    // Advances to the next document, if one exists.
    func next() {
        loadDoc()
    }

    
    // Backs up to the previous document, if one exists.
    func previous() {
        loadDoc()
    }

    
    // Loads the document into the PDF view.
    @objc fileprivate func loadDoc() {
        Model.instance.loadDocument(self, docView: docView)
    }
    
}
