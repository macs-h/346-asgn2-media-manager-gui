//
//  Utility.swift
//  MediaLibraryManagerGUI
//
//  Created by Max Huang on 2/10/18.
//  Copyright © 2018 Fire Breathing Rubber Duckies. All rights reserved.
//

import Cocoa
import AVKit

class Utility {
    static var instance = Utility()
    
    
    func normalisePath(filename: String) throws -> URL {
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
        print("--- URL:", result)
        return result
    }
    
    //------------------------------------------------------------------------80
    // Time conversions. Seconds <-> CMTime
    //------------------------------------------------------------------------80
    
    func convertCMTimeToSeconds(_ cmTime: CMTime) -> String {
        let seconds = CMTimeGetSeconds(cmTime)
        return convertSecondsToHuman(Float(seconds))
    }
    
    func convertSecondsToCMTime(_ seconds: Int, _ timeScale: Int32) -> CMTime {
        let cmTime = CMTimeMakeWithSeconds(Float64(seconds), timeScale)
        print(cmTime)
        return cmTime
    }
    
    func convertHumanStringToSeconds(_ humanTime: String) -> Float64 {
        return Float64( convertHumanToSeconds(humanTime) )
    }
    
    fileprivate func convertSecondsToHuman(_ seconds: Float) -> String {
        let hours = Int( floor(seconds / 3600) )
        let mins = Int( floor( seconds.truncatingRemainder(dividingBy: 3600) / 60) )
        let secs = Int( seconds.truncatingRemainder(dividingBy: 60) )
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: "\(hours)-\(mins)-\(secs)")
        let returnStr = dateFormatter.string(from: date!)
        
        return returnStr
    }
    
    fileprivate func convertHumanToSeconds(_ humanTime: String) -> Int {
        let time = humanTime.components(separatedBy: ":")
        var seconds: Int = 0
        
        seconds += Int(time[0])! * 3600
        seconds += Int(time[1])! * 60
        seconds += Int(time[2])!
    
        return seconds
    }
}

extension NSImage {
    
    /// The height of the image.
    var height: CGFloat {
        return size.height
    }
    
    /// The width of the image.
    var width: CGFloat {
        return size.width
    }
    
    /// A PNG representation of the image.
    var PNGRepresentation: Data? {
        if let tiff = self.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
            return tiffData.representation(using: .png, properties: [:])
        }
        
        return nil
    }
    
    // MARK: Resizing
    /// Resize the image to the given size.
    ///
    /// - Parameter size: The size to resize the image to.
    /// - Returns: The resized image.
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
    
    /// Copy the image and resize it to the supplied size, while maintaining it's
    /// original aspect ratio.
    ///
    /// - Parameter size: The target size of the image.
    /// - Returns: The resized image.
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
