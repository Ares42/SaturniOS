//
//  NetworkManager.swift
//  SaturniOSProject
//
//  Created by Luke Solomon on 7/13/20.
//  Copyright © 2020 Observatory. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkError: Error {
  case urlFailure
  case getFailure
  case postFailure
  case malformedDataFailure
  case networkFailure
}

class NetworkManager:NSObject {
  
  static var shared = NetworkManager()
  let baseUrl = URL(string: "https://env-develop.saturn.engineering/api/v2/test-notes")!
  let imageUrl = URL(string: "https://env-develop.saturn.engineering/api/v2/test-notes/photo")!
  
  
  func fetchAllNotes(completion: @escaping (Result<[NoteModel], NetworkError>) -> ()) {
    AF.request(baseUrl, method: .get).validate().responseDecodable(of: [NoteModel].self) { response in
        guard let noteModels = response.value else {
          print("NetworkManager: Error with Note Data: \(response)")
          completion(.failure(.malformedDataFailure))
          return
        }
        completion(.success(noteModels))
    }
  }
  
  func getImageForURL(_ url:URL, completion: @escaping (Result<Data, NetworkError>) -> ()) {
    AF.request(url, method: .get).validate().responseData { (response) in
      guard let safeData = response.value else {
        print("NetworkManager: Error with image response Data: \(response)")
        completion(.failure(.malformedDataFailure))
        return
      }
      completion(.success(safeData))
    }
  }
  
  func postNote(noteModel: NoteModel) {
    AF.request(imageUrl, method: .post, parameters: noteModel, encoder: JSONParameterEncoder.default)
  }
  
  func uploadImage() {
    
  }
  
}
