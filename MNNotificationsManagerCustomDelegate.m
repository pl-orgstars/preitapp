//
//  MNNotificationsManagerCustomDelegate.m
//  Preit
//
//  Created by Jawad Ahmed on 10/12/15.
//
//

#import "MNNotificationsManagerCustomDelegate.h"

@implementation MNNotificationsManagerCustomDelegate

- (void)notificationsManager:(MNNotificationsManager *)notificationsManager didChangeAuthorizationStatus:(MNPMAuthorizationStatus)status {
    if (status == MNPMAuthorizationStatusRestricted || status == MNPMAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Location Services are turned off. Please turn them on" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)notificationsManager:(MNNotificationsManager *)notificationsManager didChangeBluetoothState:(MNPMBluetoothState)state {
    if (state == MNPMBluetoothStatePoweredOff) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please activate Bluetooth for access to all features" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)notificationsManager:(MNNotificationsManager *)notificationsManager didDiscoveredGeoInfo:(MNNMGeoInfo *)geoInfo {
    NSLog(@"Discovered %lu POIs, in '%@'", (unsigned long)geoInfo.pois.count, geoInfo.venue.name);
}

@end
