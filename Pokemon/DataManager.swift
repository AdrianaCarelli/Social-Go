//
//  DataManager.swift
//  Pokemon
//
//  Created by Reza Shirazian on 2016-07-17.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation
import Firebase

class DataManager {

  static var instance = DataManager()
  var ref: FIRDatabaseReference
  private(set) var pokemons: [Pokemon]?


  private init() {
    self.ref = FIRDatabase.database().reference()
    loadPokemons()
  }

  func getPokemons(callback: ([Pokemon]) -> ()) {
       if let pokemons = pokemons {
      callback(pokemons)
    } else {
      loadPokemons(callback)
    }
  }

  private func loadPokemons () {
    loadPokemons(nil)
  }

  private func loadPokemons (callback: (([Pokemon]) -> ())?) {
    let pokemonRef = ref.child("/pokemons")

    pokemonRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
      self.pokemons = [Pokemon]()
      let snapshotDic = snapshot.value! as! [String: AnyObject]
      for (key, snapshot) in snapshotDic {
        print(snapshot)
        print(snapshot as! [String: AnyObject])
        let pokemon = Pokemon(key: key, pokemon: snapshot as! [String: AnyObject])
        self.pokemons!.append(pokemon)
      }
      self.pokemons!.sortInPlace({ (first, second) -> Bool in
        first.commonFactor > second.commonFactor
      })
      if let callback = callback {
        callback(self.pokemons!)
      }
      print(snapshotDic)
    }) { (error) in
      print(error.description)
    }
  }

  func getPokemonFromId(id: Int) -> Pokemon? {
    if let pokemons = pokemons {
      var result = pokemons.filter {$0.id == id}
      return result[0]
    }
    return nil
  }
}
