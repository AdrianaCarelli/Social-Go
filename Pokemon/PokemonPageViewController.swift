//
//  PokemonPageViewController.swift
//  Pokemon
//
//  Created by Reza Shirazian on 2016-07-17.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//


import UIKit

class PokemonPageViewController: UIPageViewController,
                                 UIPageViewControllerDataSource,
                                 UIPageViewControllerDelegate {
  var pages = [UIViewController]()
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    self.dataSource = self

    let page1: UIViewController! = storyboard?.instantiateViewControllerWithIdentifier("IntroPage1")
    let page2: UIViewController! = storyboard?.instantiateViewControllerWithIdentifier("IntroPage2")
    let page3: UIViewController! = storyboard?.instantiateViewControllerWithIdentifier("IntroPage3")
    let page4: UIViewController! = storyboard?.instantiateViewControllerWithIdentifier("IntroPage4")

    pages.append(page1)
    pages.append(page2)
    pages.append(page3)
    pages.append(page4)

    setViewControllers([page1], direction: .Forward, animated: true, completion: nil)

  }

  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    let currentIndex = pages.indexOf(viewController)!
    let previousIndex = currentIndex - 1
    if previousIndex < 0 {
      return nil
    } else {
     return pages[previousIndex]
    }
  }

  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    let currentIndex = pages.indexOf(viewController)!
    let nextIndex = currentIndex + 1
    if nextIndex >= pages.count {
      return nil
    } else {
      return pages[nextIndex]
    }
  }

  func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
    return pages.count
  }

  func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
    return 0
  }
}
