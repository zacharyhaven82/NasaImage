//
//  NasaImageViewController.swift
//  NasaImage
//
//  Created by Zachary Haven on 5/22/19.
//  Copyright © 2019 Zachary Haven. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import WebKit

class NasaImageViewController: UIViewController {
	
	let nasaURL = "https://api.nasa.gov/planetary/apod"
	let apiKey = "api_key=BBHc4u9eVEI5L9VPbbBbxRo9yfRezAFMNXsbB4G5"

	@IBOutlet weak var dateButton: UIBarButtonItem!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var detailTextView: UITextView!
	@IBOutlet weak var doneButton: UIButton!
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var datePickerView: UIView!
	@IBOutlet weak var activity: UIActivityIndicatorView!
	@IBOutlet weak var webView: WKWebView!
	
	var image: UIImage? {
		didSet {
			imageView.image = image
			imageView.isHidden = false
			webView.isHidden = true
			activity.stop()
			setTitleAndDetail()
		}
	}
	var videoURL: URL?
	var json: JSON?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		title = ""
		detailTextView.isHidden = true
		datePickerView.isHidden = true
		webView.isHidden = true
		imageView.isHidden = true
		datePicker.maximumDate = Date()
		datePicker.setValue(UIColor.white, forKeyPath: "textColor")
		callService(with: datePicker.date)
		dateButton.title = datePicker.date.toString(with: "MM-dd-yyyy")
		let aspectTap = UITapGestureRecognizer(target: self, action: #selector(toggleAspect))
		aspectTap.numberOfTapsRequired = 2
		view.addGestureRecognizer(aspectTap)
    }
	
	@IBAction func dateButtonAction(_ sender: Any) {
		title = ""
		detailTextView.isHidden = true
		datePickerView.isHidden = false
	}
	
	@IBAction func doneButtonAction(_ sender: Any) {
		dateButton.title = datePicker.date.toString(with: "MM-dd-yyyy")
		datePickerView.isHidden = true
		callService(with: datePicker.date)
	}
	
	@IBAction func toggleDetail() {
		if datePickerView.isHidden {
			detailTextView.isHidden = !detailTextView.isHidden
		}
	}
	
	@IBAction func toggleAspect() {
		imageView.contentMode = imageView.contentMode == .scaleAspectFit ? .scaleAspectFill : .scaleAspectFit
	}
	
	@IBAction func shareImage(_ sender: Any) {
		let activityViewController = UIActivityViewController(activityItems: [image ?? videoURL], applicationActivities: nil)
		present(activityViewController, animated: true, completion: nil)
	}
	
	@IBAction func retryService(_ sender: Any) {
		callService(with: datePicker.date)
	}
	
	private func callService(with date: Date) {
		activity.start()
		
		let fullURL = nasaURL + "?" +  apiKey + "&date=" + date.toString(with: "yyyy-MM-dd")
		Alamofire.request(fullURL).responseJSON {[weak self] response in
			debugPrint(response)
			
			switch response.result {
			case .success(let value):
				let json = JSON(value)
				print("JSON: \(json)")
				guard let self = self else { return }
				if let errorMsg = json["msg"].string {
					self.activity.stop()
					self.presentErrorAlert(errorMsg)
					return
				}
				self.json = json
				if let hdURL = json["hdurl"].string,
					let url = URL(string: hdURL) {
					self.mediaIsImage(url: url)
				} else if json["media_type"].string == "video",
					let hdURL = json["url"].string,
					let url = URL(string: hdURL) {
					self.mediaIsVideo(url: url)
				}
			case .failure(let error):
				self?.activity.stop()
				self?.presentErrorAlert(error.localizedDescription)
				print(error)
			}
		}
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
		webView.load(URLRequest(url: url))
		webView.isHidden = false
		imageView.isHidden = true
		activity.stop()
		setTitleAndDetail()
	}
	
	func setTitleAndDetail() {
		detailTextView.isHidden = false
		detailTextView.text = json?["explanation"].string
		title = json?["title"].string
	}
}

extension UIActivityIndicatorView {
	
	func start() {
		self.startAnimating()
		self.isHidden = false
	}
	
	func stop() {
		self.stopAnimating()
		self.isHidden = true
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

extension Date {
	
	func toString(with format: String) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format
		return dateFormatter.string(from: self)
	}
}
