//
//  NIRealTimeDatabase.swift
//  NasaImage
//
//  Created by Zachary Haven on 5/31/19.
//  Copyright © 2019 Zachary Haven. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

struct NIRealTimeDatabase {
	
	static var ref = Database.database().reference()
	static var likesTable = Database.database().reference().child("likes")
	
	static func saveLike(dateString: String,
						 user: User,
						 success: @escaping () -> Void,
						 failure: @escaping (Error) -> Void) {
		let key = likesTable.childByAutoId().key ?? ""
		let like = ["dateString": dateString,
					"userId": user.uid]
		
		likesTable.child(key).setValue(like) { (error, _) in
			if let errorObj = error {
				failure(errorObj)
			} else {
				success()
			}
		}
		
	}
	
	static func getLike(for dateString: String,
						user: User,
						success: @escaping (Bool) -> Void,
						failure: @escaping (Error) -> Void) {
		likesTable.observeSingleEvent(of: .value, with: { snapshot in
			if let result = snapshot.children.allObjects as? [DataSnapshot] {
				print(result)
				for child in result {
						
					if let userId = child.childSnapshot(forPath: "userId").value as? String,
						userId == user.uid,
						let dateLiked = child.childSnapshot(forPath: "dateString").value as? String,
						dateLiked == dateString {
						success(true)
					} else {
						success(false)
					}
				}
			}
		})
	}
	
	static func deleteLike(dateString: String,
						   user: User,
						   success: @escaping () -> Void,
						   failure: @escaping (Error) -> Void) {
		likesTable.observeSingleEvent(of: .value, with: { snapshot in
			if let result = snapshot.children.allObjects as? [DataSnapshot] {
				print(result)
				for child in result {
					
					if let userId = child.childSnapshot(forPath: "userId").value as? String,
						userId == user.uid,
						let dateLiked = child.childSnapshot(forPath: "dateString").value as? String,
						dateLiked == dateString {
						likesTable.child(child.key).setValue(nil)
					}
				}
			}
		})
	}
	
	static func getTopLikes(success: @escaping ([String]) -> Void,
							failure: @escaping (Error) -> Void) {
		
	}
	
	static func getUserLikes(user: User,
							 success: @escaping ([String]) -> Void,
							 failure: @escaping (Error) -> Void) {
		
	}
}
