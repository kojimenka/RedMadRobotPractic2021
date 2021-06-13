//
//  SetGeopositionVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 12.06.2021.
//

import UIKit

import MapKit

import CoreLocation

struct Coordinates {
    let latitude: Double
    let longitude: Double
}

protocol SetGeopositionVCDelegate: AnyObject {
    func userSetCoordinates(_ coordinated: Coordinates)
}

final class SetGeopositionVC: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var currentPositionLabel: UILabel!
    
    // MARK: - Private Properties
    
    weak private var delegate: SetGeopositionVCDelegate?
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
    // MARK: - Init
    
    init(delegate: SetGeopositionVCDelegate?) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
    }
    
    // MARK: - IBActions
    
    @IBAction private func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction private func useCurrentLocationAction(_ sender: Any) {
        let coordinates = Coordinates(
            latitude: currentLocation?.coordinate.latitude ?? 0.0,
            longitude: currentLocation?.coordinate.longitude ?? 0.0
        )
        
        delegate?.userSetCoordinates(coordinates)
        self.dismiss(animated: true)
    }
    
    // MARK: - Private Properties
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationAuthorization()
            setupLocationManager()
        }
    }
    
    private func locationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            setupMapView()
        @unknown default:
            break
        }
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func setupMapView() {
        mapView.showsUserLocation = true
        mapView.mapType = .hybrid
        centerUserLocation()
    }
    
    private func centerUserLocation() {
        let mapScale: Double = 10000.0
        if let location = locationManager.location?.coordinate {
            
            let region = MKCoordinateRegion(
                center: location,
                latitudinalMeters: mapScale,
                longitudinalMeters: mapScale
            )
            
            mapView.setRegion(region, animated: true)
        }
    }
    
}

// MARK: - CLLocationManager Delegate

extension SetGeopositionVC: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationAuthorization()
    }
        
}

// MARK: - MapKit Delegate

extension SetGeopositionVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        currentLocation = CLLocation(
            latitude: mapView.centerCoordinate.latitude,
            longitude: mapView.centerCoordinate.longitude
        )
        
        currentLocation?.fetchCityAndCountry { [weak self] city, country, error in
            guard let self = self,
                  let city = city,
                  let country = country,
                  error == nil else { return }
            
            let addressText = "\(country), \(city)"
            
            UIView.AnimationTransition.transitionChangeText(
                label: self.currentPositionLabel,
                text: addressText
            )
        }
    }
    
}

// MARK: -

extension CLLocation {
    
    func fetchCityAndCountry(
        completion: @escaping (_ city: String?, _ country: String?, _ error: Error?) -> Void
    ) {
        CLGeocoder().reverseGeocodeLocation(self) {
            completion($0?.first?.locality, $0?.first?.country, $1)
        }
    }
    
}
