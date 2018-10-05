//
//  Model.swift
//  MediaLibraryManagerGUI
//
//  Created by Fire Breathing Rubber Duckies on 29/09/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Foundation
import Cocoa
import AVKit
import Quartz

protocol OpenFileModelDegate {
    func updateOutets(currentFile: MMFile, notes: String, bookmarks: [String : String])
    func DecoupleMedia()
    func showMediaContent()
}
protocol MainViewModelDegate {
    func updateOutets(files: [MMFile])
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
    var currentFileIndex: [Int]?
    var currentCategoryIndex = 0
    var bookmarks = [String: String]()
    var notes = String()
    var mediaPlayer: AVPlayer?
    var playerView: AVPlayerView?
    var queue = [MMFile]()
    var jsonFilepath = String()
    var window: NSWindow?
    let AppDel = NSApplication.shared.delegate as! AppDelegate
    var importMenuItem: NSMenuItem?
    var importMenuItemAction: Selector?
    var importMenuItemTarget: AnyObject?
    var clearLibraryMenuItem: NSMenuItem?
    var clearLibraryItemAction: Selector?
    var clearLibraryItemTarget: AnyObject?
    var mainTopbar: MainTopViewController?

    var currentFileOpen: MMFile?{
        didSet{
            if oldValue != nil && openFileDelegate == nil{
                //open window closed
                print("removing bar")
                removeBottomBar()
                
            }
        }
    }
    var openFileDelegate: OpenFileModelDegate?{
        didSet{
            updateOpenFileVC()
        }
    }
    var mainViewDegate: MainViewModelDegate?{
        didSet{
            updateMainVC()
        }
    }
    
    var bottomBarVC: BottomBarViewController?{
        didSet{
            updateBottomBarVC()
        }
    }
    
    func setup(){
        bookmarks.removeAll()
        notes = ""
        if let currentFile = currentFile{
            //currentFile exists
            let bookmarkMetadataIndex = currentFile.searchMetadata(keyword: "bookmarks")
            if bookmarkMetadataIndex != -1 {
                let bookmarkString = currentFile.metadata[bookmarkMetadataIndex].value
                var bookmarksArray = bookmarkString.components(separatedBy: ",") //contains both key and values
                var i = 0
                for _ in 0..<bookmarksArray.count/2{
                    print(i)
                   bookmarks[bookmarksArray[i]] = bookmarksArray[i+1]
                    i += 2
                }
            }else{
                //before would just keep the same the bookmarks as before if doesnt contain the key
                bookmarks.removeAll()
            }
            let notesMetadataIndex = currentFile.searchMetadata(keyword: "notes")
            if notesMetadataIndex != -1 {
                notes = currentFile.metadata[notesMetadataIndex].value
            }else{
                notes = ""
            }
        }
        
    }
    
    func addFile() {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["json"]
        panel.beginSheetModal(for: self.window!, completionHandler: { (returnCode)-> Void in
            if returnCode == NSApplication.ModalResponse.OK{
                var stringArray: [String] = []
                
                for url in panel.urls{
                    let str = String(url.absoluteString)
                    let start = str.index(str.startIndex, offsetBy: str._bridgeToObjectiveC().range(of: ":").location+1)
                    let end = str.endIndex
                    let newStr = String(str[start..<end])
                    stringArray.append(newStr)
                }

                self.jsonFilepath = stringArray.joined(separator: " ")
                self.importJsonFile(from: self.jsonFilepath)
                self.changeCategory(catIndex: self.currentCategoryIndex)
                self.updateMainVC()
                
                self.importMenuItem = self.AppDel.importMenuItem
                self.toggleImportButtons(setEnabled: false)

            }
        })
    }
    
