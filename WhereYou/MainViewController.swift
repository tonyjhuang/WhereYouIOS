//
//  MainViewController.swift
//  WhereYou
//
//  Created by Tony on 5/10/15.
//  Copyright (c) 2015 Tony. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.backgroundColor = UIColor.UIColorFromRGB(UIColor.CYAN_ACCENT)
    }
  }
  
  private struct Constants {
    static let DefaultsKey = "MainViewController.friends"
  }
  
  var defaults = NSUserDefaults.standardUserDefaults()
  
  var friends: [String] {
    get { return defaults.objectForKey(Constants.DefaultsKey) as? [String] ?? [] }
    set { defaults.setObject(newValue, forKey: Constants.DefaultsKey) }
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return friends.count + 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: UITableViewCell
    if indexPath.row < friends.count {
      cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
      (cell as! MainTableViewCell).setFriend(friends[indexPath.row])
    } else {
      cell = tableView.dequeueReusableCellWithIdentifier("addfriend") as! AddFriendTableViewCell
    }
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    return cell
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.row < friends.count {
      println("selected \(friends[indexPath.row])")
    } else if indexPath.row == friends.count {
      println("selected add friend")
    }
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}

class MainTableViewCell: UITableViewCell {
  
  @IBOutlet weak var label: UILabel!
  
  func setFriend(friend: String) {
    label.text = friend
    label.textColor = UIColor.whiteColor()
    label.backgroundColor = UIColor.getRandomColor(friend)
    
  }
  func onCellClicked(recognizer: UITapGestureRecognizer) {

  }
}

class AddFriendTableViewCell: UITableViewCell {
  
}




