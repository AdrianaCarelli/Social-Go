//
//  Pokemon.swift
//  Pokemon
//
//  Created by Reza Shirazian on 2016-07-13.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation
import Firebase

struct Pokemon {
  let key: String
  let id: Int
  let commonFactor: Int
  let name: String
  //var pokemonType: [PokemonType]

  init(key: String, pokemon: [String:AnyObject]) {
    self.key = key
    self.name = pokemon["name"] as! String
    self.id = pokemon["id"] as! Int
    self.commonFactor = pokemon["common"] as! Int
//    let groups = pokemon["groups"] as! [String:Bool]
//    self.pokemonType = [PokemonType]()
//    for (key, _) in groups {
//      self.pokemonType.append(PokemonType(rawValue: key.capitalizedString)!)
//    }
  }
}

enum PokemonType: String {
  case Grass, Poison, Fire, Water
}
