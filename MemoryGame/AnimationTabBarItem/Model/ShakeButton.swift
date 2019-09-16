//
//  ShakeButton.swift
//  MemoryGame
//
//  Created by 1 on 9/15/19.
//  Copyright © 2019 1. All rights reserved.
//

import UIKit

class ShakeButton: UIButton {
    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.fromValue = CGPoint(x: center.x - 5, y: center.y)
        shake.toValue = CGPoint(x: center.x + 5, y: center.y)
        shake.repeatCount = 5
        shake.duration = 0.06
        shake.autoreverses = true
        
        self.layer.add(shake, forKey: "position")
    }
}
