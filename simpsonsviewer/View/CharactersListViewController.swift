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
    
    private var isSearch = false
    private var hasMovements = false
    
    private var allCharacters = [Character]()
    private var charactersFiltered = [Character]()
    private var selectedCharacter = Character()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableCharacters.delegate = self
        tableCharacters.dataSource = self
        getCharacters()
    }
    
    
    private func getCharacters() {
        let conector = Connector()
        conector.delegate = self
        conector.getSimpsonsCharacters()
    }
    
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == nil { return }
        
        if let characterViewDetail = segue.destination as? CharacterDetailViewController {
            characterViewDetail.character = selectedCharacter
        }
    }
    

}

//  MARK: Delegates CodiInteractor
extension CharactersListViewController: ConnectorDelegate
{
    
    func doneGetCharacters(success: Bool, arrayCharacters: [Character], title: String?) {
        if success{
            self.allCharacters = arrayCharacters
            self.isSearch = false
            self.charactersFiltered = allCharacters
            hasMovements = allCharacters.count > 0
            self.tableCharacters.reloadData()
            
            if let heading = title {
                labelTitle.text = heading
            }
        } else{
            print("Error")
        }
        
    }
    
}


//MARK: TableViewDelegate
extension CharactersListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterCellID") as! CharacterTableViewCell

        if self.hasMovements {
            let character = self.allCharacters[indexPath.row]
            cell.configureView(name: character.characterName)
            cell.selectionStyle = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Check if there are results
        tableView.separatorStyle = .none
        let numberOfRows = self.allCharacters.count
        if  numberOfRows > 0 {
            tableView.backgroundView = nil
        } else {
            
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.font =  UIFont(name: "HelveticaNeue-Bold", size: 16)!
            noDataLabel.text          = hasMovements ? "No results" : "Without characters"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
        }
        
        return numberOfRows
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60.0
        
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCharacter = self.allCharacters[indexPath.row]
        
        self.performSegue(withIdentifier: "goToDetail", sender: self)

        //tableCharacters.isUserInteractionEnabled = false
 

    }
    
    
}

