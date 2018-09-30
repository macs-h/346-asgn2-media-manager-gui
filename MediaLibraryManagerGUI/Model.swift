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
    var libary = MM_Collection()//holds all the files
    var subLibary = MM_Collection() //holds the files that are show on screen (using categories)
    var currentFile: MMFile?{
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
    
    func switchVC(sourceController: NSViewController, segueName: String, fileIndex: Int){
        if fileIndex > -1{
            //currentFile = //subLibary.collection[fileIndex]
            
            //----temp
            let tempFile = MM_File()
            tempFile.filename = String(fileIndex)
            currentFile = tempFile
            //temp---
        }
        sourceController.performSegue(withIdentifier: segueName, sender: self)
    }
    
    func openFile(file: MMFile){
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
    
    private func updateOpenFileVC(){
        openFileDelegate?.updateOutets(currentFile: currentFile!, notes: notes, bookmarks: bookmarks)
    }
    
    private func updateMainVC(){
        mainViewDegate?.updateOutets(CurrentFile: currentFile! , files: subLibary.collection, fileType: currentFile!.fileType)
    }
}
