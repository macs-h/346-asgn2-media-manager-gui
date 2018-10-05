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

//protocol for openFileViewController
protocol OpenFileModelDegate {
    func updateOutets(currentFile: MMFile, notes: String, bookmarks: [String : String])
    func DecoupleMedia()
    func showMediaContent()
}
//protocol for MainViewController
protocol MainViewModelDegate {
    func updateOutets(files: [MMFile])
}



//Singletion class Model which interacts between View controller and backend
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
    var mainParentVC: NSViewController?
    var currentFileOpen: MMFile?{
        didSet{
            if oldValue != nil && openFileDelegate == nil{
                //open window closed
                print("removing bar")
                //removeBottomBar()
                bottomBarVC?.disableEverything()
                
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
    
    //Called by MainViewController  to set up Model
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
    
    
    //Called to import json files
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
    
    
    //Called to change category
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
    
    // Search the library for terms
    func searchStrings(searchTerms: [String]){
        listFiles(with: searchTerms, listAll: false)
        currentCategoryIndex = -1
        updateMainVC()
    }
    
    //Calls performSegue to change to different viewControllers in same window
    func switchVC(sourceController: NSViewController, segueName: String, fileIndex: Int) {
        if currentFileOpen == nil && segueName == "MainViewSegue"{
            //no file is open, remove media bottom bar
            bottomBarVC?.disableEverything()
            //removeBottomBar()
        }
        if segueName == "MainViewSegue"{
            mainTopbar?.openVC = mainViewDegate as! NSViewController
            if bottomBarVC!.mediaIsPlaying{
                bottomBarVC?.stopMedia()
            }
        }else if segueName == "FileOpenSegue"{
            bottomBarVC?.updateOutlets()
        }
        selectFile(fileIndex: fileIndex)
        sourceController.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: segueName), sender: self)
    }
    
    //Updates the current file and tells delegates to update
    func selectFile(fileIndex: Int){
        do{
            //try doesnt do anything so need to check numbers manually
            if fileIndex > -1 {
                currentFile = try subLibrary.get(index: fileIndex)
                currentFileIndex = [fileIndex, currentCategoryIndex]
                updateOpenFileVC()
                updateBottomBarVC()
                mainTopbar?.updateTopBar()
            }
        }catch{
            print("file out of range")
        }
    }
    
    //Shows the preview viewController when a file is selected
    func showPreview(sender: NSViewController, preview_VC: PreviewViewController?, fileIndex: Int)-> PreviewViewController {
        var previewVCResult = preview_VC
        if previewVCResult == nil {
            let previewVC = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "PreviewVC")) as! PreviewViewController
            previewVC.view.layer?.removeAllAnimations()
            sender.view.addSubview(previewVC.view)
            let x = sender.view.frame.width - 250
            previewVC.view.frame = CGRect(x: x, y: 0, width: 250, height: 570)
            previewVCResult = previewVC
        }
        previewVCResult?.setup(file: subLibrary.all()[fileIndex])
        
        return previewVCResult!
    }
   
    
    //Remove preview ViewController from view
    func removePreview(sender: NSViewController ,previewVC: PreviewViewController) {
         previewVC.view.removeFromSuperview()
    }
    
    
    //Shows the bottom bar viewController
    func showBottomBar(sender: NSViewController) {
        if bottomBarVC == nil {
            //doesnt already exist
            let bottomBarVC = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "BottomBarVC")) as! BottomBarViewController
            bottomBarVC.view.layer?.removeAllAnimations()

            sender.addChildViewController(bottomBarVC)
            sender.view.addSubview(bottomBarVC.view)
            bottomBarVC.view.frame = CGRect(x: 0, y:  0, width: 1280, height: 100)
            self.bottomBarVC = bottomBarVC
            mainParentVC = sender.parent
        }
    }
    
    //Opens file in new window
    func openFileInWindow() {
        //check the type of file and open it accordingly
        currentFileOpen = currentFile
        var time = ""
        if currentFile?.fileType == "video" || currentFile?.fileType == "audio"{
            time = Utility.convertCMTimeToSeconds((self.mediaPlayer?.currentTime())!)
        }
        openFileDelegate?.DecoupleMedia()
        if time != ""{
            Model.instance.mediaJumpToTime(jumpTo: time)
        }
        
        
    }
    
    //Returns the decoupled window to main panel
    func returnFileToMainWindow() {
        currentFileOpen = nil
        var time = ""
        if currentFile?.fileType == "video" || currentFile?.fileType == "audio"{
            time = Utility.convertCMTimeToSeconds((self.mediaPlayer?.currentTime())!)
        }
        openFileDelegate?.showMediaContent()
        
        if time != ""{
            Model.instance.mediaJumpToTime(jumpTo: time)
            if bottomBarVC!.mediaIsPlaying{
                bottomBarVC?.delegte?.play()
            }
        }
        
        
    }
    
    //Add a bookmark at a given time to metadata
    func addBookmark(label: String) {
        //get current time from the player
        var time = ""
        if mediaPlayer != nil {
            time = Utility.convertCMTimeToSeconds((self.mediaPlayer?.currentTime())!)
        } else {
            time = "00:00:00"
        }
        //add the metadata to the file
        bookmarks[label] = time
        print(time)
        saveData()
        updateOpenFileVC()
    }
    
    //Delete a bookmark from the metadata
    func deleteBookmark(keyToDelete: String) {
        bookmarks.removeValue(forKey: keyToDelete)
        saveData()
        updateOpenFileVC()
    }
    
    //Add notes to metadata
    func addNotes(notes: String) {
        self.notes = notes
        saveData()
        updateOpenFileVC()
    }
    
    //Saves the data that was changed
    func saveData() {
        //save bookmarks
        var bookmarksResult = ""
        for keyVal in bookmarks {
            bookmarksResult.append("\(keyVal.key),")
            bookmarksResult.append("\(keyVal.value),")
        }
        setFile(with: "bookmarks", at: currentFileIndex![0], to: bookmarksResult)
        setFile(with: "notes", at: currentFileIndex![0], to: self.notes)
        //save notes
        
    }
    
    //Saves the files in persistent storage
    func savePersistent() {
        exportLibraryAsJson()
    }
    
    
    //------------------------------------------------------------------------80
    // MediaWindow functionality
    //------------------------------------------------------------------------80
    
    // Loads the iamge into the image view.
    func loadImage(_ sender: NSViewController, imageView: NSImageView) {
        var image = NSImage(contentsOfFile: (Model.instance.currentFile?.fullpath)!)
        
        // transform image scale width and height to view
        imageView.frame = sender.view.frame
        // scaling imaghe
        image = image?.resizeMaintainingAspectRatio(withSize: NSSize(width: 800, height: 450))
        
        imageView.image = image
    }
    
    
    // Loads the document into the document view.
    func loadDocument(_ sender: NSViewController, docView: PDFView) {
        let url = URL(fileURLWithPath: (self.currentFile?.fullpath)!)
        let doc = PDFDocument(url: url)
        docView.document = doc
    }
    
    
    // Loads the audio or video file into the player view.
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
    
    
    // Jumps to a specific time in the audio or media files.
    func mediaJumpToTime(jumpTo time: String) {
        let seconds = Utility.convertHumanStringToSeconds(time)
        
        let frameRate: Int32 = (self.playerView?.player!.currentItem?.currentTime().timescale)!
        
        self.playerView?.player!.seek(to: CMTimeMakeWithSeconds(seconds, frameRate), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
    }
    
    
    
    //------------------------------------------------------------------------80
    // Previous media library functionality
    //------------------------------------------------------------------------80
    
    // Delete all files in the library.
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
    
    
    // Import files from a JSON.
    private func importJsonFile(from filepath: String) {
        print("---- \(filepath)")
        do {
            try LoadCommand(library, [filepath]).execute()
        } catch {
            print("Load error:", error)
        }
    }
    
    
    // Export files to a JSON.
    func exportLibraryAsJson() {
        do {
            try SaveCommand(library, [self.jsonFilepath]).execute()
        } catch {
            print("Save library error:", error)
        }
    }
    
    
    // List the files that match the term.
    private func listFiles(with terms: [String] = [], listAll: Bool = false) {
        do {
            let search = SearchCommand(library, terms, listAll)
            try search.execute()
            subLibrary = search.results! //need to test if this will ever be nil
            
        } catch {
            print("List error:", error)
        }
    }
    
    
    // Add terms to a file in the library.
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
    
    
    // Set a key to a different value for a file.
    private func setFile(with key: String, at index: Int, to newValue: String) {
        let parts: [String] = [String(index), key, newValue]
        
        do {
            try SetCommand(library, parts, subLibrary).execute()
        } catch {
            print("Set error:", error)
        }
    }
    

    // Get the details of a file.
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
    
    // Toggles the state of the import button and import menu item depending on
    // whether the user has imported a JSON already.
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
    
    //Updates OpenFiledelegate of changes
    private func updateOpenFileVC(){
        openFileDelegate?.updateOutets(currentFile: currentFile!, notes: notes, bookmarks: bookmarks)
    }
    
    //Updates Maindelegate of changes
    private func updateMainVC(){
        mainViewDegate?.updateOutets(files: subLibrary.all())
    }
    
    //Updates BottomBar of changes
    private func updateBottomBarVC(){
        bottomBarVC?.updateOutlets()
    }
}
