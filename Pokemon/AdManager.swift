//
//  AdManager.swift
//  Pokemon
//
//  Created by Reza Shirazian on 2016-07-19.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//
//
//import UIKit
//import GoogleMobileAds
//
//class AdManager {
//  var ad: GADInterstitial!
//  private init() {}
//  
//  private func createAndLoadInterstitial() {
//    ad = GADInterstitial(adUnitID: "ca-app-pub-8157682664456759/9911481021")
//    let request = GADRequest()
//    // Request test ads on devices you specify. Your test device ID is printed to the console when
//    // an ad request is made.
//    request.testDevices = [ kGADSimulatorID, "b3848de48f2488b1b5692b4b14d0ae97" ]
//    ad.loadRequest(request)
//  }
//  
//}