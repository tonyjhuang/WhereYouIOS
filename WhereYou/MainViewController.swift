//
//  MainViewController.swift
//  WhereYou
//
//  Created by Tony on 5/10/15.
//  Copyright (c) 2015 Tony. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, AddFriendDelegate, MainTableViewCellDelegate, UIGestureRecognizerDelegate {
  
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      // set gesture recognizers
      let gesture = UILongPressGestureRecognizer(target: self, action: "onLongPress:")
      gesture.minimumPressDuration = 0.5 // seconds
      tableView.addGestureRecognizer(gesture)
      tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTap:"))
    }
  }
  
  @IBOutlet weak var nameLabelContainer: UIView!
  @IBOutlet weak var nameLabel: UILabel! {
    didSet {
      nameLabel.text = "Hello, \(parse.name)."
    }
  }
  
  
  var editMode = false {
    didSet { tableView?.reloadData() }
  }
  
  let parse: ParseHelper = ParseHelper.sharedInstance
  
  var locationManager = CLLocationManager()
  
  var addFriendCell: AddFriendTableViewCell?
  
  /**
  * Swipe right to go back
  */
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    locationManager.delegate = self
  }
  
  func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
    if(navigationController!.viewControllers.count > 1){
      return true
    }
    return false
  }
  
  
  /**
  * Gestures
  */
  
  // Handle long press on tableview
  func onLongPress(gesture: UILongPressGestureRecognizer) {
    // start editmode if user is long clicking on row.
    let point: CGPoint = gesture.locationInView(tableView)
    if let _ = tableView.indexPathForRowAtPoint(point) {
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
        if editMode {
          editMode = false
          addFriendCell?.showInput(false)
        } else {
          if addFriendCell != nil && addFriendCell!.isShowingInput {
            addFriendCell?.showInput(false)
          } else {
            parse.askForLocation(friendCell.label.text!)
          }
        }
      }
    } else { // tableview (no row)
      print("selected tableview background")
      editMode = false
      addFriendCell?.showInput(false)
    }
  }
  
  /**
  * Modify Friends list
  */
  func addFriend(friend: String) {
    if let cell = addFriendCell {
      cell.showInput(false)
    }
    
    parse.addFriend(friend) { friends -> Void in
      self.tableView.reloadData()
    }
  }
  
  func deleteFriend(friend: Friend) {
    parse.removeFriend(friend.name)
    tableView.reloadData()
  }
  
  func respondToFriend(friend: Friend) {
    parse.markAsAsking(false, forFriend: friend.name)
    tableView.reloadData()
  }
  
  // Notify this viewcontroller that the friendslist has changed.
  func updateFriendsList() {
    print("updating friendslist!")
    print(parse.friendsList)
    tableView?.reloadData()
  }
  
}

// MARK: TableViewDataSource

extension MainViewController : UITableViewDataSource {
  
  /**
  * Prepare tableView data.
  */
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return parse.friends.count + 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: UITableViewCell
    if indexPath.row < parse.friendsList.friends.count {
      cell = tableView.dequeueReusableCellWithIdentifier("cell")!
      if let friendCell = cell as? MainTableViewCell {
        friendCell.friend = parse.friendsList.friends[indexPath.row]
        friendCell.setEditMode(editMode)
        friendCell.delegate = self
      }
    } else { // throw AddFriend row into end of the tableview.
      cell = tableView.dequeueReusableCellWithIdentifier("addfriend")!
      addFriendCell = cell as? AddFriendTableViewCell
      addFriendCell?.delegate = self
    }
    // Don't highlight tableview cells
    cell.selectionStyle = .None
    return cell
  }
}

//MARK: Keyboard

