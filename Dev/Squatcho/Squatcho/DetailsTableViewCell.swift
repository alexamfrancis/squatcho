//
//  DetailsTableViewCell.swift
//  Squatcho
//
//  Created by Alexandra Francis on 8/3/17.
//  Copyright © 2017 Marlexa. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var ruleTitle: UILabel!
    @IBOutlet weak var ruleText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
