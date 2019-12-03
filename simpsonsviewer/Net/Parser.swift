//
//  Parser.swift
//  simpsonsviewer
//
//  Created by Jorge Encinas on 03/12/19.
//  Copyright © 2019 Jorge Encinas. All rights reserved.
//

import UIKit

protocol ParserDelegate {
    func doneParseGetCharacters(array: [SimpsonsCharacter])
}

class Parser: NSObject {
    var delegate: ParserDelegate?
    
    func makeParseSimpsonsCharactersWith(data dataResponse: Data) {
        //print("makeParseSimpsonsCharactersWith \n")
        let simpson = SimpsonsCharacter()
        do {
            let json = try JSONSerialization.jsonObject(with: dataResponse, options: []) as! [String: AnyObject]
            print("JSON: \(json)")
            
        }catch let error as NSError {
            print("error trying to convert data to JSON \(error.localizedDescription)")
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: dataResponse) as! Dictionary<String, AnyObject>
            print("JSON: \(json)") //Heading
        } catch {
            print("error")
        }
        
        delegate?.doneParseGetCharacters(array: [simpson])
    }
}
