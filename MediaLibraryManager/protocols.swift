//
//  protocols.swift
//  MediaLibraryManager
//  COSC346 S2 2018 Assignment 1
//
//  Created by Paul Crane on 18/06/18.
//  Modified by Max Huang and Sam Paterson on 16/08/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

// swiftlint:disable colon opening_brace vertical_whitespace trailing_whitespace

import Foundation

/**
 Make sure you read the task in the README file as that forms the basis of
 this assignment.
 
 - important:    When you implement these protocols you should not remove
 anything from this file as our tests depend on this
 interface (and the following assignment too!)
 
 - note: You may add your own functions/properties etc. as needed -- we also
 encourage you to develop your own protocols.
 */


/**
 Represents a file with metadata (a key/value store)
 
 In this protocol we define three properties and that it must confrom to the
 CustomStringConvertable protocol (i.e. it also needs to have a description
 property).
 */
protocol MMFile: CustomStringConvertible{
    var metadata: [MMMetadata] {get set}
    var filename: String {get set}
    var fullpath: String {get set}
    var collectionPos: Int {get set}
    var fileType: String {get set}
    
    /**
     Searches all the metadata for a keyword
     
     - parameter keyword:    The file and associated metadata to add to the
     collection
     - returns:  Bool - describing whether the keyword was found
     */
    func searchMetadata(keyword: String) -> Int
    
    
    /**
     Accumulates all attributes into a single string array so that a term can
     be found
     
     - returns:  results - the array of string to `.contains` acted upon
     */
    func getAttributes() -> [String]
    
    func details() -> String
}


/**
 Protocol to represent metadata for a media file
 
 In this protocol we define three properties and that it must conform to the
 CustomStringConvertable protocol (i.e. it also needs to have a description
 property).
 
 We're using a simple key/value pair as our metadata. For example:
 
 IMG2018-06-18.png
 photographer: Paul Crane
 taken: 2018-06-18 10:14:54
 location: Dunedin, New Zealand
 
 When we search for the metadata, we ultimately want to display the files
 that have that metadata, we're keeping track of the associated file here.
 */
protocol MMMetadata: CustomStringConvertible{
    var keyword: String {get set}
    var value: String {get set}
}


/**
 The main functions of the media metadata collection.
 */
protocol MMCollection:CustomStringConvertible {
    
    /**
     Adds a file's metadata to the media metadata collection.
     
     - parameter file:   The file and associated metadata to add to the
     collection
     */
    func add(file: MMFile)
    
    
    /**
     Adds a specific instance of a metadata to the collection.
     
     - parameters:
     - metadata: The item to add to the collection.
     - file:     The file to add the metadata to within the collection.
     */
    func add(metadata: MMMetadata, file: MMFile)
    
    /**
     Sets the metadata in file to new key and value
     
     - parameters:
     - metadata:     The item to remove from the collection.
     - file:         The file to remove the metadata from.
     */
    func set(metadata: MMMetadata, file: MMFile)
    
    /**
     Removes a specific instance of a metadata from the collection.
     
     - parameter metadata:   The item to remove from the collection.
     */
    func remove(metadata: MMMetadata)
    
    
    /**
     Removes a specific instance of a metadata from a specific file.
     
     - parameters:
     - metadata: The item to remove from the file.
     - file:     The file to remove the metadata from.
     */
    func remove(metadata: MMMetadata, file: MMFile)
    
    
    /**
     Removes all files from the collection.
     */
    func removeAll()
    
    
    /**
     Finds all the files associated with the keyword.
     
     - parameter term:   The keyword to search for.
     - returns:  A list of all the metadata associated with the keyword,
     possibly an empty list.
     */
    func search(term: String) -> [MMFile]
    
    
    /**
     Returns a list of all the files in the index.
     
     - returns:  A list of all the files in the index, possibly an empty list
     */
    func all() -> [MMFile]
    
    
    /**
     Finds all the metadata associated with the keyword of the item.
     
     - parameter item:   The item's keyword to search for.
     - returns:  A list of all the metadata associated with the item's
     keyword, possibly an empty list.
     */
    func search(item: MMMetadata) -> [MMFile]
    
}


/**
 Support importing the media collection from a file (by name)
 */
protocol MMFileImport {
    func read(filename: String) throws -> [MMFile]
}

///
/// Support exporting the media collection to a file (by name)
protocol MMFileExport {
    func write(filename: String, items: [MMFile]) throws
}
