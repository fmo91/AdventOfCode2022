//
//  File.swift
//  
//
//  Created by Fernando Ortiz on 06/12/2022.
//

import Foundation

enum Day5B {
    typealias RawCrate = (content: Character, offset: Int)
    
    enum Day5Error: Error {
        case wrongInput
        case notACratesLine
        case notAStacksNumberLine
        case notAMovesLine
    }
    
    static func run(for input: [String]) throws -> String {
        enum State {
            case detectingCrates
            case readingMoves
        }
        
        var currentState = State.detectingCrates
        var crates: [RawCrate] = []
        var stacks: [Stack] = []

        for line in input {
            switch currentState {
            case .detectingCrates:
                do {
                    crates.append(contentsOf: try detectCrates(in: line))
                } catch {
                    let stacksCount = try numberOfStacks(in: line)
                    stacks = prepareStacks(count: stacksCount, crates: crates)
                    crates = []
                    
                    currentState = .readingMoves
                }
            case .readingMoves:
                guard !line.isEmpty else {
                    break
                }
                
                let move = try parseMove(from: line)
                move.apply(on: &stacks)
            }
        }
        
        return description(from: stacks)
    }
    
    static func prepareStacks(count: Int, crates: [RawCrate]) -> [Stack] {
        var stacks = [Stack].init(repeating: Stack(), count: count)
        
        for crate in crates {
            stacks[crate.offset].add(crate.content)
        }
        
        return stacks
    }
    
    static func numberOfStacks(in line: String) throws -> Int {
        guard
            line.first?.isWhitespace == true, // If not, this is a 'move' line
            let lastCharacter = line.last,
            let numberOfStacks = Int(String(lastCharacter))
        else {
            throw Day5Error.notAStacksNumberLine
        }
        
        return numberOfStacks
    }
    
    static func detectCrates(in line: String) throws -> [RawCrate] {
        enum State {
            case lookingForCrateStart
            case onCrate
            case lookingForCrateEnd
        }
        
        var currentState = State.lookingForCrateStart
        var result: [RawCrate] = []
        var index = 0
        
        for character in line {
            switch currentState {
            case .lookingForCrateStart:
                if character == "[" {
                    currentState = .onCrate
                } else if character.isWhitespace {
                    break
                } else {
                    throw Day5Error.notACratesLine
                }
            case .onCrate:
                if character.isLetter {
                    result.append((
                        content: character,
                        offset: Int(index / 4)
                    ))
                    currentState = .lookingForCrateEnd
                } else {
                    throw Day5Error.notACratesLine
                }
            case .lookingForCrateEnd:
                if character == "]" {
                    currentState = .lookingForCrateStart
                } else {
                    throw Day5Error.notACratesLine
                }
            }
            
            index += 1
        }
        
        return result
    }
    
    static func parseMove(from line: String) throws -> Move {
        let components = line
            .replacingOccurrences(of: "move ", with: "")
            .replacingOccurrences(of: " from ", with: "-")
            .replacingOccurrences(of: " to ", with: "-")
            .components(separatedBy: "-")
        
        guard components.count == 3,
              let movesCount = Int(components[0]),
              let moveFrom = Int(components[1]),
              let moveTo = Int(components[2]) else {
            throw Day5Error.notAMovesLine
        }
        
        return Move(
            count: movesCount,
            from: moveFrom,
            to: moveTo
        )
    }
    
    static func description(from stacks: [Stack]) -> String {
        var result = ""
        for stack in stacks {
            if let item = stack.content.first {
                result.append(String(item))
            }
        }
        return result
    }
    
    struct Stack {
        private(set) var content: [Character] = []
        var contentDescription: String {
            // For testing purposes
            var result = ""
            for item in content {
                result.append(item)
            }
            return result
        }
        
        /// For building stack from scratch
        mutating func add(_ item: Character) {
            content.append(item)
        }
        
        /// For moves
        mutating func push(_ item: Character) {
            content.insert(item, at: 0)
        }
        
        mutating func pop() -> Character {
            return content.removeFirst()
        }
    }
    
    struct Move {
        let count: Int
        let from: Int
        let to: Int
        
        func apply(on stacks: inout [Stack]) {
            var temp = Stack()
            
            for _ in 0 ..< count {
                let item = stacks[from - 1].pop()
                temp.push(item)
            }
            
            for _ in 0 ..< count {
                let item = temp.pop()
                stacks[to - 1].push(item)
            }
        }
    }
}
