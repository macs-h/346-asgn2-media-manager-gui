//
//  cli.swift
//  MediaLibraryManager
//  COSC346 S2 2018 Assignment 1
//
//  Created by Paul Crane on 21/06/18.
//  Modified by Max Huang and Sam Paterson on 16/08/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

// swiftlint:disable all


import Foundation

// The list of exceptions that can be thrown by the CLI command handlers
enum MMCliError: Error {
    
    // Thrown if there is something wrong with the input parameters for the
    // command
    case invalidParameters
    
    // Thrown if there is no result set to work with (and this command depends
    // on the previous command)
    case missingResultSet
    
    // Thrown when the command is not understood
    case unknownCommand
    
    // Thrown if the command has yet to be implemented
    case unimplementedCommand
    
    // Thrown if an unknown filepath is given.
    case invalidFilepath
    
    // Thrown if an invalid index number is given.
    case invalidIndex
    
    // Thrown if the index number given is not within a valid range.
    case indexOutOfRange
    
    // Thrown if an invalid extension is provided to import or export a JSON
    // file.
    case invalidJSONExtension
    
    // Thrown if there is no data to export to a json file.
    case noDataInCollection
    
    // Thrown if exporting JSON failed.
    case exportFailed
    
}


// This class representes a set of results.
class MMResultSet{
    
    // The list of files produced by the command
    fileprivate var results: [MMFile]
    
    /**
     Constructs a new result set.
     
     - parameter results:    The list of files produced by the executed
     command, could be empty.
     */
    init(_ results:[MMFile]){
        self.results = results
    }
    
    
    /**
     Constructs a new result set with an empty list.
     */
    convenience init(){
        self.init([MMFile]())
    }
    
    /**
     If there are some results to show, enumerate them and print them out.
     - note: this enumeration is used to identify the files in subsequent
     commands.
     */
    func show(){
        guard self.results.count > 0 else{
            return
        }
        for (i,file) in self.results.enumerated() {
            print("\(i): \(file)")
        }
    }
    
    /**
     Determines if the result set has some results.
     
     - returns: True iff there are results in this set
     */
    func get(index: Int) throws -> MMFile{
        return self.results[index]
    }
    
    
    /**
     Returns the files listed on the last `list` or `search` command.
     
     - returns: An array of `MMFile`
     */
    func all() -> [MMFile] {
        return self.results
    }
}


/**
 This protocol specifies the new 'Command' pattern, and is more Object
 Oriented.
 */
protocol MMCommand{
    var results: MMResultSet? {get}
    func execute() throws
}


/**
 Initialises all the main commands using inheritance because each command
 requires the initialisation of the same variables each time.
 */
class CommandParent {
    var library: MMCollection
    var parts: [String]
    var last: MMResultSet
    
    /**
     Default initialiser
     
     - parameters:
     - library:  The collection to be used.
     - parts:    The input parameters following the command.
     - last:     The results from the last `list` or `search` command.
     */
    init(_ library: MMCollection, _ parts: [String], _ last: MMResultSet = MMResultSet()) {
        self.library = library
        self.parts = parts
        self.last = last
    }
    
    /**
     Creates a new file and metadata instance.
     
     - parameters:
     - parts:   The commandline arguments
     - last:    The list of last listed items
     
     - returns:  A tuple containing the metadata and file instance.
     - metadata:    A new metadata instance
     - file:        A new file instance
     */
    func makeMetadataAndFile(index: Int, let_parts: [String], last: MMResultSet)throws -> (metadata: MMMetadata, file: MMFile){
        var parts = let_parts
        let file = try last.get(index: index)
        let keyword = parts.removeFirst()
        var value = ""
        if parts.count == 1{
            //key value pair
            value = parts.removeFirst()
        }
        let metadata = MM_Metadata(keyword: keyword, value: value)
        return(metadata: metadata, file: file)
    }
}


/**
 Handles the `list` and `search` command.
 
 If no parameters are provided then the command operates as a `list` and
 shows all the file instances held in collection.
 If one or more keywords are specified, the command searches and returns any
 file instances which hold that keyword.
 
 Example usage: `list foo bar baz`
 Lists the set of files with metadata containing `foo` OR `bar` OR `baz`
 */
class SearchCommand: CommandParent, MMCommand {
    var results: MMResultSet?
    var search: Bool
    
    init(_ library: MMCollection, _ parts: [String], search: Bool = false) {
        self.search = search
        super.init(library, parts)
    }
    
