//
//  HomeViewController.swift
//  QuizzGame
//
//  Created by Andrei Simedre on 30.11.2022.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var maximumLettersNumberLabel: UILabel!
    @IBOutlet weak var minimumLettersNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameTextfield.text = ""
        minimumLettersNumberLabel.isHidden = true
        maximumLettersNumberLabel.isHidden = truere
    }
    
    func initUI() {
        nameTextfield.placeholder = "Name"
        nameTextfield.autocorrectionType = .no
        nameTextfield.autocapitalizationType = .sentences
        nameTextfield.delegate = self
        startButton.setTitle("Start", for: .normal)
        startButton.roundCorners()
        startButton.isEnabled = false
        maximumLettersNumberLabel.text = "You have reached maximum number of letters."
        maximumLettersNumberLabel.textColor = .red
        maximumLettersNumberLabel.isHidden = true
        minimumLettersNumberLabel.text = "Name is too short.(Needs to be at least 3 letters)"
        minimumLettersNumberLabel.textColor = .red
        minimumLettersNumberLabel.isHidden = true
    }
    
    @discardableResult
    func isNameValid() -> Bool {
        if (3...29).contains(nameTextfield.text?.count ?? 0) {
            maximumLettersNumberLabel.isHidden = true
            minimumLettersNumberLabel.isHidden = true
            startButton.isEnabled = true
            return true
        } else if (nameTextfield.text?.count ?? 0) < 3 {
            minimumLettersNumberLabel.isHidden = false
            startButton.isEnabled = false
            return false
        }
        if (nameTextfield.text?.count ?? 0) == 30 {
            maximumLettersNumberLabel.isHidden = false
            startButton.isEnabled = true
            return false
        }
        return true
    }
    
    @IBAction func startButtonTapped() {
        performSegue(withIdentifier: "gameSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let gameViewController = segue.destination as? GameViewController, let playerName = nameTextfield.text else { return }
        
        gameViewController.game = Game(playerName, questions: loadQuestions())
    }
    
    func loadQuestions() -> [Question] {
        if let url = Bundle.main.url(forResource: "Questions", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                return jsonData.questions
            } catch {
                print("error:\(error)")
            }
        }
        return [Question]()
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return isNameValid() || range.location < 30
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        isNameValid()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isNameValid()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if isNameValid() {
            startButtonTapped()
        }
        return false
    }
}
