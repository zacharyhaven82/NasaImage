//
//  UIActivityIndicatorView.swift
//  NasaImage
//
//  Created by Zachary Haven on 5/30/19.
//  Copyright © 2019 Zachary Haven. All rights reserved.
//

import UIKit

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
