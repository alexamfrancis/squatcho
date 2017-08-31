//
//  TeamTableViewCell.swift
//  Squatcho
//
//  Created by Alexandra Francis on 8/30/17.
//  Copyright © 2017 Marlexa. All rights reserved.
//

import UIKit

class TeamTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBAction func removeButton(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
