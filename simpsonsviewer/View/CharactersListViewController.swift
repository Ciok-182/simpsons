//
//  CharactersListViewController.swift
//  simpsonsviewer
//
//  Created by Jorge Encinas on 03/12/19.
//  Copyright © 2019 Jorge Encinas. All rights reserved.
//

import UIKit

class CharactersListViewController: UIViewController {
    
    @IBOutlet weak var tableCharacters: UITableView!
    @IBOutlet weak var labelTitle: UILabel!
    
    
    
    private let dataSource = "http://api.duckduckgo.com/?q=simpsons+characters&format=json"

    override func viewDidLoad() {
        super.viewDidLoad()
        getCharacters()
    }
    
    
    private func getCharacters() {
        let conector = Connector()
        conector.delegate = self
        conector.getSimpsonsCharacters()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//  MARK: Delegates CodiInteractor
extension CharactersListViewController: ConnectorDelegate
{
    
    func doneGetCharacters(success: Bool, arrayCharacters: [Character], title: String?) {
        if success{
            print("\n\n Success \(arrayCharacters.count) characters")
            if let heading = title {
                labelTitle.text = heading
            }
        } else{
            print("Error")
        }
        
    }
    
}
