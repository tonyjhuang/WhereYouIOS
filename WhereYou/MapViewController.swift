//
//  MapViewController.swift
//  WhereYou
//
//  Created by Tony on 6/11/15.
//  Copyright (c) 2015 Tony. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

  
  @IBOutlet weak var mapView: GMSMapView!
  
  @IBAction func finish(sender: UITapGestureRecognizer) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
}
