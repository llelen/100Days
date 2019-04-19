//VERS2
//  ViewController.swift
//  22_projecct
//  Created by Admin on 18/04/2019.
//  Copyright © 2019 Admin. All rights reserved.
//https://blog.matchmore.io/everything-you-need-to-know-about-beacons/


import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let circle = UIView()
    let side:CGFloat = 200
    var regions = [CLBeaconRegion]()
    var boolForAlert = true
    var boolForAlertUnknown = true
    var locationManager: CLLocationManager?
    
    @IBOutlet weak var distanceReading: UILabel!
    @IBOutlet weak var BEACON: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let uuid2 = UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!
        
        //Put minor and major in Locate Beacon app the same as here
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "FirstAppleAirLocate")
        let beaconRegion2 = CLBeaconRegion(proximityUUID: uuid2, major: 124, minor: 457, identifier: "SecondAppleAirLocate")
        
        regions = [beaconRegion, beaconRegion2]
        
        setCircle(side:side, color: .green)
        view.addSubview(circle)
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
                if CLLocationManager.isRangingAvailable(){
                    startScanning()
                    
                }
            }
        }
    }
    
    
    func startScanning(){
        
        for region in regions{
            locationManager?.startMonitoring(for: region)
            locationManager?.startRangingBeacons(in: region)
        }
    }
    
    
    func updateDistance(distance:CLProximity){
        
        UIView.animate(withDuration: 1){[weak self] in
            switch distance{
                
            case .far:
                self?.view.backgroundColor = UIColor.blue
                self?.distanceReading.text = "FAR"
                self?.setCircle(side:self!.side, color: .green)
                
                
            case .near:
                self?.view.backgroundColor = UIColor.orange
                self?.distanceReading.text = "NEAR"
                self?.setCircle(side:self!.side/2, color: .green)
                
                
            case .immediate:
                self?.view.backgroundColor = UIColor.red
                self?.distanceReading.text = "RIGHT HERE"
                self?.setCircle(side:self!.side/4, color: .green)
                
                
            default:
                self?.view.backgroundColor = UIColor.gray
                self?.distanceReading.text = "UNKNOWN"
                self?.setCircle(side:self!.side, color: .white)
                
                
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        if let beacon = beacons.first{
            
            //Alert
            if boolForAlert{
                let alert = UIAlertController(title: "Found A Beacon!", message: nil, preferredStyle: .alert)
                let btn = UIAlertAction(title: "OK", style: .default){[weak self] action in
                    self?.boolForAlert = false
                }
                alert.addAction(btn)
                present(alert,animated: true)}
            
            
            //Update the lables text and the background color depending which beacon was found and the distance to it.
            if beacon.major == 123{
                BEACON.text = "APPLE AIRLOCATE"
                updateDistance(distance: beacon.proximity)
            }
            else if beacon.major == 124{
                BEACON.text = "RADIUS NETOWRKS"
                updateDistance(distance: beacon.proximity)
            }
        }
        //if there are no beacons and beacons array is empty
        else{
            
            updateDistance(distance: .unknown)
            
            if boolForAlertUnknown{
                let alert = UIAlertController(title: "No Beacons Around, Sorry!", message: nil, preferredStyle: .alert)
                let btn = UIAlertAction(title: "OK", style: .default){[weak self] action in
                    self?.boolForAlertUnknown = false
                }
                alert.addAction(btn)
                present(alert,animated: true)}
        }
    }
    
    
    
    func setCircle(side:CGFloat, color: UIColor){
        
        circle.frame.size = CGSize(width: side, height: side)
        circle.backgroundColor = color
        circle.layer.cornerRadius = side/2
        circle.layer.borderWidth = 5
        circle.layer.borderColor = UIColor.red.cgColor
        circle.center.x = view.center.x
        circle.center.y = view.center.y * 0.5
    }
}





/*
 changeall in plist if ipone does note ask for permition.
 Privacy - Location When In Use Usage Description
 Privacy - Location Usage Description
 Privacy - Location Always Usage Description
 Privacy - Location Always and When In Use Usage Description
 */
