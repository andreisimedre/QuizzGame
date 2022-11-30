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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    func initUI() {
        nameTextfield.placeholder = "Name"
        nameTextfield.autocorrectionType = .no
        nameTextfield.autocapitalizationType = .words
        nameTextfield.delegate = self
        startButton.setTitle("Start", for: .normal)
        startButton.roundCorners()
    }
    
    @IBAction func startButtonTapped() {
        
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return (textField.text?.count ?? 0) < 30
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
    }
}
