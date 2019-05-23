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
	
	var image: UIImage? {
		didSet {
			guard let realJson = json else { return }
			imageView.image = image
			detailTextView.isHidden = false
			detailTextView.text = realJson["explanation"].stringValue
			title = realJson["title"].string
			activity.stop()
		}
	}
	var json: JSON?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		title = ""
		detailTextView.isHidden = true
		datePickerView.isHidden = true
		
		callService(with: datePicker.date)
		dateButton.title = datePicker.date.toString(with: "MM-dd-yyyy")
		let detailTap = UITapGestureRecognizer(target: self, action: #selector(toggleDetail))
		detailTap.numberOfTapsRequired = 1
		view.addGestureRecognizer(detailTap)
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
		detailTextView.isHidden = !detailTextView.isHidden
	}
	
	@IBAction func toggleAspect() {
		imageView.contentMode = imageView.contentMode == .scaleAspectFit ? .scaleAspectFill : .scaleAspectFit
	}
	
	@IBAction func shareImage(_ sender: Any) {
		guard let realImage = image else { return }
		let activityViewController = UIActivityViewController(activityItems: [realImage], applicationActivities: nil)
		present(activityViewController, animated: true, completion: nil)
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
				self.json = json
				if let url = URL(string: json["hdurl"].stringValue), let data = try? Data(contentsOf: url) {
					self.image = UIImage(data: data)
				}
			case .failure(let error):
				self?.activity.stop()
				self?.presentErrorAlert(error)
				print(error)
			}
		}
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
	
	func presentErrorAlert(_ error: Error) {
		let viewController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .default, handler: nil)
		viewController.addAction(action)
		self.present(viewController, animated: true, completion: nil)
	}
}

extension Date {
	
	func toString(with format: String) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format
		return dateFormatter.string(from: self)
	}
}
