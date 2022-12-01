//
//  QuizzGame.swift
//  QuizzGame
//
//  Created by Andrei Simedre on 30.11.2022.
//

import Foundation

protocol GameDelegate: AnyObject {
    func questionTimerDidFinish()
    func updateQuestionTimer()
}

class Game {
    var questions: [Question]
    var playerName: String
    
    var currentQuestion = 0
    var selectedAnswerIndex = -1
    
    var questionTimer: Timer?
    var questionTimerCounter = 45
    var betweenQuestionsTimer: Timer?
    var betweenQuestionsTimerCounter = 0
    
    weak var delegate: GameDelegate?
    
    var callback: (() -> Void)?
    
    init(_ playerName: String,  questions: [Question]) {
        self.questions = questions
        self.playerName = playerName
        
        questionTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(questionTimerHandler), userInfo: nil, repeats: true)
    }
    
    func getCurrentAnswersSet() -> [String] {
        return questions[currentQuestion].answers
    }
    
    func getCurrentQuestionTitle() -> String {
        return questions[currentQuestion].question
    }
    
    @objc func questionTimerHandler() {
        if questionTimerCounter == 0 {
            questionTimerCounter = 45
            delegate?.questionTimerDidFinish()
        } else {
            questionTimerCounter -= 1
            delegate?.updateQuestionTimer()
        }
    }
}