    func execute() throws {
        if self.parts.isEmpty && search {
            throw MMCliError.invalidParameters
        } else if self.parts.isEmpty {
            // List everything in the collection.
            self.results = MMResultSet(self.library.all())
        } else {
            // Search collection based on keyword(s).
            var searchResults = [MMFile]()
            var usedKeywords = [String]()
            for keyword in self.parts {
                if !usedKeywords.contains(keyword) {
                    searchResults += self.library.search(term: keyword)
                    usedKeywords.append(keyword)
                }
            }
            
            // If there is more than one term to search for, check for
            // duplicates.
            if self.parts.count > 1 {
                var uniqueResults = [MMFile]()
                for result in searchResults {
                    var duplicate = false
                    for uniqueResult in uniqueResults {
                        //
                        // -------- REFACTOR ---------
                        //
                        // Should be checking against FILEPATH
                        if result.filename == uniqueResult.filename {
                            duplicate = true
                        }
                    }
                    if duplicate == false {
                        uniqueResults.append(result)
                    }
                }
                self.results = MMResultSet(uniqueResults)
            } else {
                self.results = MMResultSet(searchResults)
            }
        }
    }
}


/**
 Handles the `add` command.
 
 Adds key/value pairs to a file based on the index of the previous `list` or
 `search` command.
 
 Example usage: `add 0 foo bar baz qux`
 Using the results of the previous list, adds `foo=bar` and `baz=qux` to
 the file at index `0`.
 */
class AddCommand: CommandParent, MMCommand {
    var results: MMResultSet?
    
    func execute() throws {
        if self.last.all().isEmpty {
            throw MMCliError.missingResultSet
        }
        if self.parts.count < 3 || (self.parts.count - 1) % 2 != 0 {
            throw MMCliError.invalidParameters
        }
        
        if let index = Int(self.parts.removeFirst()) {
            if index < 0 || index >= self.last.all().count {
                throw MMCliError.indexOutOfRange
            }
            for _ in 0..<(self.parts.count/2) {
                let keyVal: [String] = [self.parts.removeFirst(), self.parts.removeFirst()]
                let data = try makeMetadataAndFile(index: index, let_parts: keyVal, last: self.last)
                self.library.add(metadata: data.metadata, file: data.file)
            }
        } else {
            throw MMCliError.invalidIndex
        }
    }
}


/**
 Handles the `set` command.
 
 Sets the value of a specific key for a file based on the index of the
 previous `list` or `search` command.
 
 Example usage: `set 0 foo bar baz qux`
 Using the results of the previous list, sets `foo=bar` and `baz=qux` for
 the file at index `0`.
 */
class SetCommand: CommandParent, MMCommand {
    var results: MMResultSet?
    
    func execute() throws {
        if self.last.all().isEmpty {
            throw MMCliError.missingResultSet
        }
        if self.parts.count < 3 || (self.parts.count - 1) % 2 != 0 {
            throw MMCliError.invalidParameters
        }
        
        if let index = Int(self.parts.removeFirst()) {
            if index < 0 || index >= self.last.all().count {
                throw MMCliError.indexOutOfRange
            }
            for _ in 0..<(self.parts.count/2) {
                let keyVal: [String] = [self.parts.removeFirst(), self.parts.removeFirst()]
                let data = try makeMetadataAndFile(index: index, let_parts: keyVal, last: self.last)
                self.library.set(metadata: data.metadata, file: data.file)
            }
        } else {
            throw MMCliError.invalidIndex
        }
    }
}


/**
 Handles the `del` command.
 
 Deletes the specified keys in a file based on the index of the previous
 `list` or `search` command.
 
 Example usage: `del 0 foo bar`
 Using the results of the previous list, del metadata where the key is
 equal to `foo` OR `bar` from the file at index `0`.
 */
class DeleteCommand: CommandParent, MMCommand {
    var results: MMResultSet?
    var all: Bool
    
    init(_ library: MMCollection, _ parts: [String], _ last: MMResultSet, all: Bool = false) {
        self.all = all
        super.init(library, parts, last)
    }
    
    func execute() throws {
        if self.all {
            // Delete entire collection.
            if self.parts.count != 0 {
                throw MMCliError.invalidParameters
            }
            self.library.removeAll()
            last.results.removeAll()
        } else {
            if self.parts.count < 1 {
                throw MMCliError.invalidParameters
            }
            
            if let index = Int(self.parts.first!) {
                self.parts.removeFirst()
                if self.last.all().isEmpty {
                    throw MMCliError.missingResultSet
                }
                if self.parts.count < 1 {
                    throw MMCliError.invalidParameters
                }
                if index < 0 || index >= self.last.all().count {
                    throw MMCliError.indexOutOfRange
                }
                
                for key in self.parts {
                    let data = try makeMetadataAndFile(index: index, let_parts: [key], last: last)
                    self.library.remove(metadata: data.metadata, file: data.file)
                }
            } else {
                // If the first parameter is NOT a number, assume that it is
                // deleting that keyword (and corresponding metadata) from the
                // entire collection.
                for key in self.parts {
                    self.library.remove(metadata: MM_Metadata(keyword: key, value: ""))
                }
            }
        }
    }
}