extension MainViewController {
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "keyboardWillShow:",
      name: UIKeyboardWillShowNotification,
      object: nil)
    
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "keyboardWillHide:",
      name: UIKeyboardWillHideNotification,
      object: nil)
  }
  
  func keyboardWillShow(note: NSNotification) {
    if let userInfo = note.userInfo {
      if let keyboardFrameBeginRect: CGRect = userInfo[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue {
        let keyboardHeight = keyboardFrameBeginRect.size.height
        let nameLabelContainerHeight = nameLabelContainer.frame.size.height
        print("\(keyboardHeight)")
        tableView.contentInset = UIEdgeInsets(top: 0,
          left: 0,
          bottom: keyboardHeight - nameLabelContainerHeight,
          right: 0)
      }
    }
  }
  
  func keyboardWillHide(note: NSNotification) {
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  override func viewWillDisappear(animated: Bool) {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

}

// MARK: CLLocation

extension MainViewController : CLLocationManagerDelegate {
  
  @IBAction func getCurrentLocation() {
    switch CLLocationManager.authorizationStatus() {
    case .Authorized, .AuthorizedWhenInUse:
      print("retrieving location?")
      getCurrentLocationUpdates()
      break
    case .NotDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .Restricted, .Denied:
      /*
      User has not given us permission to use the location services... wat
      */
      let alertController = UIAlertController(
        title: "Location Access Disabled :(",
        message: "Please open this app's settings and allow us to use your location so that WhereYou can run properly!",
        preferredStyle: .Alert)
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
      alertController.addAction(cancelAction)
      
      let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
        if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
          UIApplication.sharedApplication().openURL(url)
        }
      }
      alertController.addAction(openAction)
      
      self.presentViewController(alertController, animated: true, completion: nil)
    }
  }
  
  // User just gave us permissions!
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == .Authorized || status == .AuthorizedWhenInUse {
      getCurrentLocationUpdates()
    }
  }
  
  func getCurrentLocationUpdates() {
    //locationManager.startUpdatingLocation()
    let (lat, lng) = getFakeLocation()
    let fakeLocation = CLLocation(latitude: lat, longitude: lng)
    self.locationManager(locationManager, didUpdateToLocation: fakeLocation, fromLocation: fakeLocation)
  }
  
  func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
    locationManager.stopUpdatingLocation()
    let coord = newLocation.coordinate
    print("lat: \(coord.latitude), lng: \(coord.longitude)")
  }
  
  private func getFakeLocation() -> (lat: CLLocationDegrees, lng: CLLocationDegrees) {
    let latOffset = Double((-1000...1000).randomInt) / 10000
    let lngOffset = Double((-1000...1000).randomInt) / 10000
    return (42.333305 + latOffset, -71.100022 + lngOffset)
  }
  
}

// MARK: - TableViewCells

protocol MainTableViewCellDelegate: class {
  func deleteFriend(friend: Friend)
  func respondToFriend(friend: Friend)
}

class MainTableViewCell: UITableViewCell {
  
  @IBOutlet weak var background: UIView!
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var delete: UIImageView! {
    didSet {
      delete.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onDeleteTap:"))
      delete.userInteractionEnabled = true
    }
  }
  @IBOutlet weak var asking: UILabel! {
    didSet {
      asking.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onAskingTap"))
      asking.userInteractionEnabled = true
    }
  }
  
  weak var delegate: MainTableViewCellDelegate?
  
  var friend: Friend? {
    didSet {
      print("setting \(friend!)")
      label.text = friend!.name
      background.backgroundColor = UIColor.getRandomColor(friend!.name)
      asking.hidden = !friend!.asking
    }
  }
  
  func onDeleteTap(gesture: UITapGestureRecognizer) {
    delegate?.deleteFriend(friend!)
  }
  
  func onAskingTap() {
    delegate?.respondToFriend(friend!)
    print("tap!")
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
  
  var isShowingInput: Bool {
    get { return input.isFirstResponder() }
  }
  
  override func awakeFromNib() {
    // Add tap gesture
    let gesture = UITapGestureRecognizer(target: self, action: "onTap:")
    contentView.addGestureRecognizer(gesture)
  }
  
  func onTap(gesture: UITapGestureRecognizer) {
    showInput(true)
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if delegate != nil {
      if let newFriend = input.text {
        delegate!.addFriend(newFriend)
      }
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




