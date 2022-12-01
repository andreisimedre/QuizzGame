//
//  QuizzGame.swift
//  QuizzGame
//
//  Created by Andrei Simedre on 30.11.2022.
//

import Foundation

protocol GameDelegate: AnyObject {
    func questionTimerDidFinish()
    func questionTimerDidChanged()
    func betweenQuestionsTimerCounterDidChanged()
    func betweenQuestionsTimerCounterDidFinish()
    func selectedAnswerDidChanged()
}

struct GameConstants {
    static let questionTimerCounter = 10
    static let betweenQuestionsTimerCounter = 3
}

class Game {
    var questions: [Question]
    var playerName: String
    
    var currentQuestion = 0
    var selectedAnswerIndex = -1 {
        didSet {
            delegate?.selectedAnswerDidChanged()
        }
    }
    
    var finished = false
    private var correctAnswers = 0
    
    var questionTimer: Timer?
    var questionTimerCounter = GameConstants.questionTimerCounter
    var betweenQuestionsTimer: Timer?
    var betweenQuestionsTimerCounter = GameConstants.betweenQuestionsTimerCounter
    
    weak var delegate: GameDelegate?
    
    init(_ playerName: String,  questions: [Question]) {
        self.questions = questions
        self.playerName = playerName
        
        startQuestionTimer()
    }
    
    func getCurrentAnswersSet() -> [String] {
        return questions[currentQuestion].answers
    }
    
    func getCurrentQuestionTitle() -> String {
        return questions[currentQuestion].question
    }
    
    func getCurrentQuestion() -> Question {
        return questions[currentQuestion]
    }
    
    func checkSelectedAnswer() -> Bool {
        if selectedAnswerIndex == -1 {
            return false
        }
        return selectedAnswerIndex == questions[currentQuestion].correctIndex
    }
    
    func updateCorrectAnswers() {
        guard checkSelectedAnswer() else { return }
        correctAnswers += 1
    }
    
    func finishGame() {
        
    }
    
    func startQuestionTimer() {
        questionTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(questionTimerHandler), userInfo: nil, repeats: true)
    }
    
    func resetQuestionTimer() {
        questionTimerCounter = GameConstants.questionTimerCounter
        questionTimer?.invalidate()
    }
    
    func startBetweenQuestionsTimer() {
        betweenQuestionsTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(betweenQuestionsTimerHandler), userInfo: nil, repeats: true)
    }
    
    func resetBetweenQuestionTimer() {
        betweenQuestionsTimerCounter = GameConstants.betweenQuestionsTimerCounter
        betweenQuestionsTimer?.invalidate()
    }
    
    @objc func questionTimerHandler() {
        if questionTimerCounter == 0 {
            delegate?.questionTimerDidFinish()
            questionTimer?.invalidate()
            startBetweenQuestionsTimer()
        } else {
            questionTimerCounter -= 1
            delegate?.questionTimerDidChanged()
        }
    }
    
    @objc func betweenQuestionsTimerHandler() {
        if betweenQuestionsTimerCounter == 0 {
            questionTimerCounter = GameConstants.questionTimerCounter
            updateCorrectAnswers()
            currentQuestion += 1
            finished = currentQuestion == questions.count
            delegate?.betweenQuestionsTimerCounterDidFinish()
            betweenQuestionsTimer?.invalidate()
            betweenQuestionsTimerCounter = GameConstants.betweenQuestionsTimerCounter
        } else {
            betweenQuestionsTimerCounter -= 1
            delegate?.betweenQuestionsTimerCounterDidChanged()
        }
    }
}
