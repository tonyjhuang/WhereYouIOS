//
//  MainViewController.swift
//  WhereYou
//
//  Created by Tony on 5/10/15.
//  Copyright (c) 2015 Tony. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  var friends = ["gary", "gasper", "david", "gimmi"]

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.backgroundColor = UIColor.UIColorFromRGB(UIColor.CYAN_ACCENT)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return friends.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! MainTableViewCell
    cell.setFriend(friends[indexPath.row])
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    return cell
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    println("selected \(friends[indexPath.row])")
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




