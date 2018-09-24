//
//  MM_Collection.swift
//  MediaLibraryManager
//
//  Created by Max Huang and Sam Paterson on 16/08/18.
//  Copyright © 2018 SMAX. All rights reserved.
//

// swiftlint:disable all

import Foundation

/**
 The main functions of the media metadata collection
 */
class MM_Collection: MMCollection {
    
    var collection: [MMFile]
    
    var description: String {
        let coll = self.all()
        if coll.count > 0 {
            var results: [String] = []
            for file in coll {
                results.append(file.description)
            }
            return "Collection [" + results.joined(separator: "] [")+"]"
        } else {
            return "Collection []"
        }
    }

    /**
     Default initialiser
     
     - parameter collection: An array containing the files and associated
     metadata to initialise the collection with
     */
    init(collection: [MMFile]) {
        self.collection = collection
    }

    /**
     Convenience initialiser
     
     Initialises the collection as an empty array.
     */
    convenience init () {
        self.init(collection: [])
    }

    /**
     Adds a file's metadata to the media metadata collection.
     
     - parameter file:   The file and associated metadata to add to the
     collection.
     */
    func add(file: MMFile) {
        var tempFile = file
        tempFile.collectionPos = (collection.count > 0) ? collection.count : 0
        self.collection.append(tempFile)
    }

    /**
     Adds a specific instance of a metadata to the collection.
     
     - parameters:
     - metadata: The item to add to the collection.
     - file:     The file to add the metadata to within the collection.
     */
    func add(metadata: MMMetadata, file: MMFile) {
        var files = search(term: file.filename)
        for i in 0..<files.count {
            collection[files[i].collectionPos].metadata.append(metadata)
        }
    }

    /**
     Sets the metadata in file to new key and value
     
     - parameters:
     - metadata:     The item to remove from the collection.
     - file:         The file to remove the metadata from.
     */
    func set(metadata: MMMetadata, file: MMFile) {
        if collection.count > 0 {
            let metaIndex = file.searchMetadata(keyword: metadata.keyword)
            if metaIndex != -1 {
                //file was found
                collection[file.collectionPos].metadata.remove(at: metaIndex)
                collection[file.collectionPos].metadata.append(metadata)
            }else {
                print("\(metadata.keyword) not found in file \(file.filename)")
            }
        }
    }
    
    /**
     Removes a specific instance of a metadata from the collection.
     
     - parameter metadata:   The item to remove from the collection.
     */
    func remove(metadata: MMMetadata) {
        let files = search(item: metadata)
        if files.count > 0 {
            for i in 0..<files.count {
                // swiftlint:disable line_length
                if confirm(item: metadata.keyword) {
                    collection[files[i].collectionPos].metadata.remove(at: files[i].searchMetadata(keyword: metadata.keyword))
                }
            }
        } else {
            print("\(metadata.keyword) not found")
        }
        
    }
    
    
    /**
     Removes a specific instance of a metadata from a specific file.
     
     - parameters:
     - metadata: The item to remove from the file.
     - file:     The file to remove the metadata from.
     */
    func remove(metadata: MMMetadata, file: MMFile) {
        if collection.count > 0 {
            let metaIndex = file.searchMetadata(keyword: metadata.keyword)
            if metaIndex != -1{
                if(confirm(item: metadata.keyword)){
                    collection[file.collectionPos].metadata.remove(at: metaIndex)
                }
            }else{
                print("\(metadata.keyword) not found in file \(file.filename)")
            }
        }
    }
    
    /**
     Removes all files from the collection
     */
    func removeAll() {
        if(collection.count > 0){
            if(confirm(item: "all")){
                collection.removeAll()
            }
        }
    }
    
    /**
     Finds all the files associated with the keyword.
     
     - parameter term:   The keyword to search for.
     
     - returns:  A list of all the metadata associated with the keyword,
     possibly an empty list.
     */
    func search(term: String) -> [MMFile] {
        if collection.count > 0{
            var results: [MMFile] = []
            for file in collection{
                //search each feild
                if(file.getAttributes().contains(term)){
                    results.append(file)
                }
            }
            return results
        }else{
            return []
        }
        
    }
    
    
    /**
     Returns a list of all the files in the index.
     
     - returns:  A list of all the files in the index, possibly an empty list
     */
    func all() -> [MMFile] {
        if collection.count > 0{
            var results: [MMFile] = []
            for file in collection{
                results.append(file)
            }
            return results
        }else{
            return []
        }
    }
    
    
    /**
     Finds all the metadata associated with the keyword of the item.
     
     - parameter item:   The item's keyword to search for.
     
     - returns:  A list of all the metadata associated with the item's
     keyword, possibly an empty list.
     */
    func search(item: MMMetadata) -> [MMFile] {
        if collection.count > 0{
            var results: [MMFile] = []
            for file in collection{
                if(file.searchMetadata(keyword: item.keyword) != -1){
                    results.append(file)
                }
            }
            return results
        }else{
            return []
        }
    }
    
    /**
     Asks the user to confirm there action.
     
     - returns:  Whether or not the user has confirmed the action.
     */
    private func confirm(item: String) -> Bool{
        if(item == "all"){
            print("Are you sure you want to remove all [y/N]?")
        }else{
            print("Are you sure you want to remove '\(item)' [y/N]?")
        }
        let input = readLine(strippingNewline: true)?.lowercased()
        if(input == "y" || input == "yes"){
            return true
        }
        return false
    }
}
