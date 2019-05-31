//
//  NILoginViewController.swift
//  Nasa Image
//
//  Created by Zachary Haven on 5/31/19.
//  Copyright © 2019 Zachary Haven. All rights reserved.
//

import UIKit

class NILoginViewController: UIViewController {

	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	@IBAction func cancelAction(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func loginAction(_ sender: Any) {
		guard let email = emailTextField.text,
			let password = passwordTextField.text else { presentErrorAlert("Email and Password are required"); return }
		NILoginService.login(with: email, password, success: {[weak self] authResult in
			print(authResult)// display success
			NILoginService.shared.loggedIn = true
			self?.dismiss(animated: true, completion: nil)
		}, failure: {[weak self] error in
			NILoginService.shared.loggedIn = false
			if let nsError = error as NSError?, nsError.code == 17011 {
				NILoginService.createUser(with: email, password, success: {[weak self] result in
					print(result)// display success
					NILoginService.shared.loggedIn = true
					self?.dismiss(animated: true, completion: nil)
				}, failure: {[weak self] error in
					if let errorObject = error {
						self?.presentErrorAlert(errorObject.localizedDescription)
					}
					self?.dismiss(animated: true, completion: nil)
				})
			} else if let errorObject = error {
				guard let self = self else { return }
				self.presentErrorAlert(errorObject.localizedDescription)
			}
		})
	}
	
}
