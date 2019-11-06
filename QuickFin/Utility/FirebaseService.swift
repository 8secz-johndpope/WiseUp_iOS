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
    
    func logOut() {
        try? Auth.auth().signOut()
    }
    
    func verifyUser(email: String) {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Error getting uid")
            return
        }
        
        guard let displayName = Auth.auth().currentUser?.displayName else {
            print("Error getting display name")
            return
        }
        
        db.collection(users).document(uid).getDocument { (snapshot, error) in
            
            if let error = error {
                print(error)
                return
            } else {
                
                if (!snapshot!.exists) {
                    
                    User.shared = User(admin: false, email: email, uid: String(uid), displayName: displayName)
                    let serializedUser = try! FirestoreEncoder().encode(User.shared)
                    
                    self.db.collection(self.users).document(uid).setData(serializedUser) { (error) in
                        return
                    }
                } else {
                    
                    User.shared = try! FirebaseDecoder().decode(User.self, from: snapshot!.data()!)
                    return
                    
                }
                
            }
        }
    }
    
    func pushUserToFirebase() {
        
        let uid = Auth.auth().currentUser?.uid
        
        let serializedUser = try! FirestoreEncoder().encode(User.shared)
        
        self.db.collection(users).document(uid!).setData(serializedUser) { (error) in
            if let error = error {
                print("Error saving user: \(error)")
            } else {
                print("User saved written!")
            }
        }
        
    }
    
    func retrieveUser(completion: @escaping (User?) -> Void) {
        
        let uid = Auth.auth().currentUser?.uid
        
        db.collection(users).document(uid!).getDocument { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting User: \(err)")
                completion(nil)
                return
            }
            
            if let querySnapshot = querySnapshot {
                User.shared = try! FirebaseDecoder().decode(User.self, from: querySnapshot.data()!)
                completion(User.shared)
                return
            }
            
            completion(nil)
            return
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
