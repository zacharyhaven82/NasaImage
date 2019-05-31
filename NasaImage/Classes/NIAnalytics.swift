//
//  NIAnalytics.swift
//  NasaImage
//
//  Created by Zachary Haven on 5/31/19.
//  Copyright © 2019 Zachary Haven. All rights reserved.
//

import Foundation
import FirebaseAnalytics

struct NIAnalytics {
	
	enum Events: String {
		case previousDaySwipe
		case nextDaySwipe
		case dateButtonTap
		case doneButtonTap
		case toggleAspect
		case shareTap
		case liked
		case errorPresented
		case unknown
	}
	
	static func logEvent(event: Events = .unknown, parameters: [String:Any]? = nil) {
		Analytics.logEvent(event.rawValue, parameters: parameters)
	}
}
