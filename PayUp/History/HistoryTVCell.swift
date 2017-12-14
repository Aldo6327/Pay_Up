//
//  HistoryTVCell.swift
//  PayUp
//
//  Created by Aldo Ayala on 11/21/17.
//  Copyright © 2017 Aldo Ayala. All rights reserved.
//

import UIKit

class HistoryTVCell: UITableViewCell {

    @IBOutlet weak var createdBy: UILabel!
    @IBOutlet weak var finalAmount: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var titleOfTransaction: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
