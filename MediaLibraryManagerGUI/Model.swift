//
//  Model.swift
//  MediaLibraryManagerGUI
//
//  Created by Sam Paterson on 29/09/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Foundation


protocol openFileModelDegate {
    func updateOutets(currentFile: MMFile, notes: String, bookmarks: [float_t])
    func openMedia(file: MMFile)
}
protocol mainViewModelDegate {
    func updateOutets(CurrentFile: MMFile, files: [MMFile], fileType: String)
}


class Model{
    static var instance = Model()
    var libary = MM_Collection()//holds all the files
    var subLibary = MM_Collection() //holds the files that are show on screen (using categories)
    var currentFile = MM_File()
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
    
    func openFile(file: MMFile){
        //check the type of file and open it accordingly
        openFileDelegate?.openMedia(file: currentFile)
    }
    
    func addBookmark(){
        //get current time from the player
        var time = 1.1 //temp
        //add the metadata to the file
        updateOpenFileVC()
    }
    
    private func updateOpenFileVC(){
        openFileDelegate?.updateOutets(currentFile: currentFile, notes: "this is the notes", bookmarks: [0.0, 0.1, 0.2])
    }
    
    private func updateMainVC(){
        mainViewDegate?.updateOutets(CurrentFile: currentFile , files: subLibary.collection, fileType: currentFile.fileType)
    }
}
