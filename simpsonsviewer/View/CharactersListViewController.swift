//
//  CharactersListViewController.swift
//  simpsonsviewer
//
//  Created by Jorge Encinas on 03/12/19.
//  Copyright © 2019 Jorge Encinas. All rights reserved.
//

import UIKit

class CharactersListViewController: UIViewController {
    
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewTableHeader: UIView!
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet var txtFilter: UITextField?
    @IBOutlet weak var tableCharacters: UITableView!
    
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
        showTextFilter()
        searchIsEnabled(enabled: hasMovements)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hasMovements = allCharacters.count > 0
        //tableCharacters.isUserInteractionEnabled = true
    }
    
    
    private func getCharacters() {
        let conector = Connector()
        conector.delegate = self
        conector.getSimpsonsCharacters()
    }
    
    fileprivate func searchIsEnabled(enabled:Bool) {
        txtFilter?.isEnabled = enabled
        searchImage.alpha = enabled ? 1 : 0.5
    }
    
    // MARK: - Filter
    
    fileprivate func showTextFilter() {
        self.txtFilter = UITextField(frame: CGRect(x: 60, y: 5, width: self.view.frame.width - 60, height: 40))
        print("self.txtFilter.frame.width: \(self.txtFilter!.frame.width)")
        txtFilter!.returnKeyType = .search
        txtFilter!.delegate = self
        txtFilter!.placeholder = "Search character"
        txtFilter!.clearButtonMode = .whileEditing
        
        self.viewTableHeader.addSubview(txtFilter!)
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
            hasMovements = charactersFiltered.count > 0
            searchIsEnabled(enabled: hasMovements)
            self.tableCharacters.reloadData()
            
            if let heading = title {
                labelTitle.text = heading
            }
        } else{
            hasMovements = false
            print("Error")
        }
    }
}


//MARK: TableViewDelegate
extension CharactersListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterCellID") as! CharacterTableViewCell

        if self.hasMovements {
            let character = self.charactersFiltered[indexPath.row]
            cell.configureView(name: character.characterName)
            cell.selectionStyle = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Check if there are results
        tableView.separatorStyle = .none
        let numberOfRows = self.charactersFiltered.count
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
        
        selectedCharacter = self.charactersFiltered[indexPath.row]
        
        self.performSegue(withIdentifier: "goToDetail", sender: self)

        //tableCharacters.isUserInteractionEnabled = false
 

    }
    
}

//MARK: TextFieldDelegate
extension CharactersListViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.placeholder = nil
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
        }) { (_) in
            
            textField.becomeFirstResponder()
        }
        
        if isSearch {
            return
        }
        
        isSearch = true
        
        self.charactersFiltered.removeAll()
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        //print("newString: \(newString)")
        
        if newString.count == 0 {
            
            isSearch = false
            
            self.charactersFiltered = allCharacters
            
        } else {
            
            self.charactersFiltered.removeAll()
            
            self.charactersFiltered = allCharacters.filter{ $0.characterName.lowercased().contains(newString.lowercased()) || $0.textTopic.lowercased().contains(newString.lowercased())
                
            }
            //print("charactersFiltered:  \(charactersFiltered.count)")
            
            self.tableCharacters.reloadData()
        }
        
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        isSearch = (textField.text?.count)! == 0 ? false : true
        
        if !isSearch {
            self.charactersFiltered = allCharacters
            txtFilter!.placeholder = "Search character"
        }

        self.tableCharacters.reloadData()
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        isSearch = (textField.text?.count)! == 0 ? false : true
        
        if !isSearch {
            self.charactersFiltered = allCharacters
        }

        self.tableCharacters.reloadData()
        textField.resignFirstResponder()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        self.charactersFiltered = allCharacters
        
        self.tableCharacters.reloadData()
        
        return true
    }
    
}

