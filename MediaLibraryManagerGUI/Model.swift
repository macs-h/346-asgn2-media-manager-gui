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
    var subLibrary = MMResultSet() //holds the files that are show on screen (using categories)
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
    
    private func listFiles(with terms: [String] = [], listAll: Bool = false) {
        do {
            try SearchCommand(library, terms, listAll).execute()
        } catch {
            print("List error:", error)
        }
    }
    
    private func addFile(with terms: [String], at index: Int) {
        let parts: [String] = {
            var tmp = terms
            tmp.insert(String(index), at: index)
            return tmp
        }()
        
        do {
            try AddCommand(library, parts, subLibrary).execute()
        } catch {
            print("Add error:", error)
        }
    }
    
    private func setFile(with term: String, at index: Int, to newTerm: String) {
        let parts: [String] = [String(index), term, newTerm]
        
        do {
            try SetCommand(library, parts, subLibrary).execute()
        } catch {
            print("Set error:", error)
        }
    }
    
    private func deleteFile(with metadata: [String], at index: Int) {
        let parts: [String] = {
            var tmp = metadata
            tmp.insert(String(index), at: index)
            return tmp
        }()
        
        do {
            try DeleteCommand(library, parts, subLibrary).execute()
        } catch {
            print("Del error:", error)
        }
    }
    
    private func saveLibrary() {
        do {
            try SaveCommand(library, []).execute()
        } catch {
            print("Save library error:", error)
        }
    }
    
    private func fileDetail(at index: Int) {
        do {
            try DetailCommand(library, [String(index)], subLibrary).execute()
        } catch {
            print("File detail error:", error)
        }
    }
    
    
    
    //----------------------------------------------------------------------------------90
    // Private functions
    //----------------------------------------------------------------------------------90
    
    private func updateOpenFileVC(){
        openFileDelegate?.updateOutets(currentFile: currentFile!, notes: notes, bookmarks: bookmarks)
    }
    
    private func updateMainVC(){
        mainViewDegate?.updateOutets(CurrentFile: currentFile! , files: subLibrary.all(), fileType: currentFile!.fileType)
    }
}
