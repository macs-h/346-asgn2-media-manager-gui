//
//  MM_Metadata.swift
//  MediaLibraryManager
//
//  Created by Sam Paterson and Max Huang on 14/08/18.
//  Copyright © 2018 SMAX. All rights reserved.
//

// swiftlint:disable all

import Foundation

/**
 Represents metadata for a media file
 */
class MM_Metadata: MMMetadata{
    //    var keyword: String
    
    var keyword: String
    var value: String
    var description: String{
        return keyword + ": " + value
    }
    
    
    /**
     Default initialiser
     
     - Parameters:
     - keyword:  The keyword for the metadata
     - value:    The value the metadata should be initialised to
     */
    init(keyword: String, value: String) {
        self.keyword = keyword
        self.value = value
    }
    
    /**
     Convenience initialiser
     
     Currently sets variables to an emtpy `String`
     */
    convenience init(){
        self.init(keyword: "", value: "")
    }
}


extension MMMetadata {
    
    // note the 'self' in here
    static func == (lhs: Self, rhs: MMMetadata) -> Bool {
        return lhs.keyword == rhs.keyword && lhs.value == rhs.value
    }
    
    static func != (lhs: Self, rhs: MMMetadata) -> Bool{
        return !(lhs == rhs)
    }
}
