//
//  MainViewController.swift
//  WhereYou
//
//  Created by Tony on 5/10/15.
//  Copyright (c) 2015 Tony. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddFriendDelegate, MainTableViewCellDelegate {
  
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.backgroundColor = UIColor.UIColorFromRGB(UIColor.CYAN_ACCENT)
      
      // set gesture recognizers
      let gesture = UILongPressGestureRecognizer(target: self, action: "onLongPress:")
      gesture.minimumPressDuration = 0.5 // seconds
      tableView.addGestureRecognizer(gesture)
      tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTap:"))
    }
  }
  
  @IBOutlet weak var nameLabel: UILabel! {
    didSet {
        nameLabel.text = "Hello, \(parse.name)."
    }
  }
  
  
  var editMode = false {
    didSet { tableView?.reloadData() }
  }
  
  let parse: ParseHelper = ParseHelper.sharedInstance
  
  var addFriendCell: AddFriendTableViewCell?
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return parse.friends.count + 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: UITableViewCell
    if indexPath.row < parse.friends.count {
      cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
      if let friendCell = cell as? MainTableViewCell {
        friendCell.setFriend(parse.friends[indexPath.row])
        friendCell.setEditMode(editMode)
        friendCell.delegate = self
      }
    } else { // throw AddFriend row into end of the tableview.
      cell = tableView.dequeueReusableCellWithIdentifier("addfriend") as! UITableViewCell
      addFriendCell = cell as? AddFriendTableViewCell
      addFriendCell?.delegate = self
    }
    // Don't highlight tableview cells
    cell.selectionStyle = .None
    return cell
  }
  
  // Handle long press on tableview
  func onLongPress(gesture: UILongPressGestureRecognizer) {
    // start editmode if user is long clicking on row.
    let point: CGPoint = gesture.locationInView(tableView)
    if let indexPath = tableView.indexPathForRowAtPoint(point) {
      if gesture.state == .Began {
        editMode = !editMode
      }
    }
  }
  
  // Handle tap anywhere on tableview
  func onTap(gesture: UITapGestureRecognizer) {
    let point: CGPoint = gesture.locationInView(tableView)
    if let indexPath = tableView.indexPathForRowAtPoint(point){ // tapped friend row
      if let friendCell = tableView.cellForRowAtIndexPath(indexPath) as? MainTableViewCell {
        println("selected \(friendCell.label.text!)")
        addFriendCell?.showInput(false)
        if editMode {
          editMode = false
        } else {
          // TODO: parse stuff
          
        }
      }
    } else { // tableview (no row)
      println("selected tableview background")
      editMode = false
      addFriendCell?.showInput(false)
    }
  }
  
  func addFriend(friend: String) {
    if let cell = addFriendCell {
      cell.showInput(false)
    }
    
    parse.friends += [friend]
    tableView.reloadData()
  }
  
  func deleteFriend(friend: String) {
    parse.removeFriend(friend)
    tableView.reloadData()
  }
}

protocol MainTableViewCellDelegate: class {
  func deleteFriend(friend: String)
}

class MainTableViewCell: UITableViewCell {
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var delete: UIImageView!
  
  weak var delegate: MainTableViewCellDelegate?
  
  func setFriend(friend: String) {
    label.text = friend
    label.textColor = UIColor.whiteColor()
    label.backgroundColor = UIColor.getRandomColor(friend)
    delete.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onDeleteTap:"))
    delete.userInteractionEnabled = true
  }
  
  func onDeleteTap(gesture: UITapGestureRecognizer) {
    delegate?.deleteFriend(label.text!)
  }
  
  func setEditMode(editing: Bool) {
    delete.hidden = !editing
  }
}

protocol AddFriendDelegate: class {
  func addFriend(friend: String)
}

class AddFriendTableViewCell: UITableViewCell, UITextFieldDelegate {
  
  @IBOutlet weak var label: UILabel!
  
  @IBOutlet weak var input: UITextField! {
    didSet {
      input.delegate = self
    }
  }
  
  weak var delegate: AddFriendDelegate?
  
  override func awakeFromNib() {
    // Add tap gesture
    var gesture = UITapGestureRecognizer(target: self, action: "onTap:")
    contentView.addGestureRecognizer(gesture)
  }
  
  func onTap(gesture: UITapGestureRecognizer) {
    showInput(true)
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if delegate != nil {
      delegate!.addFriend(input.text)
    }
    return false
  }
  
  func showInput(show: Bool) {
    label.hidden = show
    input.hidden = !show
    if show {
      input.becomeFirstResponder()
    } else {
      input.resignFirstResponder()
      input.text = ""
    }
  }
}




