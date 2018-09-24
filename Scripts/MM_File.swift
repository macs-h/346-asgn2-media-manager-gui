//
//  MMFile.swift
//  MediaLibraryManager
//
//  Created by Max Huang and Sam Paterson on 14/08/18.
//  Copyright © 2018 SMAX. All rights reserved.
//

import Foundation

/**
 Represents a file with metadata (a key/value store)
 */
class MM_File: MMFile {

    var filename: String = ""
    var fullpath: String = ""
    var fileType: String = ""
    var description: String {
        return filename
    }
    var collectionPos = 0

    // Keeping track of the concrete instances
    private var _metadata: [MM_Metadata] = []

    // Converting the instances to obey the MMFile protocol
    var metadata: [MMMetadata] {
        get {
            var result: [MMMetadata] = []
            for m in self._metadata {
                result.append(m as MMMetadata)
            }
            return result
        }
        set(value) {
            var result: [MM_Metadata] = []
            for v in value {
                if let m = v as? MM_Metadata {
                    result.append(m)
                }
            }
            _metadata = result
        }
    }

    /**
     Default initialiser
     
     - Parameters:
     - metadata: A key/value store
     - filename: The name of the file
     - path:     The filepath to the file
     */
    init(metadata: [MM_Metadata], filename: String, path: String) {
        self.metadata = metadata
        self.filename = filename
        self.fullpath = path
    }

    /**
     Convenience initialiser
     
     Initialises all fields to empty.
     */
    convenience init() {
        self.init(metadata: [], filename: "", path: "")
    }

    /**
     Searches all the metadata for a keyword
     
     - parameter keyword:    The file and associated metadata to add to the
     collection
     - returns:  Bool - describing whether the keyword was found
     */
    func searchMetadata(keyword: String) -> Int {
        var i = 0
        for item in self.metadata {
            if item.keyword == keyword {
                return i
            }
            i += 1
        }
        return -1
    }

    /**
     Accumulates all attributes into a single string array so that a term can
     be found
     
     - returns:  results - the array of string to `.contains` acted upon
     */
    func getAttributes() -> [String] {
        var results: [String] = []
        results.append(filename)
        results.append(fullpath)
        results.append(fileType)
        for data in metadata {
            results.append(data.keyword)
            results.append(data.value) // Waiting on clarification from Paul about search implementation.
        }
        return results
    }

    func details() -> String {
        if metadata.count > 0 {
            var results: [String] = []
            for data in metadata {
                results.append(data.description)
            }
            return "Filename: \(filename)\nType: \(fileType)\nMetadata {\n\t" + results.joined(separator: "\n\t")+"\n}"
        } else {
            return "Data{}"
        }
    }
}

extension MMFile {

    // note the 'self' in here
    static func == (lhs: Self, rhs: MMFile) -> Bool {
        return lhs.fullpath == rhs.fullpath
    }

    static func != (lhs: Self, rhs: MMFile) -> Bool {
        return !(lhs == rhs)
    }
}
