//
//  Parser.swift
//  simpsonsviewer
//
//  Created by Jorge Encinas on 03/12/19.
//  Copyright © 2019 Jorge Encinas. All rights reserved.
//

import UIKit

protocol ParserDelegate {
    func doneParseGetCharacters(array: [Character], title: String?)
}

class Parser: NSObject {
    var delegate: ParserDelegate?
    
    func makeParseCharactersWith(data dataResponse: Data) {
        var title: String? = nil
        var characters = [Character]()
        do {
            let json = try JSONSerialization.jsonObject(with: dataResponse, options: []) as! [String: AnyObject]
            //print("JSON: \(json)")
            
            if let heading = json["Heading"] as? String {
                title = heading
            }
            
            if let objects = json["RelatedTopics"] as? [[String:Any]] {
                print("objects.count: \(objects.count)")
                for object in objects {
                    let character = Character()
                    
                    if let text = object["Text"] as? String {
                        
                        if let endOfSentence = text.firstIndex(of: "-") {
                            
                            let name = text[...endOfSentence]
                            character.characterName = String(name).replacingOccurrences(of: " -", with: "")
                            print("Name:\(character.characterName)")
                            
                            /*print("name: \(name)")
                            let newTex = String(name)
                            let newEnd = newTex.index(before: endOfSentence)
                            let characterName = newTex[...newEnd]
                            print("nameX: \(characterName)")
                            */
                            
                        }
                        

                        
                        print("Text: \(text) \n")
                        character.textTopic = text
                    }
                    
                    if let result = object["Result"] as? String {
                        print("Result: \(result) \n")
                        character.resultTopic = result
                    }
                    
                    if let iconData = object["Icon"] as? [String:AnyObject] {
                        
                        if let urlIcon = iconData["URL"] as? String {
                            print("urlIcon: \(urlIcon) \n\n")
                            character.imageUrl = urlIcon
                        }
                        
                    }
                    characters.append(character)
                }
            }
            
        }catch let error as NSError {
            print("error trying to convert data to JSON \(error.localizedDescription)")
        }
        
        
        delegate?.doneParseGetCharacters(array: characters, title: title)
    }
}
