//
//  Note.swift
//  SaturniOSProject
//
//  Created by Luke Solomon on 7/13/20.
//  Copyright © 2020 Observatory. All rights reserved.
//

import Foundation
import RealmSwift

class Note:Object {
  @objc dynamic var id = Int()
  @objc dynamic var text = String()
  @objc dynamic var image = Data()
  @objc dynamic var imageSmallURL = String()
  @objc dynamic var imageLargeURL = String()
}


struct NoteModel:Codable {
  var id:Int
  var text:String
  var imageDetail:ImageDetail?
  var imageData:UIImage?
  
  private enum CodingKeys: String, CodingKey {
    case id
    case text = "title"
    case imageDetail = "image"
  }

  init(note: Note) {
    self.id = note.id
    self.text = note.text
  }
  
  init(from decoder:Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try values.decode(Int.self, forKey: .id)
    self.text = try values.decode(String.self, forKey: .text)
    
    do {
      self.imageDetail = try values.decode(ImageDetail.self, forKey: .imageDetail)
    } catch {
      self.imageDetail = nil
    }
    self.imageData = nil
  }
}

struct ImageDetail:Codable {
  var id:String
  var urls:ImageUrls
  var contentType:String
  
  private enum CodingKeys: String, CodingKey {
    case id
    case contentType = "content_type"
    case urls = "size_urls"
  }
}

struct ImageUrls:Codable {
  var small:String
  var medium:String
  var large:String
}

extension Results {
  
  func toArray<T>(ofType: T.Type) -> [T] {
    var array = [T]()
    for i in 0 ..< count {
      if let result = self[i] as? T {
        array.append(result)
      }
    }
    
    return array
  }
  
}
