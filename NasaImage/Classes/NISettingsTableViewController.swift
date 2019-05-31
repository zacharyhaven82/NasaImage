//
//  NISettingsTableViewController.swift
//  NasaImage
//
//  Created by Zachary Haven on 5/29/19.
//  Copyright © 2019 Zachary Haven. All rights reserved.
//

import UIKit

class NISettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.tableFooterView = UIView()
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

}
