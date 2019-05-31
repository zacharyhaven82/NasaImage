//
//  NICloudKitService.swift
//  NasaImage
//
//  Created by Zachary Haven on 5/31/19.
//  Copyright © 2019 Zachary Haven. All rights reserved.
//

import Foundation
import CloudKit

class NICloudKitService {
	let database = CKContainer.default().publicCloudDatabase
	var records = [CKRecord]()
	var insertedObjects = [Likes]()
	var deletedObjectIds = Set<CKRecord.ID>()
	var likes = [Likes]() {
		didSet {
			self.notificationQueue.addOperation {
				self.onChange?()
			}
		}
	}
	var onChange: (() -> Void)?
	var onError: ((Error) -> Void)?
	var notificationQueue = OperationQueue.main
	private func handle(error: Error) {
		self.notificationQueue.addOperation {
			self.onError?(error)
		}
	}
	
	func addLike(dateLiked: String) {
		var like = Likes()
		like.dateLiked = dateLiked
		database.save(like.record) { _, error in
			guard error == nil else {
				self.handle(error: error!)
				return
			}
		}
		insertedObjects.append(like)
		updateLikes()
	}
//	func delete(at index: Int) {
//		let recordId = self.errands[index].record.recordID
//		database.delete(withRecordID: recordId) { _, error in
//			guard error == nil else {
//				self.handle(error: error!)
//				return
//			}
//		}
//	deletedObjectIds.insert(recordId)
//	updateErrands()
//	}
	
	func getTop20Likes(success: @escaping ([Likes]) -> Void, failure: @escaping () -> Void) {
		let predicate = NSPredicate()
		let query = CKQuery(recordType: Likes.recordType, predicate: predicate)
		database.perform(query, inZoneWith: nil) { (records, error) in
			
		}
	}
	
	private func updateLikes() {
		var knownIds = Set(records.map { $0.recordID })
		// remove objects from our local list once we see them returned from the cloudkit storage
		insertedObjects.removeAll { likes in
			knownIds.contains(likes.record.recordID)
		}
		knownIds.formUnion(insertedObjects.map { $0.record.recordID })
		// remove objects from our local list once we see them not being returned from storage anymore
		self.deletedObjectIds.formIntersection(knownIds)
		var theLikes = records.map { record in Likes(record: record) }
		theLikes.append(contentsOf: insertedObjects)
		theLikes.removeAll { like in
			deletedObjectIds.contains(like.record.recordID)
		}
		
		likes = theLikes
		debugPrint("Tracking local objects \(insertedObjects) \(deletedObjectIds)")
	}
	
	func refresh() {
		let query = CKQuery(recordType: Likes.recordType, predicate: NSPredicate(value: true))
		database.perform(query, inZoneWith: nil) { records, error in
			guard let records = records, error == nil else {
				self.handle(error: error!)
				return
			}
			self.records = records
			self.updateLikes()
		}
	}
}

struct Likes {
	fileprivate static let recordType = "Likes"
	var record: CKRecord
	init(record: CKRecord) {
		self.record = record
	}
	init() {
		record = CKRecord(recordType: Likes.recordType)
	}
	var dateLiked: String {
		get {
			guard let value = record.value(forKey: "dateLiked") as? String else { return "" }
			return value
		}
		set {
			record.setValue(newValue, forKey: "dateLiked")
		}
	}
}
