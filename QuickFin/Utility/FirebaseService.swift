//
//  FirebaseService.swift
//  QuickFin
//
//  Created by Boyuan Xu on 9/19/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import Firebase
import CodableFirebase

enum FirebaseError: Error {
    // E_SDNE: Snapshot does not exist
    case snapshotError(String)
}

class FirebaseService {
    
    static var shared = FirebaseService()
    private init() {}
    
    let db = Firestore.firestore()
    let users = "users"
    let storage = Storage.storage()
    
    func logOut() {
        try? Auth.auth().signOut()
    }
    
}

// MARK: - Firebase Firestore
extension FirebaseService {
    
    func readUser(completion: @escaping (FirestoreUserResponse?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        db.collection(users).document(uid).getDocument { (snapshot, error) in
            if let error = error {
                completion(FirestoreUserResponse(error: error))
                return
            }
            if let snapshot = snapshot {
                let user = try! FirebaseDecoder().decode(User.self, from: snapshot.data()!)
                completion(FirestoreUserResponse(user: user))
                return
            }
            completion(FirestoreUserResponse(error: FirebaseError.snapshotError("E_SDNE")))
            return
        }
    }
    
    func saveUser(user: User, completion: @escaping (Error?) -> Void) {
        // Using forced try here since as long as the object conforms to Codable, nothing should go wrong.
        let serializedUser = try! FirestoreEncoder().encode(user)
        db.document(users).setData(serializedUser) { (error) in
            completion(error)
        }
    }
    
    func loadChapters(completion: @escaping ([Chapter], ChapterStats?) -> Void) {
        var chaps = [Chapter]()
        db.collection("chapters").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting chapters: \(err)")
                completion([], nil)
                return
            } else {
                
                var timestamp: ChapterStats = ChapterStats()
                
                for chapter in querySnapshot!.documents {
                    if (chapter.documentID == "--stats--") {
                        timestamp = try! FirebaseDecoder().decode(ChapterStats.self, from: chapter.data())
                    } else {
                        
                        if (chapter.data().count == 5) {
                            
                            let chap = try! FirebaseDecoder().decode(Chapter.self, from: chapter.data())
                            
                            if (chap.active) {
                                chaps.append(chap)
                            }
                            
                        }
                        
                    }
                }
                
                completion(chaps, timestamp)
                return
            }
        }
    }
    
    func getChapterTimestamp(completion: @escaping (ChapterStats?) -> Void) {
        
        db.collection("chapters").document("--stats--").getDocument { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting chapters: \(err)")
                completion(nil)
                return
            }
            
            if let querySnapshot = querySnapshot {
                let timestamp = try! FirebaseDecoder().decode(ChapterStats.self, from: querySnapshot.data()!)
                completion(timestamp)
                return
            }
            
            completion(nil)
            return
        }
    }
}

// MARK: - Firebase Storage
extension FirebaseService {
    
    func getImage(URL: String) -> UIImage {
        #warning("TODO: Work with backend folks and implement storage")
        return "?".emojiToImage()!
    }
    
}
