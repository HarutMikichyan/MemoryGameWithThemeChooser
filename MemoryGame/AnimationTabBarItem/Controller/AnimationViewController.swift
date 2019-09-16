//
//  AnimationViewController.swift
//  MemoryGame
//
//  Created by 1 on 9/15/19.
//  Copyright © 2019 1. All rights reserved.
//

import UIKit
import AudioToolbox

class AnimationViewController: UIViewController {
    
    @IBOutlet weak var animationButton: ShakeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationButton.layer.cornerRadius = animationButton.bounds.height / 2
    }
    
    @IBAction func animationButtonClicket(_ sender: ShakeButton) {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        sender.shake()
    }
}
