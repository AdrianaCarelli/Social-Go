//
//  PokemonTabBarController.swift
//  Pokemon
//
//  Created by Reza Shirazian on 2016-07-19.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import UIKit


class PokemonTabBarController: UITabBarController {


  var tabCount = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.title = "Social Go!"
    let view1: UIViewController! = storyboard?.instantiateViewControllerWithIdentifier("BroadcastView")
    let view2: UIViewController! = storyboard?.instantiateViewControllerWithIdentifier("MapView")
    let view3: UIViewController! = storyboard?.instantiateViewControllerWithIdentifier("ChatView")
    let view4: UIViewController! = storyboard?.instantiateViewControllerWithIdentifier("HelpView")


    let views = [view2!, view1!, view3!, view4!]

    self.setViewControllers(views, animated: true)

    view1.tabBarItem = UITabBarItem(title: "Pokemons", image: UIImage(named: "pokemon")!, tag: 1)
    view2.tabBarItem = UITabBarItem(title: "Radar", image: UIImage(named: "map-location")!, tag: 2)
    view3.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(named: "chat")!, tag: 3)
    view4.tabBarItem = UITabBarItem(title: "Help", image: UIImage(named: "help")!, tag: 4)

  }
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    print("hi")
  }
  override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
    switch item.tag {
    case 3:
      self.performSegueWithIdentifier("showChat", sender: self)
      self.tabBar.hidden = true
    case 2:
      self.navigationItem.title = "Nearby Pokemons"
    case 1:
      self.navigationItem.title = "Social Go!"
    case 4:
      self.navigationItem.title = "Help"
    default:
      return
    }
//    if item.tag == 3 {
//
//    } else {
//      self.tabBar.hidden = false
//    }
  }
}
