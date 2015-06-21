//
//  Random.swift
//  WhereYou
//
//  Created by Tony on 6/20/15.
//  Copyright © 2015 Tony. All rights reserved.
//

import Foundation

extension Range
{
  var randomInt: Int
    {
    get
    {
      var offset = 0
      
      if (startIndex as! Int) < 0   // allow negative ranges
      {
        offset = abs(startIndex as! Int)
      }
      
      let mini = UInt32(startIndex as! Int + offset)
      let maxi = UInt32(endIndex   as! Int + offset)
      
      return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
  }
}