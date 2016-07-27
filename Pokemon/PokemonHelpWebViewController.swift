//
//  PokemonHelpTableViewController.swift
//  Pokemon
//
//  Created by Reza Shirazian on 2016-07-19.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import UIKit
import Firebase


class PokemonHelpWebViewController: UIViewController {
  
  override func viewDidLoad() {
   
    let web = self.view.viewWithTag(1) as! UIWebView
    web.loadRequest(NSURLRequest(URL: NSURL(string: "https://radargo.wordpress.com/radar-go/")!))

  }

}
