//
//  File.swift
//  
//
//  Created by Fernando Ortiz on 05/12/2022.
//

import Foundation

enum Day4B {
    enum Day4Error: Error {
        case wrongInputFormat(reason: String)
    }
    
    static func run(for input: [String]) throws -> Int {
        var result = 0
        for line in input {
            let assignments = line.components(separatedBy: ",")
            guard assignments.count == 2 else {
                throw Day4Error.wrongInputFormat(reason: "Assignments are not separated by ','")
            }
            
            let firstElfRange = try CampSectionsRange(input: assignments[0])
            let secondElfRange = try CampSectionsRange(input: assignments[1])
            if firstElfRange.overlaps(secondElfRange) {
                result += 1
            }
        }
        return result
    }
    
    struct CampSectionsRange {
        let start: Int
        let end: Int
        
        init(start: Int, end: Int) {
            self.start = start
            self.end = end
        }
        
        init(input: String) throws {
            let components = input.components(separatedBy: "-")
            guard components.count == 2 else {
                throw Day4Error.wrongInputFormat(reason: "Range does not contain two sections")
            }
            guard let firstComponent = Int(components[0]),
                  let secondComponent = Int(components[1])
            else {
                throw Day4Error.wrongInputFormat(reason: "Section is not an integer")
            }
            self.start = firstComponent
            self.end = secondComponent
        }
        
        func overlaps(_ anotherSection: CampSectionsRange) -> Bool {
            if self.start > anotherSection.start {
                return self.start <= anotherSection.end // overlap
            } else {
                return anotherSection.start <= self.end // overlap
            }
        }
    }
}
