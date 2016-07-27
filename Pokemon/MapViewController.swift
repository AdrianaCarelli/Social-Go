//
//  MapViewController.swift
//  Pokemon
//
//  Created by Reza Shirazian on 2016-07-16.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import UIKit
import GoogleMaps
import Toast_Swift

class MapViewController: UIViewController {

  var mapView: GMSMapView?
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  override func viewDidAppear(animated: Bool) {
    self.delay(5.0) {
      self.view.hideToastActivity()
    }
    self.view.makeToastActivity(.Center)
    LocationManager.instance.subscribeToUserLocation() { (userLocation) in
      let camera = GMSCameraPosition.cameraWithLatitude(userLocation.coordinate.latitude,
        longitude: userLocation.coordinate.longitude, zoom: 15)
      self.mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
      self.mapView!.myLocationEnabled = true
      self.view = self.mapView
      self.addCloseByPokemonsToTheMap(userLocation)
      self.view.hideToastActivity()
      self.navigationItem.title = "Nearby Pokemons"
    }
  }
  override func viewWillDisappear(animated: Bool) {
    self.view.hideToastActivity()
    LocationManager.instance.removeLastListener()
  }

  private func addCloseByPokemonsToTheMap(userLocation: CLLocation) {
    ComsManager.instance.getPokemonsBy(userLocation) { (pokemons) in
      if let pokemons = pokemons {
        for pokemon in pokemons {
          let marker = GMSMarker()
          marker.position = CLLocationCoordinate2DMake(pokemon.location.0, pokemon.location.1)
          marker.title = DataManager.instance.getPokemonFromId(pokemon.pokemonId)?.name
          marker.icon = UIImage(named:  Util.idToImageName(pokemon.pokemonId))
          //marker.icon = self.scaleImage(marker.icon!, toSize: CGSizeMake(marker.icon!.size.width * 0.15, marker.icon!.size.height * 0.15))
          if let mapView = self.mapView {
            marker.map = mapView
          }
        }
      }
    }
  }

  func scaleImage(image: UIImage, toSize newSize: CGSize) -> (UIImage) {
    let newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height))
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
    let context = UIGraphicsGetCurrentContext()
    CGContextSetInterpolationQuality(context, .High)
    let flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height)
    CGContextConcatCTM(context, flipVertical)
    CGContextDrawImage(context, newRect, image.CGImage)
    let newImage = UIImage(CGImage: CGBitmapContextCreateImage(context)!)
    UIGraphicsEndImageContext()
    return newImage
  }

  func delay(delay: Double, closure:()->()) {
    dispatch_after(
      dispatch_time(
        DISPATCH_TIME_NOW,
        Int64(delay * Double(NSEC_PER_SEC))
      ),
      dispatch_get_main_queue(), closure)
  }
}
