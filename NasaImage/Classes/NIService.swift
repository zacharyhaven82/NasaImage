//
//  NasaImageService.swift
//  NasaImage
//
//  Created by Zachary Haven on 5/30/19.
//  Copyright © 2019 Zachary Haven. All rights reserved.
//

import Foundation
import Alamofire
import FirebaseAuth
import SwiftyJSON

struct NasaImageService {
	
	private static let nasaURL = "https://api.nasa.gov/planetary/apod"
	private static let apiKey = "api_key=BBHc4u9eVEI5L9VPbbBbxRo9yfRezAFMNXsbB4G5"
	
	static func callService(with date: Date,
							success: @escaping (Any) -> Void,
							failure: @escaping (String) -> Void) {
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

class NILoginService {
	
	static let shared = NILoginService()
	
	enum LoginResult {
		case loginSuccess(user: Any)
		case needsAuth
		case loginFailure(error: Error)
	}
	
	var loggedIn = false
	var currentUser = Auth.auth().currentUser
	
	static func login(with email: String,
					  _ password: String,
					  success: @escaping (AuthDataResult) -> Void,
					  failure: @escaping (Error?) -> Void) {
		Auth.auth().signIn(withEmail: email, password: password) { user, error in
			if let userObject = user {
				success(userObject)
			} else {
				failure(error)
			}
		}
	}
	
	static func logOut() {
		do {
			try Auth.auth().signOut()
		} catch let error {
			print(error)
			// Do something here?
		}
	}
	
	static func resetPassword() {
		// Implement
	}
	
	static func createUser(with email: String,
						   _ password: String,
						   success: @escaping (AuthDataResult) -> Void,
						   failure: @escaping (Error?) -> Void) {
		Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
			if let auth = authResult {
				success(auth)
			} else {
				failure(error)
			}
		}
	}
}
