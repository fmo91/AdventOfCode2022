//
//  File.swift
//  
//
//  Created by Fernando Ortiz on 06/12/2022.
//

import Foundation

enum Day6 {
    enum Day6Error: Error {
        case wrongInput
        case missingInitialSequence
    }
    
    static func run(for input: String, markerLength: Int) throws -> Int {
        var offset = 0
        var substring = ""
        for character in input {
            offset += 1
            substring.append(character)
            if substring.count == markerLength {
                if containsUniqueCharacters(in: substring) {
                    return offset
                }
                substring.removeFirst()
            }
        }
        throw Day6Error.missingInitialSequence
    }
    
    static func containsUniqueCharacters(in text: String) -> Bool {
        var textCopy = text
        for _ in 0 ..< text.count {
            let character = textCopy.removeFirst()
            if textCopy.contains(character) {
                return false
            }
        }
        return true
    }
}
