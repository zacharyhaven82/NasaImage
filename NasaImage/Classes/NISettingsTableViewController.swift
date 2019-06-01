//
//  NISettingsTableViewController.swift
//  NasaImage
//
//  Created by Zachary Haven on 5/29/19.
//  Copyright © 2019 Zachary Haven. All rights reserved.
//

import UIKit

class NISettingsTableViewController: UITableViewController {

	@IBOutlet weak var loginLogoutButton: UIBarButtonItem!
	private let logoutTitle = "Logout"
	private let loginTitle = "Login"
	
	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.tableFooterView = UIView()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setUserDetails()
	}
	
	private func setUserDetails() {
		if let currentUser = NILoginService.getCurrentUser() {
			print(currentUser)
			loginLogoutButton.title = logoutTitle
		} else {
			loginLogoutButton.title = loginTitle
		}
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
		
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
        return 1
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell",
													for: indexPath) as? NISwitchTableViewCell {
			cell.titleLabel?.text = "Download HD Photos"
			return cell
		}

        return UITableViewCell()
    }

	@IBAction func loginLogoutAction(_ sender: Any) {
		if NILoginService.getCurrentUser() != nil {
			switch NILoginService.logOut() {
			case .success(let value):
				print(value)
				setUserDetails()
			case .failure(let error):
				presentErrorAlert(error.localizedDescription)
			}
		} else {
			performSegue(withIdentifier: "loginFromSettingsSegue", sender: self)
		}
	}
}
