//
//  PokemonLoadingViewController.swift
//  Pokemon
//
//  Created by Reza Shirazian on 2016-07-17.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import UIKit
import Firebase


class PokemonLoadingViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
      if let user = user {
        UserManager.instance.user = user
        let storybboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storybboard.instantiateViewControllerWithIdentifier("HomeView")
        self.presentViewController(viewController, animated: true, completion: nil)
      } else {
        FIRAuth.auth()?.signInAnonymouslyWithCompletion() { (user, error) in
          if let user = user {
            UserManager.instance.user = user
            let storybboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storybboard.instantiateViewControllerWithIdentifier("HomeView")
            self.presentViewController(viewController, animated: true, completion: nil)
          }
        }
      }
    }
  }

}
