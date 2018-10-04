//
//  Model.swift
//  MediaLibraryManagerGUI
//
//  Created by Sam Paterson on 29/09/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Foundation
import Cocoa
import AVKit
import Quartz

protocol OpenFileModelDegate {
    func updateOutets(currentFile: MMFile, notes: String, bookmarks: [String : String])
    func openMedia(file: MMFile)
}
protocol MainViewModelDegate {
    func updateOutets(files: [MMFile])
}

//protocol BottomBarDelegate{
//    func updateOutlets()
//}


class Model{
    static var instance = Model()
    var library = MM_Collection()//holds all the files
    var subLibrary = MMResultSet() //holds the files that are show on screen (using categories)
    var currentFile: MMFile? {
        didSet{
            setup()
        }
    }
    var currentFileIndex:[Int]?
    var currentCategoryIndex = 0
    var bookmarks: [String: String]  = [:]
    var notes: String = ""
    var mediaPlayer: AVPlayer?
    var playerView: AVPlayerView?
    var queue: [MMFile] = []
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
            }
            let notesMetadataIndex = currentFile.searchMetadata(keyword: "notes")
            if notesMetadataIndex != -1 {
                notes = currentFile.metadata[notesMetadataIndex].value
            }
        }
        
    }
    
    func addFile(sender: NSViewController){
        //get file path
//        let sam = true
//        if sam{
//            importJsonFile(from: "///Users/sampaterson/Documents/Uni/Cosc346/asgn2/MediaLibraryManager/test.json")
////            importJsonFile(from: "~/Documents/Uni/Cosc346/asgn2/MediaLibraryManager/test.json")
//        }else {
//            importJsonFile(from: "~/346/asgn2/MediaLibraryManager/test.json")
//        }
        
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["json"]
        panel.beginSheetModal(for: sender.view.window!, completionHandler: { (returnCode)-> Void in
            if returnCode == NSApplication.ModalResponse.OK{
                var stringArray: [String] = []
                for url in panel.urls{
//                    stringArray.append(String(url.absoluteString)[4...])
                    let str = String(url.absoluteString)
                    let start = str.index(str.startIndex, offsetBy: str._bridgeToObjectiveC().range(of: ":").location+1)
                    let end = str.endIndex
                    let newStr = String(str[start..<end])
                    stringArray.append(newStr)
                }
                
                
//                let start = path_reversed.startIndex
//                let end = path_reversed.index(path_reversed.startIndex, offsetBy: path_reversed._bridgeToObjectiveC().range(of: "/").location)
//
//                f.filename = String( String( path_reversed[start..<end].reversed()) )
                
                
                self.importJsonFile(from: stringArray.joined(separator: " "))
//                self.importJsonFile(from: (panel.url?.absoluteString)!)
                self.changeCategory(catIndex: self.currentCategoryIndex)
                self.updateMainVC()
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
    
    
    func openFile(){
        //check the type of file and open it accordingly
        currentFileOpen = currentFile
        openFileDelegate?.openMedia(file: currentFile!)
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
        
        //save notes
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
//        docView.document = PDFDocument(url: URL(fileURLWithPath: (self.currentFile?.fullpath)!))
        let url = URL(fileURLWithPath: (self.currentFile?.fullpath)!)
        print(url)
        let doc = PDFDocument(url: url)
        print(doc)
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
    
    private func importJsonFile(from filepath: String) {
        print("---- \(filepath)")
        do {
            try LoadCommand(library, [filepath]).execute()
        } catch {
            print("Load error:", error)
        }
        
    }
    
    func exportLibraryAsJson(to filepath: String) {
        do {
            try SaveCommand(library, [filepath]).execute()
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
