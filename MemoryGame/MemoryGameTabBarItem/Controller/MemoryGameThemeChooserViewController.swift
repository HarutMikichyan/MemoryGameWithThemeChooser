//
//  MemoryGameThemeChooserViewController.swift
//  MemoryGame
//
//  Created by 1 on 9/13/19.
//  Copyright © 2019 1. All rights reserved.
//

import UIKit

class MemoryGameThemeChooserViewController: UIViewController {
    
    var lastDetailController: MemoryGameViewController?
    let themes = ["Sports": "⚽️🏀🏈🎾🏐🏉🎱🏓🏒🥊", "Animals": "🐶🐱🐭🐹🐰🦊🐸🙈🙉🙊", "Faces": "😀🤣😅😂😇😉🙃😋😎😭🥶"]
    
    //MARK: - Outlets
    @IBOutlet weak var sportsTheme: UIButton!
    @IBOutlet weak var facesTheme: UIButton!
    @IBOutlet weak var animalsTheme: UIButton!
    @IBOutlet weak var memoryGameTitle: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animation()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? MemoryGameViewController {
                    cvc.theme = theme
                }
            }
        }
    }
    
    //MARK: - Action
    var oldThemeName: String?
    @IBAction func changeTheme(_ sender: UIButton) {
        guard let themeName = sender.currentTitle, let _ = themes[themeName] else { return }
        //every time if you push another button, new game starts
        if let oldThemeName = oldThemeName, oldThemeName != themeName {
            lastDetailController?.reset()
            self.oldThemeName = themeName
        } else {
            oldThemeName = themeName
        }
        
        if let detail = splitViewController?.viewControllers.last as? MemoryGameViewController {
            detail.theme = themes[themeName]
        } else if let lastDetailController = lastDetailController {
            lastDetailController.theme = themes[themeName]
            navigationController?.pushViewController(lastDetailController, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    //MARK: - Animation
    private func animation() {
        let animationDistance = sportsTheme.bounds.width + view.bounds.width
        let titleAnimationDistance = memoryGameTitle.bounds.height + view.bounds.width
        
        let rotationTransformSportsTheme = CATransform3DTranslate(CATransform3DIdentity, animationDistance, 0, 0)
        let rotationTransformFacesTheme = CATransform3DTranslate(CATransform3DIdentity, animationDistance, 0, 0)
        let rotationTransformAnimalsTheme = CATransform3DTranslate(CATransform3DIdentity, animationDistance, 0, 0)
        let rotationTransformTitle = CATransform3DTranslate(CATransform3DIdentity, titleAnimationDistance, 0, 0)
        
        sportsTheme.layer.transform = rotationTransformSportsTheme
        facesTheme.layer.transform = rotationTransformFacesTheme
        animalsTheme.layer.transform = rotationTransformAnimalsTheme
        memoryGameTitle.layer.transform = rotationTransformTitle
        
        UIView.animate(withDuration: 0.6, animations: {
            self.memoryGameTitle.layer.transform = CATransform3DIdentity
        })
        
        UIView.animate(withDuration: 0.8, animations: {
            self.sportsTheme.layer.transform = CATransform3DIdentity
        })
        
        UIView.animate(withDuration: 1.0) {
            self.facesTheme.layer.transform = CATransform3DIdentity
        }
        
        UIView.animate(withDuration: 1.2) {
            self.animalsTheme.layer.transform = CATransform3DIdentity
        }
    }
}

extension MemoryGameThemeChooserViewController: UISplitViewControllerDelegate {
    override func awakeFromNib() {
        self.splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? MemoryGameViewController, cvc.theme == nil {
            lastDetailController = cvc
            return true
        }
        return false
    }
}
