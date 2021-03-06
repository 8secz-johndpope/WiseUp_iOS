//
//  CacheService.swift
//  QuickFin
//
//  Created by Connor Buckley on 9/29/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import Disk

class CacheService {
    
    static var shared = CacheService()
    private init() {}
    
    func getChapters(completion: @escaping ([Chapter]) -> Void) {
        
        var chapters = [Chapter]()
        
        // If nothing is cached yet, update the Chapters and return
        if !Disk.exists("chapters.json", in: .caches) {
            
            updateChapters() { (chaps)  in
                chapters = chaps
                completion(chapters)
                return
            }
            
        }
        
        // Else something is cached, need to check the timestamps to see if we have the most recent version
        else {
            
            var cachedTimeStamp: ChapterStats
            
            do {
                cachedTimeStamp = try Disk.retrieve("timestamp.json", from: .caches, as: ChapterStats.self)
            } catch let error as NSError {
                fatalError("""
                Domain: \(error.domain)
                Code: \(error.code)
                Description: \(error.localizedDescription)
                Failure Reason: \(error.localizedFailureReason ?? "")
                Suggestions: \(error.localizedRecoverySuggestion ?? "")
                """)
            }
            
            FirebaseService.shared.getChapterTimestamp { (timestamp) in
                
                //if timestamp match get the existing cached chapters
                if (cachedTimeStamp.timestamp == timestamp?.timestamp) {
                    chapters = self.getCachedChapters()
                    completion(chapters)
                    return
                }
                    
                //else we need to update the cached chapters
                else {
                    self.updateChapters { (chaps) in
                        chapters = chaps
                        completion(chapters)
                        return
                    }
                }
                
            }
        }
    }
    
    func getCachedChapters() -> [Chapter] {
        
        var chapters = [Chapter]()
        
        if Disk.exists("chapters.json", in: .caches) {
            
            do {
                chapters = try Disk.retrieve("chapters.json", from: .caches, as: [Chapter].self)
            } catch let error as NSError {
                fatalError("""
                Domain: \(error.domain)
                Code: \(error.code)
                Description: \(error.localizedDescription)
                Failure Reason: \(error.localizedFailureReason ?? "")
                Suggestions: \(error.localizedRecoverySuggestion ?? "")
                """)
            }
            
            return chapters
            
        } else {
            return []
        }
        
    }
    
    func updateChapters(completion: @escaping ([Chapter]) -> Void) {
        
        FirebaseService.shared.loadChapters { (chaps, timestamp) in
            
            do {
                try Disk.save(chaps, to: .caches, as: "chapters.json")
                try Disk.save(timestamp, to: .caches, as: "timestamp.json")
            } catch let error as NSError {
                fatalError("""
                Domain: \(error.domain)
                Code: \(error.code)
                Description: \(error.localizedDescription)
                Failure Reason: \(error.localizedFailureReason ?? "")
                Suggestions: \(error.localizedRecoverySuggestion ?? "")
                """)
            }
            
            completion(chaps)
            return
        }
        
    }
    
    func updateStore(completion: @escaping ([StoreItem]) -> Void) {
        
        FirebaseService.shared.loadStore { (store2, timestamp) in
            
            do {
                try Disk.save(store2, to: .caches, as: "store.json")
                try Disk.save(timestamp, to: .caches, as: "storeTimestamp.json")
            } catch let error as NSError {
                fatalError("""
                Domain: \(error.domain)
                Code: \(error.code)
                Description: \(error.localizedDescription)
                Failure Reason: \(error.localizedFailureReason ?? "")
                Suggestions: \(error.localizedRecoverySuggestion ?? "")
                """)
            }
            
            completion(store2)
            return
        }
        
    }
    
    func getCachedStore() -> [StoreItem] {
        
        var store = [StoreItem]()
        
        if Disk.exists("store.json", in: .caches) {
            
            do {
                store = try Disk.retrieve("store.json", from: .caches, as: [StoreItem].self)
            } catch let error as NSError {
                fatalError("""
                Domain: \(error.domain)
                Code: \(error.code)
                Description: \(error.localizedDescription)
                Failure Reason: \(error.localizedFailureReason ?? "")
                Suggestions: \(error.localizedRecoverySuggestion ?? "")
                """)
            }
            
            return store
            
        } else {
            return []
        }
        
    }
    
    func getStore(completion: @escaping ([StoreItem]) -> Void) {
        var store = [StoreItem]()
        
        // If nothing is cached yet, update the Chapters and return
        if !Disk.exists("store.json", in: .caches) {
            
            updateStore() { (store2)  in
                store = store2
                completion(store)
                return
            }
            
        }
        
        // Else something is cached, need to check the timestamps to see if we have the most recent version
        else {
            
            var cachedTimeStamp: ChapterStats
            
            do {
                cachedTimeStamp = try Disk.retrieve("storeTimestamp.json", from: .caches, as: ChapterStats.self)
            } catch let error as NSError {
                fatalError("""
                Domain: \(error.domain)
                Code: \(error.code)
                Description: \(error.localizedDescription)
                Failure Reason: \(error.localizedFailureReason ?? "")
                Suggestions: \(error.localizedRecoverySuggestion ?? "")
                """)
            }
            
            FirebaseService.shared.getStoreTimestamp { (timestamp) in
                
                //if timestamp match get the existing cached chapters
                if (cachedTimeStamp.timestamp == timestamp?.timestamp) {
                    store = self.getCachedStore()
                    completion(store)
                    return
                }
                    
                //else we need to update the cached chapters
                else {
                    self.updateStore { (store2) in
                        store = store2
                        completion(store)
                        return
                    }
                }
                
            }
        }
    }
}



