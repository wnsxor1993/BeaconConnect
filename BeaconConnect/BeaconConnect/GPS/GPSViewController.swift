//
//  GPSViewController.swift
//  BeaconConnect
//
//  Created by Zeto on 2023/01/30.
//

import UIKit
import CoreLocation

final class GPSViewController: UIViewController {
    
    @IBOutlet weak var buttonView: UIView!
    
    private var locationManger: CLLocationManager = .init()
    private var clCircularRegion: CLCircularRegion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureLocationManager()
        configureCLCircularRegion()
        self.configureAction()
    }
    
    override func viewWillLayoutSubviews() {
        self.buttonView.layer.cornerRadius = 150
    }
}

extension GPSViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            self.locationManger.requestAlwaysAuthorization()
            
        case .restricted, .denied:
            self.showRequestLocationServiceAlert()
            
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManger.startUpdatingLocation()
            
            if let clCircularRegion {
                self.locationManger.startMonitoring(for: clCircularRegion)
                
            } else {
                NSLog("None Region")
            }
            
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        self.fetchDetailedAddress(location)
        
        print(location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print(region.identifier)
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        switch state {
        case .unknown:
            print("unknown")
            self.buttonView.isUserInteractionEnabled = false
            self.buttonView.backgroundColor = .gray
            
        case .inside:
            print("inside")
            self.buttonView.isUserInteractionEnabled = true
            self.buttonView.backgroundColor = .cyan
            
        case .outside:
            print("outside")
            self.buttonView.isUserInteractionEnabled = false
            self.buttonView.backgroundColor = .gray
        }
    }
}

private extension GPSViewController {
    
    func configureLocationManager() {
        self.locationManger.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManger.delegate = self
        
        self.locationManger.allowsBackgroundLocationUpdates = true
        self.locationManger.pausesLocationUpdatesAutomatically = false
    }
    
    func configureAction() {
        let tapGesture: UITapGestureRecognizer = .init(target: self, action: #selector(printButtonAction))
        
        self.buttonView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func printButtonAction() {
        print("출근했습니다")
        
        self.locationManger.stopUpdatingLocation()
        
        if let clCircularRegion {
            self.locationManger.stopMonitoring(for: clCircularRegion)
            
        } else {
            NSLog("None Region")
        }
        
        self.buttonView.isUserInteractionEnabled = false
        self.buttonView.backgroundColor = .gray
    }
    
    // 주소 가져오기
    func fetchDetailedAddress(_ location: CLLocation) {
        let geocoder: CLGeocoder = .init()
        var address: String = ""
        
        geocoder.reverseGeocodeLocation(location) { (placeMarks, error) in
            if let error {
                NSLog(error.localizedDescription)
                
            } else {
                guard let placeMark = placeMarks?.first else { return }
                
                if let administrativeArea = placeMark.administrativeArea {
                    address += administrativeArea
                }
                
                if let locality = placeMark.locality {
                    address += " \(locality)"
                }
                
                if let thoroughfare = placeMark.thoroughfare {
                    address += " \(thoroughfare)"
                }
                
                if let subThoroughfare = placeMark.subThoroughfare {
                    address += " \(subThoroughfare)"
                }
                
                print(address)
            }
        }
    }
    
    // 지오펜싱 범위 설정 및 CLCircularRegion 인스턴스 반환
    func configureCLCircularRegion() {
        let location: CLLocationCoordinate2D = .init(latitude: 37.40228169999993, longitude: 126.96682999999975)
        let region: CLCircularRegion = .init(center: location, radius: 200.0, identifier: "Summit-M")
        
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        self.clCircularRegion = region
    }
    
    func showRequestLocationServiceAlert() {
        let alertVC: UIAlertController = .init(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let move: UIAlertAction = .init(title: "설정으로 이동", style: .default) { _ in
            guard let appSetting: URL = .init(string: UIApplication.openSettingsURLString) else { return }
            
            UIApplication.shared.open(appSetting)
        }
        
        let cancel: UIAlertAction = .init(title: "확인", style: .default) { _ in
            alertVC.dismiss(animated: true)
        }
        
        alertVC.addAction(move)
        alertVC.addAction(cancel)
        
        self.present(alertVC, animated: true)
    }
}
