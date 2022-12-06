//
//  File.swift
//  
//
//  Created by Fernando Ortiz on 05/12/2022.
//

import Foundation

enum Day3 {
    enum Day3Error: Error {
        case wrongCharacterInput
        case noRepeatedCharacter
    }
    
    static func run(for input: [String]) throws -> Int {
        var result = 0
        
        for line in input {
            let (firstHalf, secondHalf) = line.halves
            let repeatedCharacter = try findRepeatedCharacter(firstHalf, secondHalf)
            result += try priority(for: repeatedCharacter)
        }
        
        return result
    }
    
    static func priority(for character: Character) throws -> Int {
        guard character.isLetter else {
            throw Day3Error.wrongCharacterInput
        }
        
        let asciiValue = Int(character.asciiValue ?? 0)
        
        if character.isLowercase {
            return asciiValue - 96
        } else {
            return asciiValue - 38
        }
    }

    static func findRepeatedCharacter(_ firstString: String, _ secondString: String) throws -> Character {
        for character in firstString {
            if secondString.contains(character) {
                return character
            }
        }
        
        throw Day3Error.noRepeatedCharacter
    }
}

extension String {
    var halves: (String, String) {
        let halfIndex = self.index(startIndex, offsetBy: Int(count / 2))
        return (
            String(self[startIndex ..< halfIndex]),
            String(self[halfIndex ..< endIndex])
        )
    }
}
