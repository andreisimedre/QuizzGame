//
//  Question.swift
//  QuizzGame
//
//  Created by Andrei Simedre on 30.11.2022.
//

import Foundation

enum QuestionKeys: String {
    case id = "id"
    case question = "question"
    case answer = "answer"
    case correctAnswer = "correctAnswer"
}

struct ResponseData: Decodable {
    var questions: [Question]
}

struct Question: Decodable {
    let question: String
    let answers: [String]
    let correctIndex: Int
    
    init(rawDictionary: [String: Any]) {
        question = rawDictionary[QuestionKeys.question.rawValue] as? String ?? ""
        answers = rawDictionary[QuestionKeys.answer.rawValue] as? [String] ?? [String]()
        correctIndex = rawDictionary[QuestionKeys.correctAnswer.rawValue] as? Int ?? 0
    }
}
