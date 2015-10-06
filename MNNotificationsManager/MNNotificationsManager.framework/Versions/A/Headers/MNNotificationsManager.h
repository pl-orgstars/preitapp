//
//  MNNotificationsManager.h
//  MNNotificationsManager
//
//  Created by Alberto Salas on 04/11/14.
//  Copyright (c) 2014 Mobiquity Networks. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MNProximityManagerDataTypes.h"
#import "MNNotificationsManagerDelegate.h"
#import "MNNotificationsManagerErrors.h"
#import "MNAppKey.h"
#import "MNNMOptions.h"
#import "MNUser.h"
#import "MNPMUserStat.h"

static NSString *MNNotificationsManagerNotificationKey = @"com.mobiquitynetworks.mnnotificationsmanager.notificationkey";

/**
 * The MNNotificationsManager class provides a facade for the Mobiquity Networks NotificationsManager SDK.
 *
 * In order to get an instance of the MNNotificationsManager, it requires the use of one of the provided asynchronous factory method.
 *
 * Please, check [MNNotificationsManager Reference Index](../index.html) for samples.
 *
 */
@interface MNNotificationsManager : NSObject

/**
 * Delegate property for notificationsManager events. It can be assigned using this property or at initialization time with the factory method
 *
 * @warning Property is defined as weak, so you should keep a strong reference to delegate.
 *
 * @since v1.0 and later
 */
@property (nonatomic, weak) id<MNNotificationsManagerDelegate> delegate;

/**
 * Asynchronous static factory method for MNNotificationsManager
 * Checks appKey, connects with Mobiquity service, instantiates a notificationsManager and executes completionHandler.
 *
 * @param appKey MobiBeacons Application Key
 *
 * @param options Monitoring manager options
 *
 * @param user User data as a <MNUser> instance
 *
 * @param delegate Delegate for notificationsManager events. It can be assigned here or using the provided property
 *
 * @param completionHandler Completion block dispatched at main queue with a MNNotificationsManager instance or a NSError as parameters
 *
 * @since v1.0 and later
 */
+ (void) notificationsManagerWithAppKey:(MNAppKey *)appKey
                                options:(MNNMOptions *)options
                                   user:(MNUser *)user
                               delegate:(id<MNNotificationsManagerDelegate>)delegate
                      completionHandler:(void(^)(MNNotificationsManager *notificationsManager, NSError *error))completionHandler;

/// @name Start and stop methods.

/**
 * Start scanning for nearest localized notifications
 *
 * @since v1.0 and later
 */
- (void) start;

/**
 * Stop scanning for nearest localized notifications
 *
 * @since v1.0 and later
 */
- (void) stop;

/// @name Status verification methods

/**
 * Returns the service status.
 *
 * @param appKey Notifications Manager Key as a <MNAppKey> instance
 *
 * @param completionHandler block with a parameter indicating whether the service is available and a secure connection can be established with it
 *
 * @discussion The service connection availability is tested by way of a ping-like connection attempt, using the user App Key. This way we can find server reachability and App Key errors.
 *
 * @since v1.0 and later
 */
+ (void) serviceStatusWithAppKey:(MNAppKey *)appKey completionHandler:(void (^)(MNPMServiceStatus status))completionHandler;

/**
 * Returns the application’s authorization status for using location services. See [CLLocationManager authorizationStatus] (https://developer.apple.com/library/ios/documentation/CoreLocation/Reference/CLLocationManager_Class/CLLocationManager/CLLocationManager.html).
 *
 * @return A value indicating whether the application is authorized to use location services.
 *
 * @discussion The authorization status of a given application is managed by the system and determined by several factors. Applications must be explicitly authorized to use location services by the user and location services must themselves currently be enabled for the system.
 *
 * @since v1.0 and later
 */
+ (MNPMAuthorizationStatus) authorizationStatus;

/**
 * Returns the Bluetooth state. See [CBCentralManager state] for more info (https://developer.apple.com/Library/ios/documentation/CoreBluetooth/Reference/CBCentralManager_Class/translated_content/CBCentralManager.html).
 *
 * @return A value indicating the Bluetooth status.
 *
 * @discussion When a MNNotificationsManager object is initially created, the default value of this property is MNPMBluetoothStateUnknown. As the Bluetooth’s state changes, MNNotificationsManager updates the value of this property and calls the notificationsManager:didChangeBluetoothState: delegate method. For a list of the possible values representing the state of the central manager, see “MNNMBluetoothState” enum.
 *
 * @since v1.0 and later
 */
- (MNPMBluetoothState) bluetoothState;

/**
 * Returns a Boolean indicating whether MNNotificationsManager supports device's iOS version.
 *
 * @return YES if MNNotificationsManager supports device's iOS version or NO if it does not.
 *
 * @since v1.0 and later
 */
+ (BOOL) isOSVersionSupported;

/**
 * Used to send local notification received in the UIApplicationDelegate -application:didReceiveLocalNotification:
 * to Notifications SDK for processing. Returns a Boolean indicating whether the SDK processed the notification.
 *
 * @param localNotification local notification received in the application delegate method indicated previously
 *
 * @return YES if the local notification was owned by the Notifications SDK, NO if Notifications SDK did not recognize
 *  it and is the developer's task to process it as any standard local notification.
 *
 * @since v1.0
 * @deprecated Use instead the static version of this method.
 */
- (BOOL) processLocalNotification:(UILocalNotification *)localNotification __attribute((deprecated("Use instead the static version of this method +[MNNotificationsManager processLocalNotification:]")));

/**
 * Used to send local notification received in the UIApplicationDelegate -application:didReceiveLocalNotification:
 * to Notifications SDK for processing. Returns a Boolean indicating whether the SDK processed the notification.
 *
 * @param localNotification local notification received in the application delegate method indicated previously
 *
 * @return YES if the local notification was owned by the Notifications SDK, NO if Notifications SDK did not recognize
 *  it and is the developer's task to process it as any standard local notification.
 *
 * @since v1.6
 */
+ (BOOL) processLocalNotification:(UILocalNotification *)localNotification;

/**
 *  Send a user stat
 *
 *  @param userStat User event
 *  @since 1.0 and later
 */
- (void) registerUserStat:(MNPMUserStat *)userStat;

/**
 * Send a user stat
 *
 * @param userStat User event
 * @param completionHandler Completion block with a NSError as parameter
 *
 * @since v1.0 and later
 */
- (void) registerUserStat:(MNPMUserStat *)userStat withCompletionHandler:(void(^)(NSError *error))completionHandler;


@end
