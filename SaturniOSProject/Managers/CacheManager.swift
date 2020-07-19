//
//  CacheManager.swift
//  SaturniOSProject
//
//  Created by Luke Solomon on 7/13/20.
//  Copyright © 2020 Observatory. All rights reserved.
//

import Foundation
import RealmSwift

enum CacheError: Error {
  case fetchFailure
  case writeFailure
  case realmFailure
}


class CacheManager:NSObject {
  
  
  static var shared = CacheManager()
//  static var dispatchQueue = DispatchQueue.init(label: "CacheManager", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: .global())

  func fetchAllNotes(completion: @escaping (Result<[Note], CacheError>) -> ()) {
//    CacheManager.dispatchQueue.async {
      autoreleasepool {
        do {
          let realm = try RealmSwift.Realm()
          do {
            let realmResults = realm.objects(Note.self)
            let notes = realmResults.toArray(ofType: Note.self)

            if notes.count == 0 {
              print("CacheManager: no notes fetched from Realm")
              completion(.failure(.fetchFailure))
            } else {
              completion(.success(notes))
            }
          }
        } catch let error as NSError {
          print("CacheManager: RealmError \(error) ")
          completion(.failure(.realmFailure))
        }
      }
//    }
  }
  
  func saveNote(note:Note, completion: @escaping () -> ()) {
//    CacheManager.dispatchQueue.async {
      autoreleasepool {
        do {
          let realm = try RealmSwift.Realm()
          do {
            try realm.write {
              realm.add(note)
              completion()
            }
          } catch let error as NSError {
            print("CacheManager: error saving note \(error.localizedDescription) ")
            completion()
          }
        } catch let error as NSError {
          print("CacheManager: RealmError \(error.localizedDescription) ")
          completion()
        }
      }
//    }
  }
  
}

