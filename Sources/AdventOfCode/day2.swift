//
//  File.swift
//  
//
//  Created by Fernando Ortiz on 02/12/2022.
//

import Foundation

enum Day2Error: Error {
    case wrongInput
}

func day2(for input: [String]) throws -> Int {
    return try input
        .map(day2Score(for:))
        .reduce(0, +)
}

func day2Score(for line: String) throws -> Int {
    let playInputs = line.components(separatedBy: " ")
    
    guard playInputs.count == 2 else {
        throw Day2Error.wrongInput
    }
    
    let opponentPlay = try Play(fromOpponentInput: playInputs[0])
    let ourPlay = try Play(fromOurInput: playInputs[1])
    
    return score(
        opponentPlay: opponentPlay,
        ourPlay: ourPlay
    )
}

private func score(opponentPlay: Play, ourPlay: Play) -> Int {
    let playScore = ourPlay.score
    
    let result = ourPlay.result(against: opponentPlay)
    let resultScore = result.score
    
    return playScore + resultScore
}

private enum Play {
    case rock, paper, scissors
    
    init(fromOpponentInput opponentPlay: String) throws {
        switch opponentPlay {
        case "A": self = .rock
        case "B": self = .paper
        case "C": self = .scissors
        default: throw Day2Error.wrongInput
        }
    }
    
    init(fromOurInput ourPlay: String) throws {
        switch ourPlay {
        case "X": self = .rock
        case "Y": self = .paper
        case "Z": self = .scissors
        default: throw Day2Error.wrongInput
        }
    }
    
    var score: Int {
        switch self {
        case .rock: return 1
        case .paper: return 2
        case .scissors: return 3
        }
    }
    
    func result(against otherPlay: Play) -> PlayResult {
        switch (self, otherPlay) {
        case (.rock, .rock): return .draw
        case (.rock, .paper): return .defeat
        case (.rock, .scissors): return .win
            
        case (.paper, .rock): return .win
        case (.paper, .paper): return .draw
        case (.paper, .scissors): return .defeat
            
        case (.scissors, .rock): return .defeat
        case (.scissors, .paper): return .win
        case (.scissors, .scissors): return .draw
        }
    }
}

private enum PlayResult {
    case win, draw, defeat
    
    var score: Int {
        switch self {
        case .win: return 6
        case .draw: return 3
        case .defeat: return 0
        }
    }
}
