//
//  GPSViewController.swift
//  BeaconConnect
//
//  Created by Zeto on 2023/01/30.
//

import UIKit
import CoreLocation

final class GPSViewController: UIViewController {
    
    private var locationManger: CLLocationManager = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureProperties()
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
            let region = self.makeCLCircularRegion()
            
            self.locationManger.startUpdatingLocation()
            self.locationManger.startMonitoring(for: region)
            
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
            
        case .inside:
            print("inside")
            
        case .outside:
            print("outside")
        }
    }
}

private extension GPSViewController {
    
    func configureProperties() {
        self.locationManger.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManger.delegate = self
        
        self.locationManger.allowsBackgroundLocationUpdates = true
        self.locationManger.pausesLocationUpdatesAutomatically = false
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
    func makeCLCircularRegion() -> CLCircularRegion {
        let location: CLLocationCoordinate2D = .init(latitude: 37.40228169999993, longitude: 126.96682999999975)
        let region: CLCircularRegion = .init(center: location, radius: 500.0, identifier: "Summit-M")
        
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        return region
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
