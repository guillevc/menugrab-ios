//
//  UserPermissionsService.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 29/03/2021.
//

import SwiftUI
import CoreLocation

enum Permission {
    case location
    
    enum Status: Equatable {
        case unknown
        case notRequested
        case granted
        case denied
    }
}

protocol UserPermissionsService: class {
    func resolveStatus(for permission: Permission)
    func request(permission: Permission)
}

class UserPermissionsServiceImpl: NSObject, UserPermissionsService {
    let appState: Store<AppState>
    let locationManager = CLLocationManager()
    
    init(appState: Store<AppState>) {
        self.appState = appState
    }
    
    func resolveStatus(for permission: Permission) {
        let keyPath = AppState.permissionKeyPath(for: permission)
        let currentStatus = appState[keyPath]
        guard currentStatus == .unknown else { return }
        switch permission {
        case .location:
            appState[keyPath] = locationPermissionStatus
        }
    }
    
    func request(permission: Permission) {
        let keyPath = AppState.permissionKeyPath(for: permission)
        let currentStatus = appState[keyPath]
        guard currentStatus != .denied else {
            // TODO: open app settings
            return
        }
        switch permission {
        case .location:
            requestLocationPermission()
        }
    }
}

// MARK: - Location

extension UserPermissionsServiceImpl: CLLocationManagerDelegate {
    private var locationPermissionStatus: Permission.Status  {
        locationManager.authorizationStatus.map
    }
    
    private func requestLocationPermission() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.startMonitoringSignificantLocationChanges()
    }
}

// MARK: - CLLocationManagerDelegate

extension CLAuthorizationStatus {
    var map: Permission.Status {
        switch self {
        case .authorizedAlways, .authorizedWhenInUse: return .granted
        case .denied: return .denied
        case .notDetermined: return .notRequested
        case .restricted: return .unknown
        @unknown default: return .notRequested
        }
    }
}

extension UserPermissionsServiceImpl {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let permission = manager.authorizationStatus.map
        appState[\.permissions.location] = permission
        if permission != .granted {
            appState[\.location] = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let permission = manager.authorizationStatus.map
        appState[\.permissions.location] = permission
        appState[\.location] = permission == .granted ? locations.last : nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error \(error.localizedDescription)")
    }
}

// MARK: - Stub

class UserPermissionsServiceStub: NSObject, UserPermissionsService {
    func resolveStatus(for permission: Permission) { }
    func request(permission: Permission) { }
}
