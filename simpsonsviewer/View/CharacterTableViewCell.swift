//
//  CharacterTableViewCell.swift
//  simpsonsviewer
//
//  Created by Jorge Encinas on 04/12/19.
//  Copyright © 2019 Jorge Encinas. All rights reserved.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var labelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureView(name: String) {
        labelName.text = name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
