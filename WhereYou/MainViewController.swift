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
    }
  }
  
  private struct Constants {
    static let DefaultsKey = "MainViewController.friends"
    static let Friends = ["gary", "gasper", "allison"]
  }
  
  var defaults = NSUserDefaults.standardUserDefaults()
  var editMode = false
  
  var friends: [String] {
    get { return defaults.objectForKey(Constants.DefaultsKey) as? [String] ?? Constants.Friends }
    set {
      defaults.setObject(newValue, forKey: Constants.DefaultsKey)
      tableView?.reloadData()
    }
  }
  
  var addFriendCell: AddFriendTableViewCell?

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return friends.count + 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: UITableViewCell
    if indexPath.row < friends.count {
      cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
      (cell as! MainTableViewCell).setFriend(friends[indexPath.row])
      (cell as! MainTableViewCell).delegate = self
    } else {
      cell = tableView.dequeueReusableCellWithIdentifier("addfriend") as! UITableViewCell
      addFriendCell = cell as? AddFriendTableViewCell
      addFriendCell?.delegate = self
    }
    // Don't highlight tableview cells
    cell.selectionStyle = .None
    return cell
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.row < friends.count {
      println("selected \(friends[indexPath.row])")
    }
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  func addFriend(friend: String) {
    if let cell = addFriendCell {
      cell.showInput(false)
    }
    
    friends += [friend]
  }
  
  func deleteFriend(friend: String) {
    if let index = find(friends, friend) {
      friends.removeAtIndex(index)
    }
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




