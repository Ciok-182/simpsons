//
//  Connector.swift
//  simpsonsviewer
//
//  Created by Jorge Encinas on 03/12/19.
//  Copyright © 2019 Jorge Encinas. All rights reserved.
//

import UIKit


protocol ConnectorDelegate {
    func doneGetCharacters(success: Bool, arrayCharacters: [SimpsonsCharacter])
}

class Connector: NSObject {
    
    var delegate: ConnectorDelegate?
    
    fileprivate let DATA_SOURCE = "http://api.duckduckgo.com/?q=simpsons+characters&format=json"
    
    func getSimpsonsCharacters() {
        //print("getSimpsonsCharacters \n")
        guard let url = URL(string: DATA_SOURCE) else {
            print("Invalid url")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
             
            if let error = error {
                // Handle Error
                self.delegate?.doneGetCharacters(success: false, arrayCharacters: [SimpsonsCharacter()])
                print("Error: \(error.localizedDescription)")
                return
            }
            guard response != nil else {
                // Handle Empty Response
                self.delegate?.doneGetCharacters(success: false, arrayCharacters: [SimpsonsCharacter()])
                print("Empty Response ")
                return
            }
            guard let data = data else {
                // Handle Empty Data
                self.delegate?.doneGetCharacters(success: false, arrayCharacters: [SimpsonsCharacter()])
                print("Empty Data")
                return
            }
            
            let parser: Parser = Parser()
            parser.delegate = self
            parser.makeParseSimpsonsCharactersWith(data: data)
            
        })
        
        task.resume()
    }
    
    
}

extension Connector : ParserDelegate{
    func doneParseGetCharacters(array: [SimpsonsCharacter]) {
        //print("doneParseGetCharacters \n")
        self.delegate?.doneGetCharacters(success: true, arrayCharacters: array)
    }
}
