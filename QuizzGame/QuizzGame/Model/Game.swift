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
    
    var currentQuestion = 0
    var selectedAnswerIndex = -1
    
    var questionTimer: Timer?
    var betweenQuestionsTimer: Timer?
    
    init(_ playerName: String,  questions: [Question]) {
        self.questions = questions
        self.playerName = playerName
    }
    
    func getCurrentAnswersSet() -> [String] {
        return questions[currentQuestion].answers
    }
    
    func getCurrentQuestionTitle() -> String {
        return questions[currentQuestion].question
    }
}
