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
		if let currentUser = NILoginService.shared.currentUser {
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
		if let _ = NILoginService.shared.currentUser {
			NILoginService.logOut()
		} else {
			performSegue(withIdentifier: "loginFromSettingsSegue", sender: self)
		}
	}
}
