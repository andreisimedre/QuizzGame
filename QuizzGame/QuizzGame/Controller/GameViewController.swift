//
//  GameViewController.swift
//  QuizzGame
//
//  Created by Andrei Simedre on 30.11.2022.
//

import Foundation
import UIKit
import JellyGif

class GameViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answersTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var congratulationsView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var congratulationsImageViewContainer: UIView!
    @IBOutlet weak var goHomeButton: UIButton!
    
    var game: Game!
    var previouslySelectedCell: RadioButtonCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game.delegate = self
        
        initUI()
    }
    
    @IBAction func backButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @IBAction func nextButtonTapped() {
        game.resetQuestionTimer()
        game.resetBetweenQuestionTimer()
        game.startBetweenQuestionsTimer()
        highlightCorrectAnswer()
        highlightWrongAnswer()
        nextButton.setTitle(String(game.betweenQuestionsTimerCounter), for: .normal)
        nextButton.isEnabled = false
        answersTableView.allowsSelection = false
    }
    
    func initUI() {
        nameLabel.text = game.playerName
        answersTableView.delegate = self
        answersTableView.register(UINib(nibName: "RadioButtonCell", bundle: nil), forCellReuseIdentifier: "RadioButtonCell")
        answersTableView.rowHeight = UITableView.automaticDimension
        answersTableView.estimatedRowHeight = 200
        questionLabel.text = game.getCurrentQuestionTitle()
        timerLabel.text = String(game.questionTimerCounter)
        nextButton.setTitle("Next", for: .normal)
        nextButton.roundCorners()
        nextButton.isEnabled = false
        goHomeButton.setTitle("Go Home", for: .normal)
        goHomeButton.roundCorners()
        
        let gifImageView = JellyGifImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: congratulationsImageViewContainer.frame.size.width - 50, height: congratulationsImageViewContainer.frame.size.height)))
        gifImageView.contentMode = .scaleAspectFit
        
        gifImageView.startGif(with: .name("congratulations"))
        
        let constraint = NSLayoutConstraint(item: gifImageView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)

        congratulationsImageViewContainer.addSubview(gifImageView)
        self.view.addConstraint(constraint)
        congratulationsView.isHidden = true
    }
    
    func showCongratulationsView() {
        congratulationsView.isHidden = false
        if game.correctAnswers > 0 {
            scoreLabel.text = "Congratulations you have \(game.correctAnswers) correct \(game.correctAnswers == 1 ? "answer" : "answers") from a total of \(game.questions.count) questions. That is \(game.correctAnswerPercentage)% correct answers."
        } else {
            scoreLabel.text = "Unfortunatelly you missed all your answers. Better luck next time."
            congratulationsImageViewContainer.isHidden = true
        }
    }
    
    func getNextQestion() {
        if !game.finished {
            nextButton.setTitle("Next", for: .normal)
            game.selectedAnswerIndex = -1
            questionLabel.text = game.getCurrentQuestionTitle()
            answersTableView.reloadData()
            game.resetQuestionTimer()
            game.startQuestionTimer()
            game.resetBetweenQuestionTimer()
            answersTableView.allowsSelection = true
        } else {
            game.finishGame()
            showCongratulationsView()
        }
    }
    
    func highlightCorrectAnswer() {
        guard let cell = answersTableView.cellForRow(at: IndexPath(row: game.getCurrentQuestion().correctIndex, section: 0)) as? RadioButtonCell else { return }
        
        cell.overlay.backgroundColor = .green
    }
    
    func highlightWrongAnswer() {
        guard !game.checkSelectedAnswer() else { return }
        guard let cell = answersTableView.cellForRow(at: IndexPath(row: game.selectedAnswerIndex, section: 0)) as? RadioButtonCell else { return }
        
        cell.overlay.backgroundColor = .red
    }
}

extension GameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RadioButtonCell else { return }
        guard cell != previouslySelectedCell else { return }
        
        cell.didSelect = !cell.didSelect
        previouslySelectedCell?.didSelect = false
        previouslySelectedCell = cell
        game.selectedAnswerIndex = indexPath.row
    }
}

extension GameViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game.getCurrentAnswersSet().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RadioButtonCell") as? RadioButtonCell else { return UITableViewCell() }
        
        cell.buttonTextLabel.text = game.getCurrentAnswersSet()[indexPath.row]
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        cell.selectionStyle = .none
        
        return cell
    }
}

extension GameViewController: GameDelegate {
    func selectedAnswerDidChanged() {
        nextButton.isEnabled = !(game.selectedAnswerIndex == -1)
    }
    
    func betweenQuestionsTimerCounterDidFinish() {
        timerLabel.text = String(game.questionTimerCounter)
        getNextQestion()
        previouslySelectedCell = nil
    }
    
    func betweenQuestionsTimerCounterDidChanged() {
        nextButton.setTitle(String(game.betweenQuestionsTimerCounter), for: .normal)
    }
    
    func questionTimerDidFinish() {
        timerLabel.text = String(game.questionTimerCounter)
        nextButton.setTitle(String(game.betweenQuestionsTimerCounter), for: .normal)
        highlightCorrectAnswer()
        highlightWrongAnswer()
        nextButton.isEnabled = false
        answersTableView.allowsSelection = false
    }
    
    func questionTimerDidChanged() {
        timerLabel.text = String(game.questionTimerCounter)
    }
}
