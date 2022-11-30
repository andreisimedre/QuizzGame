//
//  UIView + Extension.swift
//  QuizzGame
//
//  Created by Andrei Simedre on 30.11.2022.
//

import Foundation
import UIKit

extension UIView {
    func roundCorners(_ radius: CGFloat = 5) {
        self.layer.cornerRadius = radius
    }
}
