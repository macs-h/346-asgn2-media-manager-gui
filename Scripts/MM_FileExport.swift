//
//  MM_FileExport.swift
//  MediaLibraryManager
//
//  Created by Max Huang and Sam Paterson on 16/08/18.
//  Copyright © 2018 SMAX. All rights reserved.
//

import Foundation

/**
 Exports the media collection to a file (by name)
 */
class MM_FileExport : MMFileExport {
    
    /**
     Exports the media collection to a file (by name).
     
     - parameters:
     - filename: The filename the file should be written as.
     - items:    A list of all the files to be written.
     */
    func write(filename: String, items: [MMFile]) throws {
        if filename.split(separator: ".").map({String($0)}).last != "json" {
            throw MMCliError.invalidJSONExtension
        }
        
        let url = try Utility.normalisePath(filename: filename)
        
        // the struct mirrors the JSON data
        struct JSON: Codable {
            var fullpath: String
            var type: String
            var metadata: [String : String]
        }
        
        var jsonArray = [JSON]()
        for item in items {
            var metadata = [String:String]()
            for data in item.metadata {
                metadata[data.keyword] = data.value
            }
            jsonArray.append(JSON(fullpath: item.fullpath, type: item.fileType, metadata: metadata))
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try encoder.encode(jsonArray)
        
        if items.isEmpty {
            throw MMCliError.noDataInCollection
        }
        let jsonString = String(data: jsonData, encoding: .utf8)!.replacingOccurrences(of: "\\", with: "")
        
        do {
            try jsonString.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            throw MMCliError.exportFailed
        }
    }
    
}
