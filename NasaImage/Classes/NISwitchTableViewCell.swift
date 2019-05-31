//
//  NISwitchTableViewCell.swift
//  NasaImage
//
//  Created by Zachary Haven on 5/29/19.
//  Copyright © 2019 Zachary Haven. All rights reserved.
//

import UIKit

class NISwitchTableViewCell: UITableViewCell {
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var theSwitch: UISwitch!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	@IBAction func switchAction(_ sender: Any) {
		guard let aSwitch = sender as? UISwitch else { return }
		UserDefaults.standard.set(aSwitch.isOn, forKey: "downloadHDPhotos")
		UserDefaults.standard.synchronize()
	}
}
