//
//  WSRTableViewCell.swift
//  WaterYouDrinking
//
//  Created by Noah Sutter on 4/23/17.
//  Copyright © 2017 Noah Sutter. All rights reserved.
//

import UIKit

class WSRTableViewCell: UITableViewCell {

    @IBOutlet weak var reportLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
