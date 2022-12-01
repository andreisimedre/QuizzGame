//
//  GameViewController.swift
//  QuizzGame
//
//  Created by Andrei Simedre on 30.11.2022.
//

import Foundation
import UIKit

class GameViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answersTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
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
        
    }
    
    func initUI() {
        nameLabel.text = game.playerName
        answersTableView.delegate = self
        answersTableView.register(UINib(nibName: "RadioButtonCell", bundle: nil), forCellReuseIdentifier: "RadioButtonCell")
        questionLabel.text = game.getCurrentQuestionTitle()
        timerLabel.text = String(game.questionTimerCounter)
        nextButton.setTitle("Next", for: .normal)
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
        cell.selectionStyle = .none
        
        return cell
    }
}

extension GameViewController: GameDelegate {
    func questionTimerDidFinish() {
        timerLabel.text = String(game.questionTimerCounter)
    }
    
    func updateQuestionTimer() {
        timerLabel.text = String(game.questionTimerCounter)
    }
}
