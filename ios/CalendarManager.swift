//
//  CalendarManager.swift
//  iosNativeModule
//
//  Created by Derek on 22/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation

@objc(CalendarManager)
class CalendarManager: RCTEventEmitter, AMapLocationManagerDelegate {
  let nativeLocationManager = CLLocationManager()
  let locationManager = AMapLocationManager()
  
  override init(){
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.locationTimeout = 12
    locationManager.reGeocodeTimeout = 12
  }
  
  func checkPermission(){
    if CLLocationManager.locationServicesEnabled() {
      switch CLLocationManager.authorizationStatus() {
      case .restricted, .denied:
        print("No access at the first check.")
      case .notDetermined:
        print("Try to request the access")
        nativeLocationManager.requestWhenInUseAuthorization()
      case .authorizedAlways, .authorizedWhenInUse:
        requestLocation()
      }
    } else {
      print("Location services are not enabled")
    }
  }
  
  func amapLocationManager(_ manager: AMapLocationManager!, didChange status: CLAuthorizationStatus) {
    switch status {
    case .notDetermined, .restricted, .denied:
      print("No Access")
    case .authorizedWhenInUse, .authorizedAlways:
      print("Got access and start to locate")
      requestLocation()
    }
  }
  
  func requestLocation() {
    locationManager.requestLocation( withReGeocode: true, completionBlock: {
      [weak self] (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
      NSLog("Got Location: %@", location!)
      if let error = error {
        let error = error as NSError
        
        if error.code == AMapLocationErrorCode.locateFailed.rawValue {
          //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
          NSLog("定位错误:{\(error.code) - \(error.localizedDescription)};")
          return
        }
        else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
          || error.code == AMapLocationErrorCode.timeOut.rawValue
          || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
          || error.code == AMapLocationErrorCode.badURL.rawValue
          || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
          || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
          
          //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
          NSLog("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
        }
        else {
          //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
        }
      }
      
      if let location = location {
//        NSLog("location:%@", location)
        self!.mSendEvent(body: [
          "lat": location.coordinate.latitude,
          "lon": location.coordinate.longitude,
          "accuracy": location.horizontalAccuracy
        ])
      }
      
      if let reGeocode = reGeocode {
//        NSLog("reGeocode:%@", reGeocode)
        self!.mSendEvent(body: ["Address": reGeocode.formattedAddress])
      }
    })
  }
  
  @objc override func supportedEvents() -> [String]! {
    return ["EventReminder"]
  }
  
  @objc override func constantsToExport() -> [String : Any]! {
    return [
      "x": 1,
      "y": 2,
      "z": "Arbitrary string"
    ]
  }
  @objc func addEvent(_ name: String, location: String, date: NSNumber, callback: RCTResponseSenderBlock) -> Void {
    // Date is ready to use!
    NSLog("%@ %@ %@", name, location, date)
    let ret:[String:Any] = ["name": name, "location":location, "date": date]
    callback([ret])
    mSendEvent(body: ret)
    checkPermission()
  }
  
  func mSendEvent(body response: [String: Any]) {
    self.sendEvent(withName: "EventReminder", body: response)
  }
  
  
}
