//
//  BottomBarViewController.swift
//  MediaLibraryManagerGUI
//
//  Created by Fire Breathing Rubber Duckies on 2/10/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

// DOUBLE CHECK

import Cocoa

// Delegate function so buttons will affect meida when decoupled
protocol bottomBarDelegate {
    func play()
    func pause()
    func next()
    func previous()
}


/**
    BottomBarViewControllers controls the functions of the bottom bar
 */
class BottomBarViewController: NSViewController {

    @IBOutlet weak var previousButton: NSButton!
    @IBOutlet weak var play_pauseButton: NSButton!
    @IBOutlet weak var nextButton: NSButton!
    @IBOutlet weak var bookmarkButton: NSButton!
    var delegte: bottomBarDelegate?
    var mediaIsPlaying = false
    var windowIsOpen = false
    
    @IBOutlet weak var decoupleButton: NSButton!
    
    //popover variables
    @IBOutlet var PopOverView: NSView!
    @IBOutlet weak var bookmarkPopoverTimeLabel: NSTextField!
    @IBOutlet weak var bookmarkPopoverTextField: NSTextField!
    @IBOutlet weak var FileNameLabel: NSTextField!
    //Tells the model that this is the bottome bar and called at first load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
       Model.instance.bottomBarVC = self
    }
    
    override func viewWillDisappear() {
        play_pauseAction(self)
    }
    
    
    // Previous button pressed and will go to the previous file in sublibrary
    @IBAction func PreviousAction(_ sender: NSButton) {
        //tell model to change the file to the new file
        Model.instance.selectFile(fileIndex: Model.instance.currentFileIndex![0]-1)
        delegte?.previous()
        if mediaIsPlaying{
            delegte?.play()
        }else{
            play_pauseAction(self)
        }
    }
    
    
    // Plays or pauses the media depending on the current state
    @IBAction func play_pauseAction(_ sender: Any) {
        //tell the model to play the media
        if mediaIsPlaying {
            //file playing
            delegte?.pause()
            //change image on button
            play_pauseButton.image = NSImage(named: NSImage.Name(rawValue: "Play button"))
            mediaIsPlaying = !mediaIsPlaying
        } else {
            //file isnt playing
            delegte?.play()
            mediaIsPlaying = !mediaIsPlaying
            //change image
            play_pauseButton.image = NSImage(named: NSImage.Name(rawValue: "Pause button"))
        }
        updateOutlets()//have a title in the bottom bar to show what file is opens
    }
    
    func stopMedia(){
        delegte?.pause()
        play_pauseButton.image = NSImage(named: NSImage.Name(rawValue: "Pause button"))
    }
    
    
    // Next button pressed and will go to the next file in the sublibrary
    @IBAction func nextAction(_ sender: NSButton) {
        //tell the model to change to file to the new file
        Model.instance.selectFile(fileIndex: Model.instance.currentFileIndex![0]+1)
        delegte?.next()
        if mediaIsPlaying{
            delegte?.play()
        }else{
            play_pauseAction(self)
        }
    }
    
    
    // Bookmark button pressed so show the bookmark dialog
    @IBAction func bookmarkAction(_ sender: NSButton) {
        //show popover
        let openVC = Model.instance.openFileDelegate as! FileOpenViewController
        openVC.view.addSubview(PopOverView)
        PopOverView.frame = NSRect(x: sender.frame.minX-100, y: sender.frame.minY-30, width: 220, height: 170)
        if let time = Model.instance.mediaPlayer?.currentTime() {
            bookmarkPopoverTimeLabel.stringValue = Utility.convertCMTimeToSeconds(time)
        } else {
            bookmarkPopoverTimeLabel.stringValue = "00:00:00"
        }
    }
    
    
    // Decoupled media button, tells Model to decouple media
    @IBAction func decoupleMediaAction(_ sender: NSButton) {
        Model.instance.openFileInWindow()
        if mediaIsPlaying{
            delegte?.play()
        }
        windowIsOpen = true
        decoupleButton.isEnabled = false
    }
    
    func recoupleMedia(){
        windowIsOpen = false
        decoupleButton.isEnabled = true
        Model.instance.currentFileOpen = nil
        updateOutlets()
    }
    
    // Called up the Model to update the buttons which are active
    func updateOutlets(_ windowOpen: Bool = false) {
        
        if let fileName = Model.instance.currentFileOpen{
            FileNameLabel.stringValue = fileName.filename
        }else if let fileName = Model.instance.currentFile{
            FileNameLabel.stringValue = fileName.filename
        }else{
            FileNameLabel.stringValue = ""
        }
        if let currentIndex = Model.instance.currentFileIndex {
            if currentIndex[0]+1 >= Model.instance.subLibrary.all().count {
                //hide forward button
                nextButton.isEnabled = false
            } else {
                nextButton.isEnabled = true
            }
            if currentIndex[0]-1 < 0 {
                //hide backwards button
                previousButton.isEnabled = false
            } else {
                previousButton.isEnabled = true
            }
        }
        if windowOpen{
            Model.instance.openFileDelegate?.showMediaContent()
        }
        //changes the bottom bar depending on type
        updateButtonsBasedOnType(fileType: Model.instance.currentFile?.fileType)
    }
    
    
    /**
        updates the buttons based on the type of the current file
     
        - parameter fileType: currentFile type
     */
    func updateButtonsBasedOnType(fileType: String?) {
        //might need to check open file type
        var type = fileType
        if let openType = Model.instance.currentFileOpen?.fileType {
            //is set to the openFile type in case looking at other types of files
            type = openType
        }
        switch type {
        case "image":
            play_pauseButton.isHidden = true//hide play button
            //hide volume button
            //hide scroll bar
            bookmarkButton.isHidden = true//hide bookmark button
            decoupleButton.isEnabled = true
        case "audio":
            play_pauseButton.isEnabled = true //show play button
            play_pauseButton.isHidden = false
            bookmarkButton.isEnabled = true//show bookmarks button
            bookmarkButton.isHidden = false
            //show scroll bar
            //show add to queue
            decoupleButton.isEnabled = true
        case "video":
            play_pauseButton.isEnabled = true //show play button
            play_pauseButton.isHidden = false
            bookmarkButton.isEnabled = true//show bookmarks button
            bookmarkButton.isHidden = false
            //show volume button
            //show scroll bar
            //show add to queue
            decoupleButton.isEnabled = true
        case "document":
            play_pauseButton.isHidden = true//hide play button
            //hide volume button
            //hide scroll bar
            decoupleButton.isEnabled = true
            bookmarkButton.isHidden = true//hide bookmark button
        default:
            disableEverything()
            print("bottom bar is default")
        }
        
        
    }
    //disables every button in the bar (used when first loaded)
    func disableEverything() {
        FileNameLabel.stringValue = ""
        nextButton.isEnabled = false
        previousButton.isEnabled = false
        bookmarkButton.isEnabled = false
        play_pauseButton.isEnabled = false
        decoupleButton.isEnabled = false
    }
    
    
    // Done button on popover pressed, used to add a bookmark
    @IBAction func BookmarkPopOverDone(_ sender: Any) {
        //check if time is valid
        //add bookmark with title as key and value as time
        Model.instance.addBookmark(label: bookmarkPopoverTextField.stringValue)
        bookmarkPopoverTextField.stringValue = ""
        PopOverView.removeFromSuperview()
    }
    
    
    // Close bookmark button was pressed to remove bookmark dialog
    @IBAction func closeBookmarkPopover(_ sender: Any) {
        PopOverView.removeFromSuperview()
        bookmarkPopoverTextField.stringValue = ""
    }
}
