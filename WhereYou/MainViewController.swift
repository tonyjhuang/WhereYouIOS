//
//  MainViewController.swift
//  WhereYou
//
//  Created by Tony on 5/10/15.
//  Copyright (c) 2015 Tony. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  
  var friends = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
    friends = ParseHelper.sharedInstance.getFriends()
    // Do any additional setup after loading the view, typically from a nib.
    //tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    //var customTableViewCellNib = UINib(nibName: "MainTableViewCell", bundle: nil)
    //tableView.registerNib(customTableViewCellNib, forCellReuseIdentifier: "cell")
    //tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
    return cell
  }

}

class MainTableViewCell: UITableViewCell {
  
  @IBOutlet weak var label: UILabel!
  
  func setFriend(friend: String) {
    label.text = friend
  }
}




