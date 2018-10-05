//
//  Utility.swift
//  MediaLibraryManagerGUI
//
//  Created by Fire Breathing Rubber Duckies on 2/10/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa
import AVKit

/**
    A utility class with static helper functions.
 */
class Utility {

    /**
        Normalises a given string to a URL.
     
        - parameter filename: The filepath as a string.
        - returns: The full filepath.
     */
    static func normalisePath(filename: String) throws -> URL {
        let start = filename.index(after: filename.startIndex)
        let end = filename.endIndex
        
        var result: URL
        switch filename.prefix(1) {
        case "/":
            result = URL(fileURLWithPath: filename)
        case "~":
            result = FileManager.default.homeDirectoryForCurrentUser
            result.appendPathComponent(String(filename[start..<end]))
        case ".":
            result = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            result.appendPathComponent(String(filename[start..<end]))
        default:
            // treat it as if it were in the current working directory
            result = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            result.appendPathComponent(filename)
        }
        return result
    }
    
    
    //------------------------------------------------------------------------80
    // Time conversions. Seconds <-> CMTime
    //------------------------------------------------------------------------80
    
    /**
        Converts `CMTime` into human readable time.
     
        - parameter cmTime: The time in `CMTime` format.
        - returns: The time as a `String` in the format `HH:mm:ss`.
     */
    static func convertCMTimeToSeconds(_ cmTime: CMTime) -> String {
        return convertSecondsToHuman(Float( CMTimeGetSeconds(cmTime) ))
    }
    
    
    /**
        Converts time in seconds to `CMTime`.
     
        - parameters:
            - seconds:   Time in seconds.
            - timeScale: The preferred timescale.
        - returns: The time in `CMTime` format.
     */
    static func convertSecondsToCMTime(_ seconds: Int, _ timeScale: Int32) -> CMTime {
        return CMTimeMakeWithSeconds(Float64(seconds), timeScale)
    }
    
    
    /**
        Converts human readable time to seconds.
     
        - parameter humanTime: String representing time in `HH:mm:ss`.
        - returns: The seconds converted to `Double`.
     */
    static func convertHumanStringToSeconds(_ humanTime: String) -> Float64 {
        return Float64( convertHumanToSeconds(humanTime) )
    }
    
    
    /**
        Converts seconds into a human readable string.
     
        - parameter seconds: The seconds as a float.
        - returns: A string representation in the format `HH:mm:ss`.
     */
    static fileprivate func convertSecondsToHuman(_ seconds: Float) -> String {
        let hours = Int( floor(seconds / 3600) )
        let mins = Int( floor( seconds.truncatingRemainder(dividingBy: 3600) / 60) )
        let secs = Int( seconds.truncatingRemainder(dividingBy: 60) )
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: "\(hours)-\(mins)-\(secs)")
        let returnStr = dateFormatter.string(from: date!)
        
        return returnStr
    }
    
    
    /**
        Converts a human readable time to seconds.
     
        - parameter humanTime: Time in the format `HH:mm:ss`.
        - returns: The time in seconds.
     */
    static fileprivate func convertHumanToSeconds(_ humanTime: String) -> Int {
        let time = humanTime.components(separatedBy: ":")
        var seconds: Int = 0
        
        seconds += Int(time[0])! * 3600
        seconds += Int(time[1])! * 60
        seconds += Int(time[2])!
    
        return seconds
    }
}



extension NSImage {
    
    // The height of the image.
    var height: CGFloat {
        return size.height
    }
    
    // The width of the image.
    var width: CGFloat {
        return size.width
    }
    
    // A PNG representation of the image.
    var PNGRepresentation: Data? {
        if let tiff = self.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
            return tiffData.representation(using: .png, properties: [:])
        }
        return nil
    }
    

    /**
        Resizes the image to the given size.
     
        - parameter size: The size to resize the image to.
        - returns: The resized image.
     */
    func resize(withSize targetSize: NSSize) -> NSImage? {
        let frame = NSRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        guard let representation = self.bestRepresentation(for: frame, context: nil, hints: nil) else {
            return nil
        }
        let image = NSImage(size: targetSize, flipped: false, drawingHandler: { (_) -> Bool in
            return representation.draw(in: frame)
        })
        
        return image
    }
    

    /**
        Copy the image and resize it to the supplied size, while maintaining
        its original aspect ratio.
     
        - parameter size: The target size of the image.
        - returns: The resized iamge.
     */
    func resizeMaintainingAspectRatio(withSize targetSize: NSSize) -> NSImage? {
        let newSize: NSSize
        let widthRatio  = targetSize.width / self.width
        let heightRatio = targetSize.height / self.height
        
        if widthRatio < heightRatio {
            newSize = NSSize(width: floor(self.width * widthRatio),
                             height: floor(self.height * widthRatio))
        } else {
            newSize = NSSize(width: floor(self.width * heightRatio),
                             height: floor(self.height * heightRatio))
        }
        return self.resize(withSize: newSize)
    }
}
