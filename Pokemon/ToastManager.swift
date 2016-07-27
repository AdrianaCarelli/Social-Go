//
//  ToastManager.swift
//  Pokemon
//
//  Created by Reza Shirazian on 2016-07-18.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import UIKit
import Toast_Swift
class ToastManager {
  static var instance = ToastManager()
  private(set) var subscribers = Set<UIViewController>()
  private init () {}

  func subscribeToToasts(viewController: UIViewController) {
    subscribers.insert(viewController)
  }

  func unsubscibeToToasts(viewController: UIViewController) {
    subscribers.remove(viewController)
  }

  func publishToast(toast: String) {
    for subscriber in subscribers {
      subscriber.toastSent(toast)
    }
  }
}

extension UIViewController {
  func toastSent(toast: String) {
    self.view.makeToast(toast, duration: 3.0, position: .Center)
  }
}
