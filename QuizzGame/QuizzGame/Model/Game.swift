//
//  QuizzGame.swift
//  QuizzGame
//
//  Created by Andrei Simedre on 30.11.2022.
//

import Foundation

class Game {
    var questions: [Question]
    var playerName: String
    
    init(_ playerName: String,  questions: [Question]) {
        self.questions = questions
        self.playerName = playerName
    }
}
