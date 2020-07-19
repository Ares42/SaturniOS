//
//  NoteViewController.swift
//  SaturniOSProject
//
//  Created by Luke Solomon on 7/13/20.
//  Copyright © 2020 Observatory. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
  
  var note:Note?
  
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var doneButton: UIButton!
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var chooseImage: UIButton!
  

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configure()
  }
  
  func configure() {
    self.textView.text = self.note?.text
    if let safeNote = self.note {
      if let url = URL(string: safeNote.imageLargeURL) {
        self.imageView.sd_setImage(with: url)
      }
    }
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.note = nil
  }
  
  // MARK: - IBActions
  @IBAction func chooseImageTapped(_ sender: Any) {
    let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
      self.openCamera()
    }))
    
    alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
      self.openGallery()
    }))
    
    alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
    
    self.present(alert, animated: true, completion: nil)
  }
  
  @IBAction func doneButtonTapped(_ sender: Any) {
    var noteModel = NoteModel(note: self.note!)
    noteModel.text = self.textView.text
    noteModel.imageData = self.imageView.image
    
    DataManager.shared.saveNote(noteModel: noteModel, completion: {
      DispatchQueue.main.async {
        self.dismiss(animated: true, completion: nil)
      }
    })
  }
  
  @IBAction func cancelButtonTapped(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  
  func openCamera() {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.sourceType = UIImagePickerController.SourceType.camera
      imagePicker.allowsEditing = false
      self.present(imagePicker, animated: true, completion: nil)
    } else {
      let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  func openGallery() {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.allowsEditing = true
      imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
      self.present(imagePicker, animated: true, completion: nil)
    } else {
      let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
  }
  
}
//MARK:-- ImagePicker delegate
extension NoteViewController:UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let pickedImage = info[.originalImage] as? UIImage {
//       imageViewPic.contentMode = .scaleToFill
      self.imageView.image = pickedImage
    }
    picker.dismiss(animated: true, completion: nil)
  }
}
//MARK:-- NavigationContrller delegate
extension NoteViewController: UINavigationControllerDelegate {
  
}
