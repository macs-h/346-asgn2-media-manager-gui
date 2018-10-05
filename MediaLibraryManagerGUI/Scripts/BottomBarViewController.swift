//
//  BottomBarViewController.swift
//  MediaLibraryManagerGUI
//
//  Created by Fire Breathing Rubber Duckies on 2/10/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

// DOUBLE CHECK

import Cocoa

// ---------------- COMMENT THIS ---------------------
// swiftlint:disable class_delegate_protocol
protocol bottomBarDelegate {
    func play()
    func pause()
    func next()
    func previous()
}


/**
    // ---------------- COMMENT THIS ---------------------
 */
class BottomBarViewController: NSViewController {

    @IBOutlet weak var previousButton: NSButton!
    @IBOutlet weak var play_pauseButton: NSButton!
    @IBOutlet weak var nextButton: NSButton!
    @IBOutlet weak var bookmarkButton: NSButton!
    var delegte: bottomBarDelegate?
    var mediaIsPlaying = false
    
    @IBOutlet weak var decoupleButton: NSButton!
    
    //popOver variables
    @IBOutlet var PopOverView: NSView!
    @IBOutlet weak var bookmarkPopoverTimeLabel: NSTextField!
    @IBOutlet weak var bookmarkPopoverTextField: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
       Model.instance.bottomBarVC = self
    }
    
    
    // ---------------- COMMENT THIS ---------------------
    @IBAction func PreviousAction(_ sender: NSButton) {
        //tell model to change the file to the new file
        Model.instance.selectFile(fileIndex: Model.instance.currentFileIndex![0]-1)
        delegte?.previous()
    }
    
    
    // ---------------- COMMENT THIS ---------------------
    @IBAction func play_pauseAction(_ sender: NSButton) {
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
        //have a title in the bottom bar to show what file is opens
    }
    
    
    // ---------------- COMMENT THIS ---------------------
    @IBAction func nextAction(_ sender: NSButton) {
        //tell the model to change to file to the new file
        print("next action")
        Model.instance.selectFile(fileIndex: Model.instance.currentFileIndex![0]+1)
        delegte?.next()
    }
    
    
    // ---------------- COMMENT THIS ---------------------
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
    
    
    // ---------------- COMMENT THIS ---------------------
    @IBAction func decoupleMediaAction(_ sender: NSButton) {
        Model.instance.openFileInWindow()
    }
    
    
    func updateOutlets() {
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
        //changes the bottom bar depending on type
        updateButtonsBasedOnType(fileType: Model.instance.currentFile?.fileType)
    }
    
    
    /**
        // ---------------- COMMENT THIS ---------------------
     
        - parameter fileType: The type of file.
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
    func disableEverything() {
        nextButton.isEnabled = false
        previousButton.isEnabled = false
        bookmarkButton.isEnabled = false
        play_pauseButton.isEnabled = false
        decoupleButton.isEnabled = false
    }
    
    
    // ---------------- COMMENT THIS ---------------------
    @IBAction func BookmarkPopOverDone(_ sender: Any) {
        //check if time is valid
        //add bookmark with title as key and value as time
        Model.instance.addBookmark(label: bookmarkPopoverTextField.stringValue)
        bookmarkPopoverTextField.stringValue = ""
        PopOverView.removeFromSuperview()
    }
    
    
    // ---------------- COMMENT THIS ---------------------
    @IBAction func closeBookmarkPopover(_ sender: Any) {
        PopOverView.removeFromSuperview()
        bookmarkPopoverTextField.stringValue = ""
    }
}
