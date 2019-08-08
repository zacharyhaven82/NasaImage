//
//  NIImageViewTableViewCell.swift
//  Nasa Image
//
//  Created by Zachary Haven on 6/2/19.
//  Copyright © 2019 Zachary Haven. All rights reserved.
//

import UIKit
import SwiftyJSON
import WebKit

class NIImageViewTableViewCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var webView: WKWebView!
	
	var videoURL: URL? {
		didSet {
			guard let url = videoURL else { return }
			webView.load(URLRequest(url: url))
		}
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
		backgroundColor = .black
		tintColor = .white
		videoURL = nil
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func setupCell(date: String, count: Int, isTop20: Bool) {
		self.titleLabel.text = (isTop20 ? "\(count)) " + date : date)
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		guard let actualDate = dateFormatter.date(from: date) else { return }
		
		NasaImageService.callService(with: actualDate, success: {[weak self] value in
			let json = JSON(value)
			print("JSON: \(json)")
			guard let self = self else { return }
			if json["media_type"].string == "image",
				let hdURL = json["url"].string,
				let url = URL(string: hdURL) {
				self.videoURL = url
			} else if json["media_type"].string == "video",
				let hdURL = json["url"].string,
				let url = URL(string: hdURL) {
				self.videoURL = url
			}
			}, failure: { error in
				print(error)
		})
	}

}
