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

  @IBOutlet weak var backgroundView: UIView! {
    didSet {
      backgroundView.backgroundColor = UIColor.getRandomColor(Constants.name)
    }
  }
  @IBOutlet weak var nameLabel: UILabel! {
    didSet {
      nameLabel.text = Constants.name
    }
  }
  @IBOutlet weak var addressLabel: UILabel! {
    didSet {
      setAddressLabelTextFromCoordinates(Constants.hillsideLat, lng: Constants.hillsideLng)
    }
  }
  
  @IBOutlet weak var bottomLabelBackgroundView: UIView! {
    didSet {
      bottomLabelBackgroundView.backgroundColor = UIColor.getRandomColor(Constants.name)
    }
  }
  
  private struct Constants {
    static let ZoomLevel: Float = 14
    static let hillsideLat: CLLocationDegrees = 42.3315870
    static let hillsideLng: CLLocationDegrees = -71.1079980
    static let LocationAccuracy = 25
    static let name: String = "gary"
  }
  
  @IBOutlet weak var mapView: GMSMapView! {
    didSet {
      mapView.settings.scrollGestures = false
      mapView.settings.zoomGestures = false
      mapView.settings.tiltGestures = false
      mapView.settings.rotateGestures = false
      
      setLocation(Constants.hillsideLat, lng: Constants.hillsideLng)
    }
  }
  
  @IBAction func finish(sender: UITapGestureRecognizer) {
    dismissViewControllerAnimated(true, completion: nil)
  }
 
  func setLocation(lat: CLLocationDegrees, lng: CLLocationDegrees) {
    let camera = GMSCameraPosition.cameraWithLatitude(lat, longitude: lng, zoom: Constants.ZoomLevel)
    mapView.camera = camera
    
    let position = CLLocationCoordinate2DMake(lat, lng)
    let marker = GMSMarker(position: position)
    marker.map = mapView
  }
  
  private func setAddressLabelTextFromCoordinates(lat: CLLocationDegrees, lng: CLLocationDegrees) {
    let aGMSGeocoder: GMSGeocoder = GMSGeocoder()
    aGMSGeocoder.reverseGeocodeCoordinate(CLLocationCoordinate2DMake(lat, lng)) {
      (let gmsReverseGeocodeResponse: GMSReverseGeocodeResponse!, let error: NSError!) -> Void in
      
      if let gmsAddress: GMSAddress = gmsReverseGeocodeResponse.firstResult() {
        if let readableAddress = self.getReadableAddress(gmsAddress) {
          self.addressLabel.text = readableAddress
        } else {
          // hide address label?
          //self.addressLabel.hidden = true
        }
      } else {
        // hide address label?
        //self.addressLabel.hidden = true
      }
    }
  }
  
  private func getReadableAddress(gmsAddress: GMSAddress) -> String? {
    if let lines = gmsAddress.lines as? [String] {
      return ", ".join(lines)
    } else {
      return nil
    }
  }
  
}
