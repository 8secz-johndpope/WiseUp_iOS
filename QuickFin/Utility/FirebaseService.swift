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
    
    /// Getting all users from Firebase - Deprecated, used for old global leaderboard
    /// - Parameter completion: An array of User objects
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
    
    func getPendingFriendRequest(friendUID: String, completion: @escaping ((Friend?, Error?)) -> Void) {
        db.collection("friends").whereField("uids", arrayContains: friendUID).getDocuments { (snapshot, error) in
            if let error = error {
                completion((nil, error))
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let friend = try! FirebaseDecoder().decode(Friend.self, from: document.data())
                    if friend.uids[1] == UserShared.shared.uid {
                        completion((friend, nil))
                        return
                    }
                }
                completion((nil, nil))
            }
        }
    }
    
    /// Gets all friends of the current user, including pending ones.
    /// - Parameter completion: returns an array of friends (never nil) or an error.
    func getFriends(completion: @escaping (([User]?, Error?)) -> Void) {
        let group = DispatchGroup()
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("friends").whereField("uids", arrayContains: uid).getDocuments { [unowned self] (snapshot, error) in
                if let error = error {
                    completion((nil, error))
                } else {
                    var friendsArray = [User]()
                    for document in snapshot!.documents {
                        let friend = try! FirebaseDecoder().decode(Friend.self, from: document.data())
                        if friend.uids.count == 2 {
                            group.enter()
                            var friendUID = String()
                            if friend.uids[0] == UserShared.shared.uid {
                                friendUID = friend.uids[1]
                            } else {
                                friendUID = friend.uids[0]
                            }
                            self.db.collection("users").document(friendUID).getDocument { (snapshot, error) in
                                if let error = error {
                                    completion((nil, error))
                                } else {
                                    var user = try! FirebaseDecoder().decode(User.self, from: snapshot!.data()!)
                                    if friend.pending {
                                        user.displayName = user.email
                                    }
                                    friendsArray.append(user)
                                }
                                group.leave()
                            }
                        }
                    }
                    group.notify(queue: .main) {
                        completion((friendsArray, nil))
                    }
                }
            }
        }
    }
    
    func removeFriend(friend: User, completion: @escaping (Error?) -> Void) {
        let friendUID = friend.uid
        db.collection("friends").whereField("uids", arrayContains: UserShared.shared.uid).getDocuments { [unowned self] (snapshot, error) in
            if let error = error {
                completion(error)
            } else {
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let friend = try! FirebaseDecoder().decode(Friend.self, from: document.data())
                        if friend.uids.contains(friendUID) {
                            self.db.collection("friends").document(document.documentID).delete()
                            completion(nil)
                            return
                        }
                    }
                    completion(NSError(domain: "", code: 7, userInfo: [NSLocalizedDescriptionKey: Text.FriendListCorrupt]))
                }
            }
        }
    }
    
    func addFriend(email: String, completion: @escaping (Error?) -> Void) {
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { [unowned self] (snapshot, error) in
            if let error = error {
                completion(error)
            } else {
                if let snapshot = snapshot {
                    if (snapshot.documents.count == 0) {
                        completion(NSError(domain: "", code: 8, userInfo: [NSLocalizedDescriptionKey: Text.FriendNotFound]))
                    } else {
                        // Impossible to have more than 1 document
                        let friendUID = snapshot.documents[0].data()["uid"]! as! String
                        self.db.collection("friends").whereField("uids", arrayContains: friendUID).getDocuments { (snapshot, error) in
                            if let error = error {
                                completion(error)
                            } else {
                                if let snapshot = snapshot {
                                    let documents = snapshot.documents
                                    for document in documents {
                                        let friend = try! FirebaseDecoder().decode(Friend.self, from: document.data())
                                        if friend.uids.contains(UserShared.shared.uid) {
                                            // Already friends
                                            if friend.pending {
                                                completion(NSError(domain: "", code: 9, userInfo: [NSLocalizedDescriptionKey: Text.FriendRequestSentAlready]))
                                                return
                                            } else {
                                                completion(NSError(domain: "", code: 9, userInfo: [NSLocalizedDescriptionKey: Text.FriendsAlready]))
                                                return
                                            }
                                        }
                                    }
                                    // Not friends yet
                                    let friendObject = Friend(pending: true, uids: [Auth.auth().currentUser!.uid, friendUID])
                                    let encodedFriendObject = try! FirebaseEncoder().encode(friendObject)
                                    self.db.collection("friends").addDocument(data: encodedFriendObject as! [String : Any])
                                    completion(nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func acceptFriendRequest(friendUID: String, completion: @escaping (Error?) -> Void) {
        db.collection("friends").whereField("uids", arrayContains: friendUID).getDocuments { [unowned self] (snapshot, error) in
            if let error = error {
                completion(error)
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    var friend = try! FirebaseDecoder().decode(Friend.self, from: document.data())
                    if friend.uids.contains(UserShared.shared.uid) {
                        friend.pending = false
                    }
                    let friendSerialized = try! FirebaseEncoder().encode(friend)
                    self.db.collection("friends").document(document.documentID).setData(friendSerialized as! [String : Any])
                    completion(nil)
                    return
                }
            }
            completion(NSError(domain: "", code: 99, userInfo: [NSLocalizedDescriptionKey: Text.SomethingWentWrong]))
        }
    }
    
    func declineFriendRequest(friendUID: String, completion: @escaping (Error?) -> Void) {
        db.collection("friends").whereField("uids", arrayContains: friendUID).getDocuments { [unowned self] (snapshot, error) in
            if let error = error {
                completion(error)
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let friend = try! FirebaseDecoder().decode(Friend.self, from: document.data())
                    if friend.uids.contains(UserShared.shared.uid) {
                        self.db.collection("friends").document(document.documentID).delete { (error) in
                            if let error = error {
                                completion(error)
                                return
                            }
                            completion(nil)
                            return
                        }
                    }
                }
            }
            //completion(NSError(domain: "", code: 99, userInfo: [NSLocalizedDescriptionKey: Text.SomethingWentWrong]))
        }
    }
    
    
    func buyStock(stockObject: Stock, completion: @escaping (Error?) -> Void) {
        let encodedStockObject = try! FirebaseEncoder().encode(stockObject)
        self.db.collection("stock-market").addDocument(data: encodedStockObject as! [String : Any])
        completion(nil)
    }
    
    func getStock(completion: @escaping (([Stock]?, Error?)) -> Void) {
        var stockArray = [Stock]()
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("stock-market").whereField("uid", isEqualTo: uid).getDocuments { (snapshot, error) in
                if let error = error {
                    completion((nil, error))
                } else {
                    for document in snapshot!.documents {
                        let stock = try! FirebaseDecoder().decode(Stock.self, from: document.data())
                        print(stock.name)
                        stockArray.append(stock)
                    }
                }
                completion((stockArray, nil))
            }
        }
    }
    
    func sellStock(stockObject: Stock, completion: @escaping (Error?) -> Void) {
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("stock-market").whereField("uid", isEqualTo: uid).whereField("buyInPrice", isEqualTo: stockObject.buyInPrice).whereField("details", isEqualTo: stockObject.details).whereField("imageName", isEqualTo: stockObject.imageName).whereField("name", isEqualTo: stockObject.name).whereField("numOfShare", isEqualTo: stockObject.numOfShare).getDocuments { (snapshot, error) in
                if let error = error {
                    completion(error)
                } else {
                    if snapshot?.documents.count == 0 {
                        completion(nil)
                    } else {
                        let documentID = snapshot?.documents[0].documentID
                        self.db.collection("stock-market").document(documentID!).delete()
                        completion(nil)
                    }
                }
 
            }
        }
    }
    
    func setVersusRoom(room: VersusRoom, completion: @escaping ((VersusRoom?, Error?)) -> Void) {
        if let autoID = room.autoID {
            let serializedRoom = try! FirebaseEncoder().encode(room) as! [String: Any]
            db.collection("versus").document(autoID).setData(serializedRoom, merge: true) { (error) in
                completion((room, error))
            }
        } else {
            let newDoc = db.collection("versus").document()
            var roomWithID = room
            roomWithID.autoID = newDoc.documentID
            let serializedRoom = try! FirebaseEncoder().encode(roomWithID) as! [String: Any]
            newDoc.setData(serializedRoom) { (error) in
                completion((roomWithID, error))
            }
        }
    }
    
    func updateAnswerInVersusRoom(room: VersusRoom, completion: @escaping (Error?) -> Void) {
        if let autoID = room.autoID {
            var answersArray = room.p0Answers
            var fieldToUpdate = "p0Answers"
            if room.uid0 != UserShared.shared.uid {
                answersArray = room.p1Answers
                fieldToUpdate = "p1Answers"
            }
            db.collection("versus").document(autoID).updateData([fieldToUpdate: answersArray]) { (error) in
                completion(error)
            }
        }
    }
    
    func listenForOpponentJoin(room: VersusRoom, completion: @escaping (Error?) -> Void) {
        db.collection("versus").document(room.autoID!).addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(error)
                return
            }
            if let snapshot = snapshot {
                let modifiedRoom = try! FirebaseDecoder().decode(VersusRoom.self, from: snapshot.data()!)
                if modifiedRoom.allJoined {
                    completion(nil)
                } else {
                    completion(NSError(domain: "", code: 12, userInfo: [NSLocalizedDescriptionKey: Text.SomethingWentWrong]))
                }
            }
        }
    }
    
}


// MARK: - Firebase Storage
extension FirebaseService {
    
    func getImage(URL: String) -> UIImage {
        return UIImage(named: URL) ?? UIImage(named: Text.UserImageNamePlaceholder)!
    }
    
}
