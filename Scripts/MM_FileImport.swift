//
//  MM_FileImport.swift
//  MediaLibraryManager
//
//  Created by Max Huang and Sam Paterson on 16/08/18.
//  Copyright © 2018 SMAX. All rights reserved.
//

// swiftlint:disable all

import Foundation

/**
 Imports the media collection from a file (by name)
 */
class MM_FileImport : MMFileImport {
    
    /**
     Imports the media collection from a file (by name).
     
     - parameter filename:   The name of the file to be imported.
     - returns:  A list of all the files in the file.
     */
    func read(filename: String) throws -> [MMFile] {
        
        if filename.split(separator: ".").map({String($0)}).last != "json" {
            throw MMCliError.invalidJSONExtension
        }
        
        
        var importedFiles = [MM_File]()
        var filesToAdd = [MM_File]()
        
        let url = try Utility.instance.normalisePath(filename: filename)
        let encodedJsonData = try Data(contentsOf: url)
        
        // the struct mirrors the JSON data
        struct JSON: Codable {
            var fullpath: String
            var type: String
            var metadata: [String : String]
        }
        let decoder = JSONDecoder()
        let jsonData = try! decoder.decode([JSON].self, from: encodedJsonData)
        
        for attribute in jsonData {
            let f = MM_File()
            
            f.filename = {
                let path_reversed = String(attribute.fullpath.reversed())
                
                let start = path_reversed.startIndex
                let end = path_reversed.index(path_reversed.startIndex, offsetBy: path_reversed._bridgeToObjectiveC().range(of: "/").location)
                
                return String( path_reversed[start..<end].reversed() )
            }()
        
            f.fullpath = {
                var fullpath = filename
                
                let path_reversed = String(fullpath.reversed())
                let start = path_reversed.index(path_reversed.startIndex, offsetBy: path_reversed._bridgeToObjectiveC().range(of: "/").location)
                let end = path_reversed.endIndex
                
                fullpath = String( path_reversed[start..<end].reversed() )
//                path_reversed = String( attribute.fullpath.reversed() )
//
//                start = path_reversed.startIndex
//                end = path_reversed.index(path_reversed.startIndex, offsetBy: path_reversed._bridgeToObjectiveC().range(of: "/").location)
//
//                let filename = String( path_reversed[start..<end].reversed() )
                return fullpath + f.filename
            }()
            
            
            f.fileType = attribute.type
            
//            let path_reversed = String(f.fullpath.reversed())
//
//            let start = path_reversed.startIndex
//            let end = path_reversed.index(path_reversed.startIndex, offsetBy: path_reversed._bridgeToObjectiveC().range(of: "/").location)
//
//            f.filename = String( String( path_reversed[start..<end].reversed()) )
            
            for metadata in attribute.metadata {
                let data = MM_Metadata(keyword: metadata.key, value: metadata.value)
                f.metadata.append(data)
            }
            importedFiles.append(f)
        }
        
        // check for duplicates.
        for file in importedFiles {
            if Model.instance.library.search(term: file.fullpath).isEmpty {
                filesToAdd.append(file)
            } else {
                print("\(file.filename) already in collection")
            }
        }
        print(filesToAdd)
        return filesToAdd
    }
    
}
