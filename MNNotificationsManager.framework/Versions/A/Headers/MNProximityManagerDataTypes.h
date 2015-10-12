//
//  MNProximityManagerDataTypes.h
//  MNProximityManager
//
//  Created by Alberto Salas on 07/11/14.
//  Copyright (c) 2014 Mobiquity Networks. All rights reserved.
//

/*!
 *  @enum MNPMAuthorizationStatus
 *
 *  @discussion Represents the current authorization status of the CLLocationManager. See [CLLocationManager CLAuthorizationStatus](https://developer.apple.com/library/ios/documentation/CoreLocation/Reference/CLLocationManagerDelegate_Protocol/CLLocationManagerDelegate/CLLocationManagerDelegate.html).
 *
 *  @since v1.0 and later
 *
 *  @constant MNPMAuthorizationStatusNotDetermined  The user has not yet made a choice regarding whether this application can use location services.
 *  @constant MNPMAuthorizationStatusRestricted     This application is not authorized to use location services. The user cannot change this application’s status, possibly due to active restrictions such as parental controls being in place
 *  @constant MNPMAuthorizationStatusDenied         The user explicitly denied the use of location services for this application or location services are currently disabled in Settings.
 *  @constant MNPMAuthorizationStatusAuthorized     This application is authorized to use location services.
 *
 */
typedef NS_ENUM(NSInteger, MNPMAuthorizationStatus) {
    MNPMAuthorizationStatusNotDetermined,
    MNPMAuthorizationStatusRestricted,
    MNPMAuthorizationStatusDenied,
    MNPMAuthorizationStatusAuthorized NS_ENUM_DEPRECATED_IOS(2_0, 8_0, "Use MNPMAuthorizationStatusAuthorizedAlways"),
    MNPMAuthorizationStatusAuthorizedAlways NS_ENUM_AVAILABLE_IOS(8_0) = MNPMAuthorizationStatusAuthorized,
    MNPMAuthorizationStatusAuthorizedWhenInUse NS_ENUM_AVAILABLE_IOS(8_0)
};

/*!
 *  @enum MNPMServiceStatus
 *
 *  @discussion Represents the connection status with the remote server
 *  @since v1.0.3 and later
 *
 *  @constant MNPMServiceStatusDown  Server seems to be down, it has been impossible to establish connection.
 *  @constant MNPMServiceStatusFailedAppkey     Server seems to work properly, connection have been established but the App Key information is incorrect.
 *  @constant MNPMServiceStatusFailedUnknown     Server seems to reachable, but ping test failed because of unknown reasons.
 *  @constant MNPMServiceStatusOK     Server is working properly and connection has been established succesfully.
 
 *
 */
typedef NS_ENUM(NSInteger, MNPMServiceStatus) {
    MNPMServiceStatusDown,
    MNPMServiceStatusFailedAppkey,
    MNPMServiceStatusFailedUnknown,
    MNPMServiceStatusOK,
    
};

/*!
 *  @enum MNPMBluetoothState
 *
 *  @discussion Represents the current state of a CBCentralManager. See [CBCentralManager CBCentralManagerState] (https://developer.apple.com/Library/ios/documentation/CoreBluetooth/Reference/CBCentralManager_Class/translated_content/CBCentralManager.html)
 *
 *  @since v1.1.0 and later
 *
 *  @constant MNPMBluetoothStateUnknown       State unknown, update imminent.
 *  @constant MNPMBluetoothStateResetting     The connection with the system service was momentarily lost, update imminent.
 *  @constant MNPMBluetoothStateUnsupported   The platform doesn't support the Bluetooth Low Energy Central/Client role.
 *  @constant MNPMBluetoothStateUnauthorized  The application is not authorized to use the Bluetooth Low Energy Central/Client role.
 *  @constant MNPMBluetoothStatePoweredOff    Bluetooth is currently powered off.
 *  @constant MNPMBluetoothStatePoweredOn     Bluetooth is currently powered on and available to use.
 *
 */
typedef NS_ENUM(NSInteger, MNPMBluetoothState) {
    MNPMBluetoothStateUnknown = 0,
    MNPMBluetoothStateResetting,
    MNPMBluetoothStateUnsupported,
    MNPMBluetoothStateUnauthorized,
    MNPMBluetoothStatePoweredOff,
    MNPMBluetoothStatePoweredOn
};

/*!
 *  @enum MNPMEnvironment
 *
 *  @discussion Represents the environment endpoint
 *  @since v2.0.0 and later
 *
 *  @constant MNPMEnvironmentProduction Production environment
 *  @constant MNPMEnvironmentTesting Testing environment
 *  @constant MNPMEnvironmentStaging Staging environment
 *
 */
typedef NS_ENUM(NSInteger, MNPMEnvironment) {
    MNPMEnvironmentProduction,
    MNPMEnvironmentTesting,
    MNPMEnvironmentStaging
};