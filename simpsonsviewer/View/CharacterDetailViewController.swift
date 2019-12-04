//
//  CharacterDetailViewController.swift
//  simpsonsviewer
//
//  Created by Jorge Encinas on 04/12/19.
//  Copyright © 2019 Jorge Encinas. All rights reserved.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    
    @IBOutlet weak var nameCharacter: UILabel!
    @IBOutlet weak var imageCharacter: UIImageView!
    @IBOutlet weak var textViewCharacter: UITextView!
    
    var character = Character()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInfo()
    }
    
    fileprivate func setupInfo() {
        nameCharacter.text = character.characterName
        textViewCharacter.text = character.textTopic
    }


}
