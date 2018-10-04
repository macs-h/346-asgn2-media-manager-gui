//
//  BottomBarViewController.swift
//  MediaLibraryManagerGUI
//
//  Created by Sam Paterson on 2/10/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa

protocol bottomBarDelegate{
    func play()
    func pause()
    func next()
    func previous()
}

class BottomBarViewController: NSViewController {

    @IBOutlet weak var previousButton: NSButton!
    @IBOutlet weak var play_pauseButton: NSButton!
    @IBOutlet weak var nextButton: NSButton!
    @IBOutlet weak var bookmarkButton: NSButton!
    var delegte: bottomBarDelegate?
    var mediaIsPlaying = false
    //popOver variables
    @IBOutlet var PopOverView: NSView!
    @IBOutlet weak var bookmarkPopoverTimeLabel: NSTextField!
    @IBOutlet weak var bookmarkPopoverTextField: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        Model.instance.bottomBarVC = self
    }
    
    @IBAction func PreviousAction(_ sender: NSButton) {
        //tell model to change the file to the new file
        Model.instance.selectFile(fileIndex: Model.instance.currentFileIndex![0]-1)
        delegte?.previous()
    }
    @IBAction func play_pauseAction(_ sender: NSButton) {
        //tell the model to play the media
       // Model.instance.openFile()  //-- move to disconect window function
        if mediaIsPlaying{
            //file playing
            delegte?.pause()
            //change image on button
            play_pauseButton.image = NSImage(named: NSImage.Name(rawValue: "Play button"))
            mediaIsPlaying = !mediaIsPlaying
        }else{
            //file isnt playing
            delegte?.play()
            mediaIsPlaying = !mediaIsPlaying
            //change image
            play_pauseButton.image = NSImage(named: NSImage.Name(rawValue: "Pause button"))
        }
        //have a title in the bottom bar to show what file is opens
    }
    
    
    @IBAction func nextAction(_ sender: NSButton) {
        //tell the model to change to file to the new file
        print("next action")
        Model.instance.selectFile(fileIndex: Model.instance.currentFileIndex![0]+1)
        delegte?.next()
        
    }
    
    @IBAction func bookmarkAction(_ sender: NSButton) {
        //show popover
        let openVC = Model.instance.openFileDelegate as! FileOpenViewController
        openVC.view.addSubview(PopOverView)
        PopOverView.frame = NSRect(x: sender.frame.minX-100, y: sender.frame.maxY+20, width: 220, height: 170)
        if let time = Model.instance.mediaPlayer?.currentTime(){
            bookmarkPopoverTimeLabel.stringValue = Utility.convertCMTimeToSeconds(time)
        }else{
            bookmarkPopoverTimeLabel.stringValue = "00:00:00"
        }
        
        
        
    }
    
    func updateOutlets(){
        
        if Model.instance.currentFileIndex![0]+1 >= Model.instance.subLibrary.all().count{
            //hide forward button
            nextButton.isEnabled = false
        }else{
            nextButton.isEnabled = true
        }
        if Model.instance.currentFileIndex![0]-1 < 0{
            //hide backwards button
            previousButton.isEnabled = false
        }else{
            previousButton.isEnabled = true
        }
        //changes the bottom bar depending on type
        updateButtonsBasedOnType(fileType: Model.instance.currentFile!.fileType)
    }
    
    func updateButtonsBasedOnType(fileType: String){
        //might need to check open file type
        var type = fileType
        if let openType = Model.instance.currentFileOpen?.fileType{
            //is set to the openFile type in case looking at other types of files
            type = openType
        }
        switch type {
        case "image":
//            play_pauseButton.isHidden = true//hide play button
            //hide volume button
            //hide scroll bar
            bookmarkButton.isHidden = true//hide bookmark button
            break
        case "audio":
            //show play button
            //show volume button
            //show scroll bar
            //show add to queue
            break
        case "video":
            //show play button
            //show volume button
            //show scroll bar
            //show add to queue
            break
        case "document":
//            play_pauseButton.isHidden = true//hide play button
            //hide volume button
            //hide scroll bar
            bookmarkButton.isHidden = true//hide bookmark button
            break
        default:
            //dont hide anything
            print("bottom bar is default")
        }
        
    }
    @IBAction func BookmarkPopOverDone(_ sender: Any) {
        //check if time is valid
        //add bookmark with title as key and value as time
        print("trying to add label",bookmarkPopoverTextField.stringValue)
        Model.instance.addBookmark(label: bookmarkPopoverTextField.stringValue)
        bookmarkPopoverTextField.stringValue = ""
        PopOverView.removeFromSuperview()
    }
    
    @IBAction func closeBookmarkPopover(_ sender: Any) {
        PopOverView.removeFromSuperview()
        bookmarkPopoverTextField.stringValue = ""
    }
}
