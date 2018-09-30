//
//  main.swift
//  MediaLibraryManager
//
//  Created by Paul Crane on 18/06/18.
//  Modified by Max Huang and Sam Paterson on 16/08/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

// swiftlint:disable all

import Foundation

// Creating a library instance.
var library:MMCollection = MM_Collection()

// A variable to hold the results shown by the last `search`/`list` command.
var last = MMResultSet()


/**
 Generate a friendly prompt and wait for the user to enter a line of input
 
 - parameters:
 - prompt:           The prompt to use
 - strippingNewline: Strip the newline from the end of the line of
 input (true by default)
 - returns:  The result of `readLine`.
 - seealso:  readLine
 */
func prompt(_ prompt: String, strippingNewline: Bool = true) -> String? {
    print(prompt, terminator:"")
    return readLine(strippingNewline: strippingNewline)
}


/**
 The while-loop below implements a basic command line interface.
 */
while let line = prompt("> "){
    var commandString : String = ""
    var parts = line.split(separator: " ").map({String($0)})
    var command: MMCommand
    
    do{
        guard parts.count > 0 else {
            throw MMCliError.unknownCommand
        }
        
        commandString = parts.removeFirst()
        
        // Used to bash test. Ignores commenting in input.
        if commandString.first == "#" { print(""); continue }
        
        switch(commandString){
        case "list":
            command = SearchCommand(library, parts, listAll: true)
            break
        case "search":
            command = SearchCommand(library, parts)
            break
        case "add":
            command = AddCommand(library, parts, last)
            break
        case "set":
            command = SetCommand(library, parts, last)
            break
        case "del":
            command = DeleteCommand(library, parts, last)
            break
        case "del-all":
            command = DeleteCommand(library, parts, last, all: true)
        case "save-search":
            command = SaveCommand(library, parts, last, saveSearch: true)
            break
        case "save":
            command = SaveCommand(library, parts)
            break
        case "load":
            command = LoadCommand(library, parts)
            break
        case "detail":
            command = DetailCommand(library, parts, last)
            break
        case "help":
            command = HelpCommand()
            break
        case "quit":
            command = QuitCommand()
            break
        default:
            throw MMCliError.unknownCommand
        }
        
        // try execute the command and catch any thrown errors below
        try command.execute()
        
        // if there are any results from the command, print them out here
        if let results = command.results {
            results.show()
            last = results
        }
        
    }catch MMCliError.unknownCommand {
        print("command \"\(commandString)\" not found -- see \"help\" for list")
    }catch MMCliError.invalidParameters {
        print("invalid parameters for \"\(commandString)\" -- see \"help\" for list")
    }catch MMCliError.unimplementedCommand {
        print("\"\(commandString)\" is unimplemented")
    }catch MMCliError.missingResultSet {
        print("no previous results to work from...")
    }catch MMCliError.invalidFilepath {
        print("invalid filepath provided. Please check and try again")
    }catch MMCliError.invalidIndex {
        print("invalid index given -- see \"help\" for list")
    }catch MMCliError.indexOutOfRange {
        print("index given is outside valid range. Please check and try again")
    }catch MMCliError.invalidJSONExtension {
        print("file extension must be \".json\". Please check and try again")
    }catch MMCliError.noDataInCollection {
        print("there is no data to export - the collection is empty. Please check and try again")
    }catch MMCliError.exportFailed {
        print("export failed. Please check and try again")
    }
}
