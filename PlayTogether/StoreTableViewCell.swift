//
//  StoreTableViewCell.swift
//  PlayTogether
//
//  Created by mac on 1/5/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class StoreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}