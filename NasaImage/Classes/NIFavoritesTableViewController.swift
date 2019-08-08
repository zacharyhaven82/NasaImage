//
//  NIFavoritesTableViewController.swift
//  Nasa Image
//
//  Created by Zachary Haven on 6/1/19.
//  Copyright © 2019 Zachary Haven. All rights reserved.
//

import UIKit
import SwiftyJSON

class NIFavoritesTableViewController: UITableViewController {

	var topLikes = [String: Int]() {
		didSet {
			tableView.reloadData()
		}
	}
	var userLikes = [String]() {
		didSet {
			tableView.reloadData()
		}
	}
	var showingTopLikes = true {
		didSet {
			tableView.reloadData()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.tableFooterView = UIView()
		tableView.rowHeight = UITableView.automaticDimension
		NIRealTimeDatabase.getTopLikes(success: {[weak self] (topLikes) in
			self?.topLikes = topLikes
			}, failure: {
				
		})
		
		if let currentUser = NILoginService.getCurrentUser() {
			NIRealTimeDatabase.getUserLikes(user: currentUser, success: {[weak self] (userLikes) in
				self?.userLikes = userLikes
				}, failure: {
					
			})
		}
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}

    // MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let view = tableView.dequeueReusableCell(withIdentifier: "segmentedControlCell")
			as? NISegmentedControlTableViewCell
			else { return nil }
		view.segmentedControl.selectedSegmentIndex = showingTopLikes ? 0 : 1
		view.segmentedControl.addTarget(self,
										action: #selector(segmentedControlValueChanged(_:)),
										for: .valueChanged)
		return view
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 45
	}

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return showingTopLikes ? topLikes.count < 20 ? topLikes.count : 20 : userLikes.count
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "webViewCell")
			as? NIImageViewTableViewCell else { return UITableViewCell() }
		cell.setupCell(date: showingTopLikes ?
			topLikes.sorted(by: { $0.value > $1.value })[indexPath.row].key :
			userLikes[indexPath.row],
					   count: indexPath.row + 1,
					   isTop20: showingTopLikes)
		cell.selectionStyle = .none
        return cell
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}
	
	@IBAction func segmentedControlValueChanged(_ sender: Any) {
		guard let segmentedControl = sender as? UISegmentedControl else { return }
		if NILoginService.getCurrentUser() != nil {
			showingTopLikes = segmentedControl.selectedSegmentIndex == 0
			tableView.reloadData()
		} else {
			performSegue(withIdentifier: "loginFromFavoritesSegue", sender: self)
			NotificationCenter.default.addObserver(self, selector: #selector(reloadUserLikes), name: .loginSuccess, object: nil)
		}
	}
	
	@objc func reloadUserLikes() {
		if let currentUser = NILoginService.getCurrentUser() {
			NIRealTimeDatabase.getUserLikes(user: currentUser, success: {[weak self] (userLikes) in
				self?.userLikes = userLikes
				self?.tableView.reloadData()
				}, failure: {
					
			})
		}
	}
}
