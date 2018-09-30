//
//  Model.swift
//  MediaLibraryManagerGUI
//
//  Created by Sam Paterson on 29/09/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Foundation
import Cocoa


protocol openFileModelDegate {
    func updateOutets(currentFile: MMFile, notes: String, bookmarks: [String])
    func openMedia(file: MMFile)
}
protocol mainViewModelDegate {
    func updateOutets(CurrentFile: MMFile, files: [MMFile], fileType: String)
}


class Model{
    static var instance = Model()
    var library = MM_Collection()//holds all the files
    var subLibrary = MM_Collection() //holds the files that are show on screen (using categories)
    var currentFile: MMFile? {
        didSet{
            setup()
        }
    }
    var bookmarks: [String]  = []
    var notes: String = ""
    var openFileDelegate: openFileModelDegate?{
        didSet{
            updateOpenFileVC()
        }
    }
    var mainViewDegate: mainViewModelDegate?{
        didSet{
            updateMainVC()
        }
    }
    
    func setup(){
        if let currentFile = currentFile{
            //currentFile exists
            let bookmarkMetadataIndex = currentFile.searchMetadata(keyword: "Bookmarks")
            if bookmarkMetadataIndex != -1 {
                let bookmarkString = currentFile.metadata[bookmarkMetadataIndex].value
                bookmarks = bookmarkString.components(separatedBy: " ")
            }
            let notesMetadataIndex = currentFile.searchMetadata(keyword: "Bookmarks")
            if notesMetadataIndex != -1 {
                notes = currentFile.metadata[notesMetadataIndex].value
            }
        }
        
    }
    
    func switchVC(sourceController: NSViewController, segueName: String, fileIndex: Int) {
        if fileIndex > -1 {
            
            let tempFile = MM_File()
            tempFile.filename = String(fileIndex)
            currentFile = tempFile
        }
        
        sourceController.performSegue(withIdentifier: segueName, sender: self)
    }
    
    func showPreview(sender: NSViewController, preview_VC: PreviewViewController?, fileIndex: Int)-> PreviewViewController{
        var previewVCResult = preview_VC
        if previewVCResult == nil{
            var previewVC = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "PreviewVC") as! PreviewViewController
            previewVC.view.layer?.removeAllAnimations()
            sender.view.addSubview(previewVC.view)
            let x = sender.view.frame.width - 250
    //        previewVC.view.frame = CGRect(x: sender.view.frame.width, y: 0, width: 250, height: 646)
            previewVC.view.frame = CGRect(x: x, y: 0, width: 250, height: 646)
            previewVC.view.wantsLayer = true
            let animation = CABasicAnimation(keyPath: "position")
            let startingPoint = CGRect(x: sender.view.frame.width, y: 0, width: 250, height: 646)
            let endingPoint = CGRect(x: x, y: 0, width: 250, height: 646)
            animation.fromValue = startingPoint
            animation.toValue = endingPoint
            animation.repeatCount = 1
            animation.duration = 0.1
            previewVC.view.layer?.add(animation, forKey: "linearMovement")
            previewVCResult = previewVC
        }
        //----temp
        let tempFile = MM_File()
        tempFile.filename = String(fileIndex)
        currentFile = tempFile
        //temp---
        previewVCResult?.setup(file: tempFile)
        
        return previewVCResult!
    }
    
    func removePreview(sender: NSViewController ,previewVC: PreviewViewController){
        previewVC.view.layer?.removeAllAnimations()
        let x = sender.view.frame.width - 250
        previewVC.view.frame = CGRect(x: x, y: 0, width: 250, height: 646)
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "position")
        let startingPoint = CGRect(x: sender.view.frame.width, y: 0, width: 250, height: 646)
        let endingPoint = CGRect(x: x, y: 0, width: 250, height: 646)
        animation.fromValue = endingPoint
        animation.toValue = startingPoint
        animation.repeatCount = 1
        animation.duration = 0.1
        
        CATransaction.setCompletionBlock {
            previewVC.view.removeFromSuperview()
        }
        previewVC.view.layer?.add(animation, forKey: "linearMovement")
        CATransaction.commit()
    }

    func openFile(){
        //check the type of file and open it accordingly
//        openFileDelegate?.openMedia(file: currentFile)
    }
    
    func addBookmark(){
        //get current time from the player
        let time = "1.1" //temp
        //add the metadata to the file
        bookmarks.append(time)
        saveData()
        updateOpenFileVC()
    }
    
    func addNotes(notes: String){
        self.notes = notes
        saveData()
        updateOpenFileVC()
    }
    
    func saveData(){
        //save bookmarks
        //save notes
    }
    
    
    //----------------------------------------------------------------------------------90
    // Previous media library functionality
    //----------------------------------------------------------------------------------90
    
    func importJsonFile(from filepath: String) {
        do {
            try LoadCommand(library, [filepath]).execute()
        } catch {
            print("Load error:", error)
        }
    }
    
    
    
    //----------------------------------------------------------------------------------90
    // Private functions
    //----------------------------------------------------------------------------------90
    
    private func updateOpenFileVC(){
        openFileDelegate?.updateOutets(currentFile: currentFile!, notes: notes, bookmarks: bookmarks)
    }
    
    private func updateMainVC(){
        mainViewDegate?.updateOutets(CurrentFile: currentFile! , files: subLibrary.collection, fileType: currentFile!.fileType)
    }
}
