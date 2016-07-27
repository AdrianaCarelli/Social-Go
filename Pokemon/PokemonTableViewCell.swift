//
//  PokemonTableViewCell.swift
//  Pokemon
//
//  Created by Reza Shirazian on 2016-07-14.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import UIKit
import Toast_Swift

class PokemonTableViewCell: UITableViewCell {
  var pokemon: Pokemon?

  @IBOutlet weak var pokemonBroadcastTableButton: UIButton!
  @IBOutlet weak var pokemonNameLabel: UILabel!
  @IBOutlet weak var pokemonImage: UIImageView!

  @IBAction func broadcastClicked(sender: AnyObject) {
    //UIViewController parent = (sender as! UIButton)
    LocationManager.instance.getUserLocation { (location) in
      ComsManager.instance.postPokemonLocation(self.pokemon!, location: location) { (error) in
        ToastManager.instance.publishToast(error)
      }
    }
  }
}
