//
//  PokemonNavigationController.swift
//  Pokemon
//
//  Created by Reza Shirazian on 2016-07-18.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import UIKit

class PokemonNavigationController: UINavigationController {

  override func viewDidLoad() {
    self.navigationItem.title = "Social Go!"
    self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.darkGrayColor()]
    super.viewDidLoad()
    ToastManager.instance.subscribeToToasts(self)

  }
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    ToastManager.instance.unsubscibeToToasts(self)
  }

}
