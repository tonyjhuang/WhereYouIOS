//
//  MapViewController.swift
//  WhereYou
//
//  Created by Tony on 6/11/15.
//  Copyright (c) 2015 Tony. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate {

  
  @IBOutlet weak var mapView: GMSMapView! {
    didSet {
      mapView.settings.scrollGestures = false
      mapView.settings.zoomGestures = false
      mapView.settings.tiltGestures = false
      mapView.settings.rotateGestures = false
    }
  }
  
  @IBAction func finish(sender: UITapGestureRecognizer) {
    dismissViewControllerAnimated(true, completion: nil)
  }
 
  
  
}
