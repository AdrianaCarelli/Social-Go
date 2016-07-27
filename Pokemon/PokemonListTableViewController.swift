//
//  PokemonListTableViewController.swift
//  Pokemon
//
//  Created by Reza Shirazian on 2016-07-14.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import UIKit
import Firebase

class PokemonListTableViewController: UITableViewController {

  var ref: FIRDatabaseReference!
  var pokemonRef: FIRDatabaseReference!
  var pokemons = [Pokemon]()
  var filteredPokemons = [Pokemon]()
  let searchController = UISearchController(searchResultsController: nil)

  override func viewDidLoad() {
    self.tableView.contentInset = UIEdgeInsetsMake(48,0,0,0)
    self.navigationItem.title = "Pokemons"
    super.viewDidLoad()
    self.view.makeToastActivity(.Center)
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    definesPresentationContext = true
    tableView.tableHeaderView = searchController.searchBar
    DataManager.instance.getPokemons { (pokemons) in
      self.pokemons = pokemons
      self.tableView.reloadData()
      self.view.hideToastActivity()
    }
  }


  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searchController.active && searchController.searchBar.text != "" {
      return filteredPokemons.count
    }
    return pokemons.count
  }

  func filterContentForSearchText(searchText: String, scope: String = "All") {
    filteredPokemons = pokemons.filter { pokemon in
      return pokemon.name.lowercaseString.containsString(searchText.lowercaseString)
    }

    tableView.reloadData()
  }

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("PokemonCell", forIndexPath: indexPath) as! PokemonTableViewCell
    let pokemon = searchController.active && searchController.searchBar.text != "" ? filteredPokemons[indexPath.row] : self.pokemons[indexPath.row]

    cell.pokemonImage.image = UIImage(named: Util.idToImageName(pokemon.id))
    cell.pokemonNameLabel.text = pokemon.name
    cell.pokemon = pokemon
    return cell
  }
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }

  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)

  }
}

extension PokemonListTableViewController: UISearchResultsUpdating {
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    filterContentForSearchText(searchController.searchBar.text!)
  }
}
