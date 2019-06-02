//
//  NISegmentedControlTableViewCell.swift
//  Nasa Image
//
//  Created by Zachary Haven on 6/1/19.
//  Copyright © 2019 Zachary Haven. All rights reserved.
//

import UIKit

class NISegmentedControlTableViewCell: UITableViewCell {

	@IBOutlet weak var segmentedControl: UISegmentedControl!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
