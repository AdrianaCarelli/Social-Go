//
//  UserManager.swift
//  Pokemon
//
//  Created by Reza Shirazian on 2016-07-18.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Firebase

class UserManager {
  static var instance = UserManager()
  var user: FIRUser?
  private init() {

  }

}
