//
//  AppDelegate.swift
//  MediaLibraryManagerGUI
//
//  Created by Fire Breathing Rubber Duckies on 20/09/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var importMenuItem: NSMenuItem!
    @IBOutlet weak var clearLibraryMenuItem: NSMenuItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let window = NSApplication.shared.windows[0]
        Model.instance.window = window
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func importJson(_ sender: NSMenuItem) {
        Model.instance.addFile()
    }
    
    @IBAction func saveToJson(_ sender: NSMenuItem) {
        Model.instance.savePersistent()
    }
    
    @IBAction func clearLibrary(_ sender: NSMenuItem) {
        Model.instance.deleteAllFiles()
    }
    
    
}
