//
//  ExtensionViewController.swift
//  NasaImage-Extension
//
//  Created by Zachary Haven on 5/30/19.
//  Copyright © 2019 Zachary Haven. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON
import NotificationCenter

class ExtensionViewController: UIViewController, NCWidgetProviding {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var webView: WKWebView!
	@IBOutlet weak var activity: UIActivityIndicatorView!
	@IBOutlet weak var errorLabel: UILabel!
	
	var image: UIImage? {
		didSet {
			if image == nil {
				webView.isHidden = false
				imageView.isHidden = true
			} else {
				imageView.image = image
				imageView.isHidden = false
				webView.isHidden = true
			}
		}
	}
	
	var videoURL: URL? {
		didSet {
			if videoURL == nil {
				webView.isHidden = true
				imageView.isHidden = false
			} else {
				guard let url = videoURL else { return }
				webView.load(URLRequest(url: url))
			}
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		imageView.isHidden = true
		webView.isHidden = true
		activity.start()
		errorLabel.isHidden = true
		extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		NasaImageService().callService(with: Date(), success: {[weak self] value in
			let json = JSON(value)
			print("JSON: \(json)")
			guard let self = self else { return }
			self.activity.stop()
			if let errorMsg = json["msg"].string {
				self.displayError(error: errorMsg)
				return
			}
			if json["media_type"].string == "image",
				let regUrl = json["url"].string,
				let url = URL(string: regUrl) {
				self.mediaIsImage(url: url)
			} else if json["media_type"].string == "video",
				let hdURL = json["url"].string,
				let url = URL(string: hdURL) {
				self.mediaIsVideo(url: url)
			} else {
				self.displayError(error: "Image not available")
			}
			}, failure: {[weak self] error in
				guard let self = self else { return }
				self.displayError(error: error)
		})
	}
	
	func mediaIsImage(url: URL) {
		if let data = try? Data(contentsOf: url),
			let anImage = UIImage(data: data) {
			image = anImage
			videoURL = nil
		}
	}
	
	func mediaIsVideo(url: URL) {
		image = nil
		videoURL = url
	}
	
	func displayError(error: String) {
		errorLabel.text = error
		errorLabel.isHidden = false
	}
	
	func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode,
										  withMaximumSize maxSize: CGSize) {
		let expanded = activeDisplayMode == .expanded
		preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 400) : maxSize
	}

}
