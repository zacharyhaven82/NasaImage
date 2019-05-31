//
//  NIReviewHelper.swift
//  Nasa Image
//
//  Created by Zachary Haven on 5/31/19.
//  Copyright © 2019 Zachary Haven. All rights reserved.
//

import Foundation
import StoreKit

struct NIReviewHelper {
	
	static let countKey = "APP_OPENED_COUNT"
	
	static func incrementAppOpenedCount() { // called from appdelegate didfinishLaunchingWithOptions:
		guard var appOpenCount = UserDefaults.standard.value(forKey: NIReviewHelper.countKey) as? Int else {
			UserDefaults.standard.set(1, forKey: NIReviewHelper.countKey)
			return
		}
		appOpenCount += 1
		UserDefaults.standard.set(appOpenCount, forKey: NIReviewHelper.countKey)
	}
	
	static func checkAndAskForReview() { // call this whenever appropriate
		// this will not be shown everytime. Apple has some internal logic on how to show this.
		guard let appOpenCount = UserDefaults.standard.value(forKey: NIReviewHelper.countKey) as? Int else {
			UserDefaults.standard.set(1, forKey: NIReviewHelper.countKey)
			return
		}
		
		switch appOpenCount {
		case 5,10,25:
			NIReviewHelper().requestReview()
		case _ where appOpenCount%100 == 0 :
			NIReviewHelper().requestReview()
		default:
			print("App run count is : \(appOpenCount)")
		}
		
	}
	
	fileprivate func requestReview() {
		if #available(iOS 10.3, *) {
			SKStoreReviewController.requestReview()
		} else {
			// Do nothing.
		}
	}
}
