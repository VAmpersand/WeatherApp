//
//  LocationProvider.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 23.06.2024.
//

import UIKit
import CoreLocation

protocol LocationProviderDelegate: AnyObject {
    func setCurrentLocation(_ location: Coordinate?)
    func showAlert(_ alertController: UIAlertController)
}

final class LocationProvider: NSObject {
    private let locationManager = CLLocationManager()

    weak var delegate: LocationProviderDelegate?

    private var carrentLocation: Coordinate?

    override init() {
        super.init()

        locationManager.delegate = self
        checkAuthporization()
    }

    private func checkAuthporization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .denied, .restricted:
            showMoveSettingsAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        @unknown default:
            break
        }
    }

    private func showMoveSettingsAlert() {
        let alertController = UIAlertController(
            title: "Location not available",
            message: "Please turn on location on app settings",
            preferredStyle: .alert)

        alertController.addAction(
            UIAlertAction(
                title: "Ok",
                style: .default) { _ in
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                }
        )

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        delegate?.showAlert(alertController)
    }

    func getCurrentLocation() {
        checkAuthporization()
    }
}

extension LocationProvider: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthporization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else { return }

        carrentLocation = Coordinate(lat: coordinate.latitude, lon: coordinate.longitude)
        delegate?.setCurrentLocation(carrentLocation)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
}
