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
    @IBOutlet weak var aUUIDLabel: UILabel!
    @IBOutlet weak var aMajorLabel: UILabel!
    @IBOutlet weak var aMinorLabel: UILabel!
    @IBOutlet weak var aProximity: UILabel!
    
    @IBOutlet weak var bUUIDLabel: UILabel!
    @IBOutlet weak var bMajorLabel: UILabel!
    @IBOutlet weak var bMinorLabel: UILabel!
    @IBOutlet weak var bProximity: UILabel!
    
    @IBOutlet weak var cUUIDLabel: UILabel!
    @IBOutlet weak var cMajorLabel: UILabel!
    @IBOutlet weak var cMinorLabel: UILabel!
    @IBOutlet weak var cProximity: UILabel!
    
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
        
        let abeacon = beacons.first { beacon in
            guard let uuid: UUID = .init(uuidString: "fda50693-a4e2-4fb1-afcf-c6eb07647824"), beacon.uuid == uuid else { return false }
            
            return true
        }
        
        let bbeacon = beacons.first { beacon in
            guard (beacon.major == 10004) && (beacon.minor == 54480) else { return false }
            
            return true
        }
        
        let cbeacon = beacons.first { beacon in
            guard (beacon.major == 1004) && (beacon.minor == 8829) else { return false }
            
            return true
        }
        
        if let abeacon, let bbeacon, let cbeacon {
            self.updateAUI(with: abeacon)
            self.updateBUI(with: bbeacon)
            self.updateCUI(with: cbeacon)
            
        } else if let abeacon, let bbeacon {
            self.updateAUI(with: abeacon)
            self.updateBUI(with: bbeacon)
            
        } else if let bbeacon, let cbeacon {
            self.updateBUI(with: bbeacon)
            self.updateCUI(with: cbeacon)
            
        } else if let abeacon {
            self.updateAUI(with: abeacon)
            
        } else if let bbeacon {
            self.updateBUI(with: bbeacon)
            
        } else if let cbeacon {
            self.updateCUI(with: cbeacon)
        }
    }
}

private extension ViewController {
    
    func configureProperties() {
        self.locationManger = .init()
        self.locationManger?.delegate = self
        self.locationManger?.requestAlwaysAuthorization()
        
        self.locationManger?.startUpdatingLocation()
        self.locationManger?.allowsBackgroundLocationUpdates = true
        self.locationManger?.pausesLocationUpdatesAutomatically = false
    }
    
    func checkUserLocationAuthorization() {
        guard CLLocationManager.locationServicesEnabled() else {
            // OS의 위치 서비스 비활성화일 때 (시스템 설정창으로 넘어가는 구문 추가해주면 좋음)
            return
        }
        
        
    }
    
    func startScanning() {
        guard let uuid: UUID = .init(uuidString: "fda50693-a4e2-4fb1-afcf-c6eb07647825"), let anotherUUID: UUID = .init(uuidString: "fda50693-a4e2-4fb1-afcf-c6eb07647824") else { return }
//        let major: UInt16 = 10004
//        let minor: UInt16 = 54480
//
//        let beaconRegion: CLBeaconRegion = .init(uuid: uuid, major: major, minor: minor, identifier: "MyBeacon")
//        let beaconIdentityConstraint: CLBeaconIdentityConstraint = .init(uuid: uuid, major: major, minor: minor)
        
        let beaconRegion: CLBeaconRegion = .init(uuid: uuid, identifier: "MyBeacon")
        let beaconIdentityConstraint: CLBeaconIdentityConstraint = .init(uuid: uuid)
        
        let anotherBeaconRegion: CLBeaconRegion = .init(uuid: anotherUUID, identifier: "YourBeacon")
        let anotherBeaconIdentityConstraint: CLBeaconIdentityConstraint = .init(uuid: anotherUUID)
        
        self.locationManger?.startMonitoring(for: beaconRegion)
        self.locationManger?.startRangingBeacons(satisfying: beaconIdentityConstraint)
        
        self.locationManger?.startMonitoring(for: anotherBeaconRegion)
        self.locationManger?.startRangingBeacons(satisfying: anotherBeaconIdentityConstraint)
    }
    
    func updateAUI(with beacon: CLBeacon) {
        self.aUUIDLabel.text = "\(beacon.uuid)"
        self.aMajorLabel.text = "\(beacon.major)"
        self.aMinorLabel.text = "\(beacon.minor)"
        
        switch beacon.proximity {
        case .unknown:
            self.aProximity.text = "unknown"
            
        case .immediate:
            self.aProximity.text = "immediate"
            
        case .near:
            self.aProximity.text = "near"
            
        case .far:
            self.aProximity.text = "far"
            
        @unknown default:
            break
        }
    }
    
    func updateBUI(with beacon: CLBeacon) {
        self.bUUIDLabel.text = "\(beacon.uuid)"
        self.bMajorLabel.text = "\(beacon.major)"
        self.bMinorLabel.text = "\(beacon.minor)"
        
        switch beacon.proximity {
        case .unknown:
            self.bProximity.text = "unknown"
            
        case .immediate:
            self.bProximity.text = "immediate"
            
        case .near:
            self.bProximity.text = "near"
            
        case .far:
            self.bProximity.text = "far"
            
        @unknown default:
            break
        }
    }
    
    func updateCUI(with beacon: CLBeacon) {
        self.cUUIDLabel.text = "\(beacon.uuid)"
        self.cMajorLabel.text = "\(beacon.major)"
        self.cMinorLabel.text = "\(beacon.minor)"
        
        switch beacon.proximity {
        case .unknown:
            self.cProximity.text = "unknown"
            
        case .immediate:
            self.cProximity.text = "immediate"
            
        case .near:
            self.cProximity.text = "near"
            
        case .far:
            self.cProximity.text = "far"
            
        @unknown default:
            break
        }
    }
}