/**
 Handles the `save` and `save-search` command.
 
 The `save` command exports the entire library collection to an output file.
 The `save-search` command only exports the results from the last `list` or
 `search` command to an output file.
 
 Example usage: `save output.json` or `save-search output.json`
 Exports the entire collection to `output.json` or exports the results
 of the previous `list` or `search` to `output.json` in the current
 directory, respectively.
 */
class SaveCommand: CommandParent, MMCommand {
    var results: MMResultSet?
    var saveSearch: Bool
    
    init(_ library: MMCollection, _ parts: [String], _ last: MMResultSet = MMResultSet(), saveSearch: Bool = false) {
        self.saveSearch = saveSearch
        super.init(library, parts, last)
    }
    
    func execute() throws {
        if self.parts.count != 1 {
            throw MMCliError.invalidParameters
        }
        if self.last.all().isEmpty && saveSearch {
            throw MMCliError.missingResultSet
        }
        
        let filename = self.parts.removeFirst().lowercased()
        let file = MM_FileExport()
        if saveSearch {
            try file.write(filename: filename, items: self.last.all())
        } else {
            try file.write(filename: filename, items: self.library.all())
        }
    }
}


/**
 Handles the `load` command.
 
 The `load` command imports file(s) from the current directory into the
 library collection.
 
 Example usage: `load foo.json bar.json`
 From the current directory, load both `foo.json` and `bar.json` and
 merge the results.
 */
class LoadCommand: CommandParent, MMCommand {
    var results: MMResultSet?
    var fileImport = MM_FileImport()
    
    func execute() throws {
        if self.parts.count < 1 {
            throw MMCliError.invalidParameters
        }
        
        do {
            for filename in self.parts {
                let files = try self.fileImport.read(filename: filename.lowercased())
                for file in files {
                    self.library.add(file: file)
                }
            }
        } catch MMCliError.invalidJSONExtension {
            throw MMCliError.invalidJSONExtension
        } catch {
            throw MMCliError.invalidFilepath
        }
    }
}


/**
 Handles the `detail` command.
 
 Displays a detailed description of a previous `list` or `search` command
 based on the index (or indices) given.
 */
class DetailCommand: CommandParent, MMCommand {
    var results: MMResultSet?
    
    func execute() throws {
        if self.parts.count < 1 {
            throw MMCliError.invalidParameters
        }
        if self.last.all().isEmpty {
            throw MMCliError.missingResultSet
        }
        
        for _ in self.parts {
            if let index = Int(self.parts.removeFirst()) {
                let file = try last.get(index: index)
                print(file.details())
                
            } else {
                throw MMCliError.invalidParameters
            }
        }
    }
}


/**
 Handle unimplemented commands by throwing an exception when trying to
 execute this command.
 */
class UnimplementedCommand: MMCommand{
    var results: MMResultSet? = nil
    func execute() throws{
        throw MMCliError.unimplementedCommand
    }
}


/**
 Handles the 'help' command -- prints usage information
 
 - Attention:    There are some examples of the commands in the source code
 comments
 */
class HelpCommand: MMCommand{
    var results: MMResultSet? = nil
    func execute() throws{
        print("""
\thelp                              - this text
\tload <filename> ...               - load file into the collection
\tlist <term> ...                   - list all the files that have the term specified
\tlist                              - list all the files in the collection
\tsearch <term> ...                 - list all the files that have the term specified
\tdetail <number> ...               - show detailed description of file.
\tadd <number> <key> <value> ...    - add some metadata to a file
\tset <number> <key> <value> ...    - this is really a del followed by an add
\tdel <number> <key> ...            - removes a metadata item from a file
\tdel <key> ...                     - removes metadata from the collection.
\tdel-all                           - removes the whole collection
\tsave-search <filename>            - saves the last list results to a file
\tsave <filename>                   - saves the whole collection to a file
\tquit                              - exit the program (without prompts)
""")
        // for example:
        
        // load foo.json bar.json
        //      from the current directory load both foo.json and bar.json and
        //      merge the results
        
        // list foo bar baz
        //      results in a set of files with metadata containing foo OR bar OR baz
        
        // add 3 foo bar
        //      using the results of the previous list, add foo=bar to the file
        //      at index 3 in the list
        
        // add 3 foo bar baz qux
        //      using the results of the previous list, add foo=bar and baz=qux
        //      to the file at index 3 in the list
    }
}

/**
 Handle the quit command. Exits the program (with exit code 0) without
 checking if there is anything to save.
 */
class QuitCommand : MMCommand{
    var results: MMResultSet? = nil
    func execute() throws{
        exit(0)
    }
}