    func changeCategory(catIndex: Int){
        var cat = ""
        switch catIndex {
        case 0:
            cat = "image"
            break
        case 1:
            cat = "audio"
            break
        case 2:
            cat = "video"
            break
        case 3:
            cat = "document"
            break
        default:
            cat = "other"
        }
        currentCategoryIndex = catIndex
        listFiles(with: [cat], listAll: false)
        updateMainVC()
    }
    
    
    func searchStrings(searchTerms: [String]){
        listFiles(with: searchTerms, listAll: false)
        updateMainVC()
    }
    func switchVC(sourceController: NSViewController, segueName: String, fileIndex: Int) {
        if currentFileOpen == nil && segueName == "MainViewSegue"{
            //no file is open, remove media bottom bar
            removeBottomBar()
        }
        selectFile(fileIndex: fileIndex)
        sourceController.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: segueName), sender: self)
    }
    
    func selectFile(fileIndex: Int){
        do{
            //try doesnt do anything so need to check numbers manually
            if fileIndex > -1 {
                currentFile = try subLibrary.get(index: fileIndex)
                currentFileIndex = [fileIndex, currentCategoryIndex]
                updateOpenFileVC()
                updateBottomBarVC()
            }
        }catch{
            print("file out of range")
        }
    }
    
    
    func showPreview(sender: NSViewController, preview_VC: PreviewViewController?, fileIndex: Int)-> PreviewViewController{
        var previewVCResult = preview_VC
        if previewVCResult == nil{
            var previewVC = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "PreviewVC")) as! PreviewViewController
            previewVC.view.layer?.removeAllAnimations()
            sender.view.addSubview(previewVC.view)
            let x = sender.view.frame.width - 250
    //        previewVC.view.frame = CGRect(x: sender.view.frame.width, y: 0, width: 250, height: 646)
            previewVC.view.frame = CGRect(x: x, y: 0, width: 250, height: 646)
