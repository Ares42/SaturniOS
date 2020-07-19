//
//  DataManager.swift
//  SaturniOSProject
//
//  Created by Luke Solomon on 7/13/20.
//  Copyright © 2020 Observatory. All rights reserved.
//

import Foundation
import Reachability

enum DataError: Error {
  case getFailure
  case postFailure
  case cacheError
  case networkFailure
}

class DataManager:NSObject {
  
  static let shared = DataManager()
  static var reachable = Bool()
  
  static var dispatchQueue = DispatchQueue.init(label: "DataMgr", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: .global())
  static var noteStatuses = [NoteCellStatus]()
  
  
  func reachableTest()  {
    let reachability = try! Reachability()
    
    reachability.whenReachable = { reachability in
      if reachability.connection == .wifi {
        print("Reachable via WiFi")
        DataManager.reachable = true
      } else {
        print("Reachable via Cellular")
        DataManager.reachable = true
      }
    }
    
    reachability.whenUnreachable = { _ in
      print("Not reachable")
      DataManager.reachable = false
    }
  }
  
  func fetchAllNotes(completion: @escaping ([Note])  -> () ) {
    DataManager.shared.reachableTest()
    // first check the cache
    // then, if cache fails, do reachability check
    // if reach fails, wait to send request
    // if reach succeeds, send
    
    DataManager.dispatchQueue.async {
      CacheManager.shared.fetchAllNotes { result in
        if case .success(let notes) = result {
          completion(notes)
        } else if case .failure = result {
          //        if DataManager.reachable {
          
          NetworkManager.shared.fetchAllNotes { result in
            if case .success(let noteModels) = result {
              let notes = DataManager.shared.noteModelsToNotes(noteModels)
              // TODO: save notes to Realm
              completion(notes)
            } else if case .failure = result {
              // wait for reachability?
            }
          }
          
          //        } else {
          //          print("waiting to reach interwebs")
          //        }
        }
      }
    }
    
  }
  
  func noteModelsToNotes(_ noteModels:[NoteModel]) -> [Note] {
    var notes = [Note]()
    for noteModel in noteModels {
      let note = Note.init()
      note.id = noteModel.id
      note.text = noteModel.text
      note.imageSmallURL = noteModel.imageDetail?.urls.small ?? ""
      note.imageLargeURL = noteModel.imageDetail?.urls.large ?? ""
      note.image = Data()
      notes.append(note)
    }
    return notes
  }
  
  // This function ended up being unused. I thought I'd be doing image fetching and caching myself.
  func fetchImageForURL(_ url:String, completion: @escaping (UIImage) -> ()) {
    DataManager.dispatchQueue.async {
      let constructedURL = URL.init(string: url)
      print(constructedURL as Any)
      
      guard let safeConstructedURL = constructedURL else {
        print("URL error")
        return
      }
      
      NetworkManager.shared.getImageForURL(safeConstructedURL, completion: { result in
        if case .success(let data) = result {
          guard let image = UIImage(data: data) else {
            print("DataManager: Error, data not image format Data: \(result)")
            return
          }
          // TODO: save notes to Realm
          completion(image)
        } else if case .failure(let error) = result {
          print("DataManager: Error fetching Data: \(error.localizedDescription)")
        }
      })
    }
  }
  
  func saveNote(noteModel:NoteModel, completion: @escaping () -> ()) {
    NetworkManager.shared.postNote(noteModel: noteModel)
    
    let note = DataManager.shared.noteModelsToNotes([noteModel])[0]
    
    CacheManager.shared.saveNote(note: note) {
      completion()
    }
  }
  
}
