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
    
    func verifyUser(email: String, completion: @escaping (Error?) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Error getting uid")
            return
        }
        
        let displayName = Auth.auth().currentUser?.displayName
        
        db.collection(users).document(uid).getDocument { (snapshot, error) in
            
            if let error = error {
                print(error)
                completion(error)
            } else {
                
                if (!snapshot!.exists) {
                    
                    UserShared.shared = UserShared(admin: false, email: email, uid: String(uid), displayName: displayName ?? "")
                    let serializedUser = try! FirestoreEncoder().encode(UserShared.shared)
                    
                    self.db.collection(self.users).document(uid).setData(serializedUser) { (error) in
                        completion(nil)
                    }
                } else {
                    
                    UserShared.shared = try! FirebaseDecoder().decode(UserShared.self, from: snapshot!.data()!)
                    completion(nil)
                    
                }
                
            }
        }
    }
    
    func pushUserToFirebase() {
        
        let uid = Auth.auth().currentUser?.uid
        
        let serializedUser = try! FirestoreEncoder().encode(UserShared.shared)
        
        self.db.collection(users).document(uid!).setData(serializedUser) { (error) in
            if let error = error {
                print("Error saving user: \(error)")
            } else {
                print("User saved written!")
            }
        }
        
    }
    
    func retrieveUser(completion: @escaping (UserShared?) -> Void) {
        
        let uid = Auth.auth().currentUser?.uid
        
        db.collection(users).document(uid!).getDocument { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting User: \(err)")
                completion(nil)
                return
            }
            
            if let querySnapshot = querySnapshot {
                UserShared.shared = try! FirebaseDecoder().decode(UserShared.self, from: querySnapshot.data()!)
                completion(UserShared.shared)
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
    
    func loadStore(completion: @escaping ([StoreItem], ChapterStats?) -> Void) {
        
        var store = [StoreItem]()
        
        db.collection("store").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting chapters: \(err)")
                completion([], nil)
                return
            } else {
                
                var timestamp: ChapterStats = ChapterStats()
                
                for doc in querySnapshot!.documents {
                    
                    if (doc.documentID == "--stats--") {
                        timestamp = try! FirebaseDecoder().decode(ChapterStats.self, from: doc.data())
                    } else {
                        let store2 = try! FirebaseDecoder().decode(Store.self, from: doc.data())
                        store = store2.items
                    }
                }
                
                completion(store, timestamp)
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
    
    func getUserData(completion: @escaping ([User]) -> Void) {
        var userArray = [User]()
        db.collection("users").order(by: "achievementCount", descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let deserializedUser = try! FirebaseDecoder().decode(User.self,from: document.data())
                    userArray.append(deserializedUser)
                }
                
                completion(userArray)
                return

            }
        }
    }
    
    func getStoreTimestamp(completion: @escaping (ChapterStats?) -> Void) {
        
        db.collection("store").document("--stats--").getDocument { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting store: \(err)")
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
        return UIImage(named: URL)!
    }
    
}
