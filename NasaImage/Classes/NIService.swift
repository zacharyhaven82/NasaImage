//
//  NasaImageService.swift
//  NasaImage
//
//  Created by Zachary Haven on 5/30/19.
//  Copyright © 2019 Zachary Haven. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NasaImageService {
	
	private let nasaURL = "https://api.nasa.gov/planetary/apod"
	private let apiKey = "api_key=BBHc4u9eVEI5L9VPbbBbxRo9yfRezAFMNXsbB4G5"
	
	func callService(with date: Date, success: @escaping (Any) -> Void, failure: @escaping (String) -> Void) {
		let fullURL = nasaURL + "?" +  apiKey + "&date=" + date.toString(with: "yyyy-MM-dd")
		Alamofire.request(fullURL).responseJSON { response in
			debugPrint(response)
			switch response.result {
			case .success(let value):
				success(value)
			case .failure(let error):
				failure(error.localizedDescription)
				print(error)
			}
		}
	}
}
