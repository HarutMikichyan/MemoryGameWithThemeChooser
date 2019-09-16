//
//  ViewController.swift
//  MemoryGame
//
//  Created by 1 on 9/11/19.
//  Copyright © 2019 1. All rights reserved.
//

import UIKit
import AudioToolbox

class MemoryGameViewController: UIViewController {
    
    lazy private var game: MemoryGame = MemoryGame(numberOfPairOfCards: (cardButtons.count + 1) / 2)
    
    var flipCount: Int = 0 {
        willSet {
            if newValue == cardButtons.count * 3 {
                newGame(isWinner: false)
            }
        }
        didSet{
            updateFlipCountLabel()
        }
    }
    
    //MARK: - Outlets
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var flipCountLabel: UILabel! {
        didSet { updateFlipCountLabel() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animation()
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
        
        if game.matchedCardsCount == (cardButtons.count / 2) {
            newGame(isWinner: true)
        }
    }
    
    //MARK: - New Game
    func newGame(isWinner: Bool) {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        let alert = UIAlertController(title: isWinner ? "You Won" : "You Loose", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: isWinner ? "New Game" : "Try Again", style: .default, handler: { (action) in
            self.reset()
        }))
        
        self.present(alert, animated: true)
    }
    
    func reset() {
        emojiChoices = "👨🏻‍💻👻🎃👨🏿‍💻💩💀☠️🍔🏓🎾🎲🏛📱💻⏳"
        game = MemoryGame(numberOfPairOfCards: (self.cardButtons.count + 1) / 2)
        emoji = [Card: String]()
        Card.uniqueIdentifier = 0
        flipCount = 0
        
        for cardIndex in self.cardButtons.indices {
            self.cardButtons[cardIndex].isEnabled = true
        }
        updateViewFromModel()
    }

    
    private func updateViewFromModel() {
        if let _ = cardButtons {
            for index in cardButtons.indices {
                let button = cardButtons[index]
                let card = game.cards[index]
                
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for: .normal)
                    button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                } else {
                    button.setTitle("", for: .normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                    if card.isMatched {
                        button.isEnabled = false
                    }
                }
            }
        }
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key: Any] = [.strokeWidth: 5.0, .strokeColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1) ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    var theme: String? {
        didSet {
            emojiChoices = theme ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }
    
    //MARK: - Emoji Choices
    private var emojiChoices = "👨🏻‍💻👻🎃👨🏿‍💻💩💀☠️🍔🏓🎾🎲🏛📱💻⏳"//
    private var emoji = [Card: String]()
    
    private func emoji(for card: Card) -> String {
        let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
        if emoji[card] == nil, emojiChoices.count > 0 {
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
    
    //MARK: - Animation
    private func animation() {
        let stackAnimationDistance = buttonsStackView.bounds.height + view.bounds.height
        let flipAnimationDistance = flipCountLabel.bounds.height + view.bounds.height
        
        let rotationTransformStackView = CATransform3DTranslate(CATransform3DIdentity, 0, stackAnimationDistance, 0)
        let rotationTransformFlipCountLabel = CATransform3DTranslate(CATransform3DIdentity, 0, flipAnimationDistance, 0)
        
        buttonsStackView.layer.transform = rotationTransformStackView
        flipCountLabel.layer.transform = rotationTransformFlipCountLabel
        
        UIView.animate(withDuration: 1.0, animations: {
            self.buttonsStackView.layer.transform = CATransform3DIdentity
        })
        
        UIView.animate(withDuration: 1.2) {
            self.flipCountLabel.layer.transform = CATransform3DIdentity
        }
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0{
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
