//
//  NasaImageViewController.swift
//  NasaImage
//
//  Created by Zachary Haven on 5/22/19.
//  Copyright © 2019 Zachary Haven. All rights reserved.
//

import UIKit
import SwiftyJSON
import WebKit

class NasaImageViewController: UIViewController {

	@IBOutlet weak var dateButton: UIBarButtonItem!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var detailTextView: UITextView!
	@IBOutlet weak var doneButton: UIButton!
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var datePickerView: UIView!
	@IBOutlet weak var activity: UIActivityIndicatorView!
	@IBOutlet weak var webView: WKWebView!
	@IBOutlet weak var likeButton: UIBarButtonItem!
	
	var image: UIImage? {
		didSet {
			if image == nil {
				webView.isHidden = false
				imageView.isHidden = true
			} else {
				imageView.image = image
				imageView.isHidden = false
				webView.isHidden = true
				activity.stop()
				setTitleAndDetail()
			}
		}
	}
	
	var hdImage: UIImage? {
		didSet {
			if hdImage == nil {
				webView.isHidden = false
				imageView.isHidden = true
			} else {
				imageView.image = hdImage
				imageView.isHidden = false
				webView.isHidden = true
				activity.stop()
				setTitleAndDetail()
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
				activity.stop()
				setTitleAndDetail()
			}
		}
	}
	var json: JSON?
	var liked = false {
		didSet {
			likeButton.image = liked ? UIImage(named: "Filled Star") : UIImage(named: "Star")
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		
		likeButton.image = UIImage(named: "Star")
		datePicker.maximumDate = Date()
		datePicker.setValue(UIColor.white, forKeyPath: "textColor")
		callService(with: datePicker.date)
		setupGestures()
    }
	
	private func setupGestures() {
		let swipeRight = UISwipeGestureRecognizer(target: self,
												 action: #selector(previousDayAction(_:)))
		swipeRight.direction = .right
		view.addGestureRecognizer(swipeRight)
		let swipeLeft = UISwipeGestureRecognizer(target: self,
												  action: #selector(nextDayAction(_:)))
		swipeLeft.direction = .left
		view.addGestureRecognizer(swipeLeft)
		let aspectTap = UITapGestureRecognizer(target: self,
											   action: #selector(toggleAspect))
		aspectTap.numberOfTapsRequired = 2
		view.addGestureRecognizer(aspectTap)
	}
	
	@IBAction func previousDayAction(_ sender: Any) {
		datePicker.date = datePicker.date.addingTimeInterval(-1*24*60*60)
		callService(with: datePicker.date)
	}
	
	@IBAction func nextDayAction(_ sender: Any) {
		if Calendar(identifier: .gregorian).isDateInToday(datePicker.date) { return }
		datePicker.date = datePicker.date.addingTimeInterval(1*24*60*60)
		callService(with: datePicker.date)
	}
	
	@IBAction func dateButtonAction(_ sender: Any) {
		detailTextView.isHidden = true
		datePickerView.isHidden = false
	}
	
	@IBAction func doneButtonAction(_ sender: Any) {
		callService(with: datePicker.date)
	}
	
	@IBAction func toggleAspect() {
		imageView.contentMode = imageView.contentMode == .scaleAspectFit ? .scaleAspectFill : .scaleAspectFit
	}
	
	@IBAction func shareImage(_ sender: Any) {
		let activityViewController = UIActivityViewController(activityItems: [image ?? (videoURL?.absoluteString ?? "")], applicationActivities: nil)
		present(activityViewController, animated: true, completion: nil)
	}
	
	@IBAction func retryService(_ sender: Any) {
		callService(with: datePicker.date)
	}
	
	@IBAction func likeAction(_ sender: Any) {
		liked = !liked
	}
	
	private func callService(with date: Date) {
		view.hideAllSubviews()
		title = datePicker.date.toString(with: "MM-dd-yyyy")
		navigationItem.title = ""
		activity.start()
		dateButton.title = datePicker.date.toString(with: "MM-dd-yyyy")
		
		NasaImageService().callService(with: date, success: {[weak self] value in
			let json = JSON(value)
			print("JSON: \(json)")
			guard let self = self else { return }
			if let errorMsg = json["msg"].string {
				self.activity.stop()
				self.presentErrorAlert(errorMsg)
				return
			}
			self.json = json
			if json["media_type"].string == "image",
				let regUrl = json["url"].string,
				let url = URL(string: regUrl) {
				UserDefaults.standard.bool(forKey: "downloadHDPhotos")
				self.mediaIsImage(url: url,
								  hdUrl: UserDefaults.standard.bool(forKey: "downloadHDPhotos") ?
									URL(string: json["url"].string ?? "")
									: nil)
			} else if json["media_type"].string == "video",
				let hdURL = json["url"].string,
				let url = URL(string: hdURL) {
				self.mediaIsVideo(url: url)
			} else {
				self.presentErrorAlert("Image not available")
			}
		}, failure: {[weak self] error in
			guard let self = self else { return }
			self.activity.stop()
			self.presentErrorAlert(error)
		})
	}
	
	func mediaIsImage(url: URL, hdUrl: URL?) {
		if let data = try? Data(contentsOf: url),
			let anImage = UIImage(data: data) {
			image = anImage
			videoURL = nil
		}
		if let guaranteedUrl = hdUrl,
			let data = try? Data(contentsOf: guaranteedUrl),
			let anImage = UIImage(data: data) {
			hdImage = anImage
			videoURL = nil
		}
	}
	
	func mediaIsVideo(url: URL) {
		image = nil
		videoURL = url
	}
	
	func setTitleAndDetail() {
		detailTextView.isHidden = false
		detailTextView.text = json?["explanation"].string
		navigationItem.title = json?["title"].string
	}
}

extension UIViewController {
	
	func presentErrorAlert(_ error: String) {
		let viewController = UIAlertController(title: "Error",
											   message: error,
											   preferredStyle: .alert)
		let action = UIAlertAction(title: "OK",
								   style: .default,
								   handler: nil)
		viewController.addAction(action)
		self.present(viewController,
					 animated: true,
					 completion: nil)
	}
}

extension UIView {
	
	func hideAllSubviews() {
		subviews.forEach({ $0.isHidden = true })
	}
}