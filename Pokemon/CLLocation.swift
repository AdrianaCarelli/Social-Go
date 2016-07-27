//
//  CLLocation.swift
//  Pokemon
//
//  Created by Reza Shirazian on 2016-07-16.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocation {
  func toAnyObject(pokemon: Pokemon, uid: String) -> AnyObject {
    return [
      "latitude": self.coordinate.latitude,
      "longitude": self.coordinate.longitude,
      "pokemonId": pokemon.id,
      "uid": uid,
      "timestamp": timestamp.timeIntervalSince1970
    ]
  }
}
