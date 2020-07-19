//
//  NoteTableViewCell.swift
//  SaturniOSProject
//
//  Created by Luke Solomon on 7/13/20.
//  Copyright © 2020 Observatory. All rights reserved.
//

import UIKit
import SDWebImage

enum NoteCellStatus {
  case outOfSyncWithBackend
  case syncingWithBackend
  case inSyncWithBackend
}


struct NoteCellViewModel {
  var image:UIImage?
  var url:URL?
  var title:String
  var status:NoteCellStatus
  
  init(note:Note) {
    self.image = UIImage(data: note.image)
    self.url = URL(string: note.imageSmallURL)
    self.title = note.text
    self.status = .outOfSyncWithBackend
  }
}


class NoteCell: UITableViewCell {
  
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var iconView: UIImageView!
  @IBOutlet weak var noteLabel: UILabel!
  @IBOutlet weak var statusButton: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.iconView.sd_cancelCurrentImageLoad()
    self.iconView.image = nil
    self.noteLabel.text = nil
  }
  
  func configure(viewModel:NoteCellViewModel) {
    self.iconView.image = viewModel.image
    self.noteLabel.text = viewModel.title
    self.iconView.sd_setImage(with: viewModel.url)
    switch viewModel.status {
    case .outOfSyncWithBackend:
      self.statusButton.backgroundColor = UIColor.red
    case .syncingWithBackend:
      self.statusButton.backgroundColor = UIColor.yellow
    case .inSyncWithBackend:
      self.statusButton.backgroundColor = UIColor.green
    }

  }
  
  func setImage(with url:URL) {
  }
  
  
  
}
