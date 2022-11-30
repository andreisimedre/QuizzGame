//
//  RadioButtonCelll.swift
//  QuizzGame
//
//  Created by Andrei Simedre on 30.11.2022.
//

import Foundation
import UIKit

class RadioButtonCell: UITableViewCell {
    @IBOutlet weak var radioImage: UIImageView!
    @IBOutlet weak var buttonTextLabel: UILabel!
    
    var didSelect: Bool = false {
        didSet {
            radioImage.image = didSelect ? UIImage(named: "radio_checked") : UIImage(named: "radio_unchecked")
        }
    }
}