//            previewVC.view.wantsLayer = true
//            let animation = CABasicAnimation(keyPath: "position")
//            let startingPoint = CGRect(x: sender.view.frame.width, y: 0, width: 250, height: 646)
//            let endingPoint = CGRect(x: x, y: 0, width: 250, height: 646)
//            animation.fromValue = startingPoint
//            animation.toValue = endingPoint
//            animation.repeatCount = 1
//            animation.duration = 0.1
//            previewVC.view.layer?.add(animation, forKey: "linearMovement")
            previewVCResult = previewVC
        }
        
        previewVCResult?.setup(file: subLibrary.all()[fileIndex])
        
        return previewVCResult!
    }
   
    func removePreview(sender: NSViewController ,previewVC: PreviewViewController){
        previewVC.view.layer?.removeAllAnimations()
        let x = sender.view.frame.width - 250
        previewVC.view.frame = CGRect(x: x, y: 0, width: 250, height: 646)
//        CATransaction.begin()
//        let animation = CABasicAnimation(keyPath: "position")
//        let startingPoint = CGRect(x: sender.view.frame.width, y: 0, width: 250, height: 646)
//        let endingPoint = CGRect(x: x, y: 0, width: 250, height: 646)
//        animation.fromValue = endingPoint
//        animation.toValue = startingPoint
//        animation.repeatCount = 1
//        animation.duration = 0.1
        
//        CATransaction.setCompletionBlock {
//            previewVC.view.removeFromSuperview()
//        }
//        previewVC.view.layer?.add(animation, forKey: "linearMovement")
//        CATransaction.commit()
         previewVC.view.removeFromSuperview()
    }
    
    
    
    func showBottomBar(sender: NSViewController){
        if bottomBarVC == nil{
            //doesnt already exist
            let bottomBarVC = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "BottomBarVC")) as! BottomBarViewController
            bottomBarVC.view.layer?.removeAllAnimations()
            sender.view.addSubview(bottomBarVC.view)
            let x = sender.view.frame.width - 250
            //        previewVC.view.frame = CGRect(x: sender.view.frame.width, y: 0, width: 250, height: 646)
            bottomBarVC.view.frame = CGRect(x: 0, y: 0, width: 1280, height: 100)
            bottomBarVC.view.wantsLayer = true
            let animation = CABasicAnimation(keyPath: "position")
            let startingPoint = CGRect(x: 0, y: -100, width: 1280, height: 100)
            let endingPoint = CGRect(x: 0, y: 0, width: 1280, height: 100)
            animation.fromValue = startingPoint
            animation.toValue = endingPoint
            animation.repeatCount = 1
            animation.duration = 0.3
            bottomBarVC.view.layer?.add(animation, forKey: "linearMovement")
        }
        print("bottom: \(bottomBarVC)")
    }
    
    func removeBottomBar(){
        if bottomBarVC != nil{
            bottomBarVC!.view.layer?.removeAllAnimations()
            //bottomBarVC!.view.frame = CGRect(x: 0, y: -100, width: 1280, height: 100)
            CATransaction.begin()
            let animation = CABasicAnimation(keyPath: "position")
            let startingPoint = CGRect(x: 0, y: 0, width: 1280, height: 100)
            let endingPoint = CGRect(x: 0, y: -100, width: 1280, height: 100)
            animation.fromValue = startingPoint
            animation.toValue = endingPoint
            animation.repeatCount = 1
            animation.duration = 0.3

            CATransaction.setCompletionBlock {
                self.bottomBarVC!.view.removeFromSuperview()
                self.bottomBarVC = nil
            }
            bottomBarVC!.view.layer?.add(animation, forKey: "linearMovement")
            CATransaction.commit()
        }
        
    }
    
    
    func openFileInWindow(){
        //check the type of file and open it accordingly
        currentFileOpen = currentFile
        let time = Utility.convertCMTimeToSeconds((self.mediaPlayer?.currentTime())!)
        openFileDelegate?.DecoupleMedia()
        
        print("recouple time", time)
        Model.instance.mediaJumpToTime(jumpTo: time)
    }
    
    func returnFileToMainWindow(){
        currentFileOpen = nil
        let time = Utility.convertCMTimeToSeconds((self.mediaPlayer?.currentTime())!)
        openFileDelegate?.showMediaContent()
        
        print("recouple time", time)
        Model.instance.mediaJumpToTime(jumpTo: time)
    }
    
    func addBookmark(label: String){
        //get current time from the player
        var time = ""
        if mediaPlayer != nil{
            time = Utility.convertCMTimeToSeconds((self.mediaPlayer?.currentTime())!)
        }else{
            time = "00:00:00"
        }
        //add the metadata to the file
        bookmarks[label] = time
        print(time)
        saveData()
        updateOpenFileVC()
    }
    
    func deleteBookmark(keyToDelete: String){
        bookmarks.removeValue(forKey: keyToDelete)
        saveData()
        updateOpenFileVC()
    }
    
    func addNotes(notes: String){
        self.notes = notes
        saveData()
        updateOpenFileVC()
    }
    
    func addToQueue(){
        queue.append(currentFile!) //add the current file open
    }
    
    
    
    func saveData(){
        //save bookmarks
        var bookmarksResult = ""
        for keyVal in bookmarks{
            bookmarksResult.append("\(keyVal.key),")
            bookmarksResult.append("\(keyVal.value),")
        }
        setFile(with: "bookmarks", at: currentFileIndex![0], to: bookmarksResult)
        setFile(with: "notes", at: currentFileIndex![0], to: self.notes)
        //save notes
        
    }
    
    
    func savePersistent() {
        exportLibraryAsJson()
    }
    
    
    //------------------------------------------------------------------------80
    // MediaWindow functionality
    //------------------------------------------------------------------------80
    
    func loadImage(_ sender: NSViewController, imageView: NSImageView) {
        var image = NSImage(contentsOfFile: (Model.instance.currentFile?.fullpath)!)
        
        // transform image scale width and height to view
        imageView.frame = sender.view.frame
        // scaling imaghe
        image = image?.resizeMaintainingAspectRatio(withSize: NSSize(width: 800, height: 450))
        
        imageView.image = image
    }
    
    func loadDocument(_ sender: NSViewController, docView: PDFView) {
        let url = URL(fileURLWithPath: (self.currentFile?.fullpath)!)
        let doc = PDFDocument(url: url)
        docView.document = doc
    }
    
    func loadMediaPlayer(_ sender: NSViewController, playerView: AVPlayerView, queued: Bool = false) {
        var url: URL
        if !queued{
            url = URL(fileURLWithPath: (self.currentFile?.fullpath)!)
        }else{
            url = URL(fileURLWithPath: queue.removeFirst().fullpath)
            
        }
        self.mediaPlayer = AVPlayer(url: url)
        self.playerView = playerView
        self.playerView!.player = self.mediaPlayer
    }
    
    func mediaJumpToTime(jumpTo time: String) {
        let seconds = Utility.convertHumanStringToSeconds(time)
        
        let frameRate: Int32 = (self.playerView?.player!.currentItem?.currentTime().timescale)!
        
        self.playerView?.player!.seek(to: CMTimeMakeWithSeconds(seconds, frameRate), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
    }
    
    
    
    //------------------------------------------------------------------------80
    // Previous media library functionality
    //------------------------------------------------------------------------80
    
    func deleteAllFiles() {
        do {
            try DeleteCommand(library, [], subLibrary, all: true).execute()
            updateMainVC()
            clearLibraryMenuItem = AppDel.clearLibraryMenuItem
            clearLibraryItemAction = clearLibraryMenuItem?.action
            clearLibraryItemTarget = clearLibraryMenuItem?.target
            clearLibraryMenuItem?.target = nil
            clearLibraryMenuItem?.action = nil
            toggleImportButtons(setEnabled: true)
        } catch {
            print("Del all error:", error)
        }
    }
    
    private func importJsonFile(from filepath: String) {
        print("---- \(filepath)")
        do {
            try LoadCommand(library, [filepath]).execute()
        } catch {
            print("Load error:", error)
        }
        
    }
    
    func exportLibraryAsJson() {
        do {
            try SaveCommand(library, [self.jsonFilepath]).execute()
        } catch {
            print("Save library error:", error)
        }
    }
    
    private func listFiles(with terms: [String] = [], listAll: Bool = false) {
        do {
            let search = SearchCommand(library, terms, listAll)
            try search.execute()
            subLibrary = search.results! //need to test if this will ever be nil
            
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
    
    private func setFile(with key: String, at index: Int, to newValue: String) {
        let parts: [String] = [String(index), key, newValue]
        
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
    
    private func fileDetail(at index: Int) {
        do {
            try DetailCommand(library, [String(index)], subLibrary).execute()
        } catch {
            print("File detail error:", error)
        }
    }
    
    
    
    //------------------------------------------------------------------------80
    // Private functions
    //------------------------------------------------------------------------80
    
    private func toggleImportButtons(setEnabled: Bool) {
        if setEnabled {
            importMenuItem!.action = importMenuItemAction
            importMenuItem!.target = importMenuItemTarget
            
            self.mainTopbar?.addFileButton.isEnabled = true
        } else {
            importMenuItemAction = importMenuItem!.action
            importMenuItemTarget = importMenuItem!.target
            importMenuItem!.action = nil
            importMenuItem!.target = nil
            self.mainTopbar?.addFileButton.isEnabled = false
            clearLibraryMenuItem?.target = clearLibraryItemTarget
            clearLibraryMenuItem?.action = clearLibraryItemAction
        }
    }
    
    private func updateOpenFileVC(){
        openFileDelegate?.updateOutets(currentFile: currentFile!, notes: notes, bookmarks: bookmarks)
    }
    
    private func updateMainVC(){
        mainViewDegate?.updateOutets(files: subLibrary.all())
    }
    
    private func updateBottomBarVC(){
        bottomBarVC?.updateOutlets()
    }
}
