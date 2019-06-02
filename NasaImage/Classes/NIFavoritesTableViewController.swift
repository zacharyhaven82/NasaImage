//
//  NIFavoritesTableViewController.swift
//  Nasa Image
//
//  Created by Zachary Haven on 6/1/19.
//  Copyright © 2019 Zachary Haven. All rights reserved.
//

import UIKit

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
		
//		NIRealTimeDatabase.getTopLikes(success: {[weak self] (topLikes) in
//			self?.topLikes = topLikes
//		}, failure: { (error) in
//			// TODO: Deal with error
//		})
//		
//		if let currentUser = NILoginService.getCurrentUser() {
//			NIRealTimeDatabase.getUserLikes(user: currentUser, success: {[weak self] (userLikes) in
//				self?.userLikes = userLikes
//			}, failure: { (error) in
//				// TODO: Deal with error
//			})
//		}
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		NIRealTimeDatabase.getTopLikes(success: {[weak self] (topLikes) in
			self?.topLikes = topLikes
			}, failure: {
				// TODO: Deal with error
		})
		
		if let currentUser = NILoginService.getCurrentUser() {
			NIRealTimeDatabase.getUserLikes(user: currentUser, success: {[weak self] (userLikes) in
				self?.userLikes = userLikes
				}, failure: {
					// TODO: Deal with error
			})
		}
	}

    // MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let view = tableView.dequeueReusableCell(withIdentifier: "segmentedControlCell")
			as? NISegmentedControlTableViewCell
			else { return nil }
		if NILoginService.getCurrentUser() == nil {
			view.segmentedControl.setEnabled(false, forSegmentAt: 1)
		} else {
			view.segmentedControl.setEnabled(true, forSegmentAt: 1)
		}
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
		return showingTopLikes ? topLikes.count : userLikes.count
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "default")
		cell.backgroundColor = .black
		cell.tintColor = .white
		
		cell.textLabel?.text = (showingTopLikes ?
			"\(indexPath.row + 1)) " + topLikes.sorted(by: { $0.value > $1.value })[indexPath.row].key
			: userLikes[indexPath.row])
		cell.textLabel?.textColor = .white
		cell.selectionStyle = .none
        return cell
	}
	
	@IBAction func segmentedControlValueChanged(_ sender: Any) {
		guard let segmentedControl = sender as? UISegmentedControl else { return }
		showingTopLikes = segmentedControl.selectedSegmentIndex == 0
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
