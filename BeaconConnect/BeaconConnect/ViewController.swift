//
//  ViewController.swift
//  BeaconConnect
//
//  Created by Zeto on 2023/01/25.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var beaconCount: UILabel!
    @IBOutlet weak var uuidLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var minorLabel: UILabel!
    @IBOutlet weak var proximity: UILabel!
    
    private var locationManger: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureProperties()
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            break

        case .authorizedAlways:
            guard CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self), CLLocationManager.isRangingAvailable() else { break }
            
            self.startScanning()
            
        case .authorizedWhenInUse:
            break
            
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        self.beaconCount.text = "Beacon: \(beacons.count)"
        
        guard let beacon = beacons.first else { return }
        
        self.uuidLabel.text = "\(beacon.uuid)"
        self.majorLabel.text = "\(beacon.major)"
        self.minorLabel.text = "\(beacon.minor)"
        self.proximity.text = String(beacon.proximity.rawValue)
    }
}

private extension ViewController {
    
    func configureProperties() {
        self.locationManger = .init()
        self.locationManger?.delegate = self
        self.locationManger?.requestAlwaysAuthorization()
        
        self.locationManger?.startUpdatingLocation()
//        self.locationManger?.allowsBackgroundLocationUpdates = true
//        self.locationManger?.pausesLocationUpdatesAutomatically = false
    }
    
    func startScanning() {
        guard let uuid: UUID = .init(uuidString: "fda50693-a4e2-4fb1-afcf-c6eb07647825") else { return }
//        let major: UInt16 = 10004
//        let minor: UInt16 = 54480
//
//        let beaconRegion: CLBeaconRegion = .init(uuid: uuid, major: major, minor: minor, identifier: "MyBeacon")
//        let beaconIdentityConstraint: CLBeaconIdentityConstraint = .init(uuid: uuid, major: major, minor: minor)
        
        let beaconRegion: CLBeaconRegion = .init(uuid: uuid, identifier: "MyBeacon")
        let beaconIdentityConstraint: CLBeaconIdentityConstraint = .init(uuid: uuid)
        
        self.locationManger?.startMonitoring(for: beaconRegion)
        self.locationManger?.startRangingBeacons(satisfying: beaconIdentityConstraint)
    }
}
