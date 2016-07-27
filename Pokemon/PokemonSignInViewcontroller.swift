//
//  PokemonSignInViewcontroller.swift
//  Pokemon
//
//  Created by Reza Shirazian on 2016-07-17.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import UIKit
import Firebase
class PokemonSigninViewController: UIViewController {

  @IBAction func signin(sender: AnyObject) {
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
