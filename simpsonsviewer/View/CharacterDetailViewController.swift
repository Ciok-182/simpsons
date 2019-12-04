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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var character = Character()
    
    var imageURL : URL?{
        didSet{
            //image = nil
            //Check if I'm on screen
            if view.window != nil{
                fetchImage()
            }
        }
    }
    
    private var image: UIImage?{
        get{
            return imageCharacter.image
        }
        set{
            imageCharacter.image = newValue
            spinner.stopAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInfo()
    }
    
    fileprivate func setupInfo() {
        nameCharacter.text = character.characterName
        textViewCharacter.text = character.textTopic
        imageURL = URL(string: character.imageUrl)
        spinner.hidesWhenStopped = true
        fetchImage()
    }
    
    private func fetchImage() {
        spinner.startAnimating()
        if let url = imageURL{
            //DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            DispatchQueue.global().async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContents, url == self?.imageURL {
                        self?.image = UIImage(data: imageData)
                    }
                    
                }
            }
        } else {
            spinner.stopAnimating()
        }
    }

}
