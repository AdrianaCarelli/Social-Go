//
//  ComsManager.swift
//  Pokemon
//
//  Created by Reza Shirazian on 2016-07-15.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

class ComsManager {
  static var instance = ComsManager()
  var lastSubmited: Submission?
  var numberOfSubmissions: Int
  var ref: FIRDatabaseReference!

  private init() {
    self.ref = FIRDatabase.database().reference()
    self.numberOfSubmissions = 0
    var _ = NSTimer.scheduledTimerWithTimeInterval(180.0, target: self, selector: #selector(ComsManager.resetCount), userInfo: nil, repeats: true)
  }

  func getPokemonsBy(location: CLLocation, andDoThisWithIt: ([PokemonLocation]? -> ())) {

    let locationRef = self.ref.child("locations").queryOrderedByChild("latitude").queryStartingAtValue(location.coordinate.latitude - 0.5).queryEndingAtValue(location.coordinate.latitude + 0.5)
      locationRef.observeEventType(.Value) { (snapshot) in
      andDoThisWithIt(self.getPokemonAndTheirLocationFromSnapshot(snapshot))
    }
//    for iteration in rangeIterations {
//      let longNode = longLatToInteger(location.coordinate.longitude + iteration.0)
//      let latNode = longLatToInteger(location.coordinate.latitude + iteration.1)
//      let longNodeRef = self.ref.child("latitude").child("\(latNode)").child("\(longNode)")
//      print("long: \(longNode) lat: \(latNode)")
//      longNodeRef.observeEventType(.Value) { (snapshot) in
//        andDoThisWithIt(self.getPokemonAndTheirLocationFromSnapshot(snapshot))
//      }
//    }

  }
  func longLatToInteger(longLat: Double) -> Int {
    return Int(Double(round(10*longLat)/10)*10)
  }

  private func getPokemonAndTheirLocationFromSnapshot(snapshot: FIRDataSnapshot) -> [PokemonLocation]? {
    guard let response = snapshot.value where !(response is NSNull) else {return nil}
    var result = [PokemonLocation]()
    let snapDict = response as! [String:AnyObject]
    for pokemonsLocations in snapDict.values {
      var pokemonsLocations = pokemonsLocations as! [String:AnyObject]
      let pokemon = PokemonLocation(pokemonId: pokemonsLocations["pokemonId"] as! Int, location: (pokemonsLocations["latitude"] as! Double, pokemonsLocations["longitude"] as! Double))
      result.append(pokemon)
    }

    return result
  }
  func postPokemonLocation(pokemon: Pokemon, location: CLLocation, onError: ((String) -> ())?) {
    if let user = UserManager.instance.user {
      self.postPokemonLocation(pokemon, location: location, uid: user.uid, onError: onError)
    } else {
      if let onError = onError {
        onError("User not logged in")
      }
    }
  }
  func postPokemonLocation(pokemon: Pokemon, location: CLLocation, uid: String, onError: ((String) -> ())?) {
    let payload = location.toAnyObject(pokemon, uid: uid)
    let submission = Submission(payload: payload as! [String : AnyObject], pokemon: pokemon, location: location)
    if let lastSubmited = lastSubmited where twoPayloadsAreTooMuchAlike(submission, second: lastSubmited, onError: onError) {
      return
    }
    //if let lastSubmited = lastSubmited where lastSubmited["timestamp"] - payload["timestamp"]
    let newLocation = ref.child("locations").childByAutoId()
    let roundLat =  self.longLatToInteger(location.coordinate.latitude)
    let roundLong = self.longLatToInteger(location.coordinate.longitude)
    let latNode = ref.child("latitude").child("\(roundLat)").child("\(roundLong)").childByAutoId()
    newLocation.setValue(payload)
    latNode.setValue(payload)
    self.lastSubmited = submission
    self.numberOfSubmissions += 1
  }

  private func twoPayloadsAreTooMuchAlike(first: Submission, second: Submission, onError: ((String) -> ())?) -> Bool {
    let firstTimeStamp = NSDate(timeIntervalSince1970: first.paylod["timestamp"] as! Double)
    let secondTimeStamp = NSDate(timeIntervalSince1970: second.paylod["timestamp"] as! Double)

    let firstPokemonId = first.paylod["pokemonId"] as! Double
    let secondPokemonId = second.paylod["pokemonId"] as! Double

    let timeSpan = NSCalendar.currentCalendar().components(.Second, fromDate: secondTimeStamp, toDate: firstTimeStamp, options: []).second

    if first.location.distanceFromLocation(second.location) < 10 && self.numberOfSubmissions > 2 {
      if let onError = onError {
        onError("You have submitted three pokemons from the same spot")
      }
      print("less than 10 meters apart for 3 submission")
      return true
    }

    if firstPokemonId == secondPokemonId && timeSpan < 120 {
      if let onError = onError {
        onError("You submitted this pokemon less than 30 seconds ago")
      }
      print("less than 30 second apart for same pokemon")
      return true
    }

    if self.numberOfSubmissions > 2 && timeSpan < 3 {
      if let onError = onError {
        onError("You are doing this too many times")
      }
      print("less than 3 second apart after 3 submission ")
      return true
    }

    if self.numberOfSubmissions > 5 && timeSpan < 60 {
      if let onError = onError {
        onError("You are doing this too many times")
      }
      print("more than 5 in a minute")
      return true
    }

    if self.numberOfSubmissions > 8 && timeSpan < 180 {
      if let onError = onError {
        onError("You are doing this too many times")
      }
      print("more than 8 in 2 minutes and 30 seconds")
      return true
    }
    return false
  }

  @objc private func resetCount () {
    print("reseting count \(self.numberOfSubmissions)")
    self.numberOfSubmissions = 0
  }
}

struct PokemonLocation {
  let pokemonId: Int
  let location: (Double, Double)
  init (pokemonId: Int, location: (Double, Double)) {
    self.pokemonId = pokemonId
    self.location = location
  }
}
struct Submission {
  let paylod: [String:AnyObject]
  let pokemon: Pokemon
  let location: CLLocation
  init(payload: [String:AnyObject], pokemon: Pokemon, location: CLLocation) {
    self.paylod = payload
    self.pokemon = pokemon
    self.location = location
  }
}
