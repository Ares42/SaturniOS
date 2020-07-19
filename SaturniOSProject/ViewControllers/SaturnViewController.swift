//
//  ViewController.swift
//  SaturniOSProject
//
//  Created by Luke Solomon on 7/13/20.
//  Copyright © 2020 Observatory. All rights reserved.
//

import UIKit

class SaturnViewController: UITableViewController {
  
  var notes = [Note]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    DataManager.shared.fetchAllNotes { notes in
      self.notes = notes
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationViewController = segue.destination as! NoteViewController
    if segue.identifier == "ShowNote"{
      if let selectedRow = tableView.indexPathForSelectedRow {
        destinationViewController.note = notes[selectedRow.row]
      } else {
        destinationViewController.note = Note()
      }
    } else {
      destinationViewController.note = Note()
    }
  }
  
  @IBAction func addNoteButtonTapped(_ sender: Any) {
    self.performSegue(withIdentifier: "AddNote", sender: self)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //trigger segue
    self.performSegue(withIdentifier: "ShowNote", sender: self)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notes.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
    cell.configure(viewModel: NoteCellViewModel(note: notes[indexPath.row]))
    return cell
  }
  
}

