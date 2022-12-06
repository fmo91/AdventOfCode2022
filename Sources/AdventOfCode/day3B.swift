//
//  File.swift
//  
//
//  Created by Fernando Ortiz on 05/12/2022.
//

import Foundation

enum Day3B {
    enum Day3Error: Error {
        case wrongCharacterInput
        case noRepeatedCharacter
        case wrongLinesCount
    }
    
    static func run(for input: [String]) throws -> Int {
        return try input.reduce(
            inPacksOf: 3,
            startingWith: 0,
            using: { (pack, partial) in
                let repeatedCharacter = try findRepeatedCharacter(in: pack)
                let repeatedCharacterPriority = try priority(for: repeatedCharacter)
                    
                return partial + repeatedCharacterPriority
            }
        )
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

    static func findRepeatedCharacter(in lines: [String]) throws -> Character {
        guard let firstLine = lines.first else {
            throw Day3Error.noRepeatedCharacter
        }
        
        for character in firstLine {
            if lines.allSatisfy({ line in
                line.contains(character)
            }) {
                return character
            }
        }
        
        throw Day3Error.noRepeatedCharacter
    }
}

extension Array {
    func reduce<R>(inPacksOf packLength: Int, startingWith initialResult: R, using reducer: (Self, R) throws -> R) rethrows -> R {
        var result = initialResult
        var lengthCounter = 0
        var pack: [Element] = []
        
        for item in self {
            lengthCounter += 1
            pack.append(item)
            
            if lengthCounter == packLength {
                result = try reducer(pack, result)
                
                lengthCounter = 0
                pack = []
            }
        }
        
        return result
    }
}
