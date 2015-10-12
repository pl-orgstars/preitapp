//
//  MNNotificationsManagerErrors.h
//  MNNotificationsManager
//
//  Created by Alberto Salas on 04/11/14.
//  Copyright (c) 2014 Mobiquity Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MNNotificationsManagerErrorDomain @"MNNotificationsManagerErrorDomain"

typedef NS_ENUM(NSInteger, MNNotificationsManagerError) {
    MNNotificationsManagerErrorGeneral = 1,
    MNNotificationsManagerErrorInvalidAppKey = 2,
    MNNotificationsManagerErrorDataLoading = 3,
    MNNotificationsManagerErrorMonitoring = 4,
    MNNotificationsManagerErrorRanging = 5,
    MNNotificationsManagerErrorUpdating = 6,
    MNNotificationsManagerErrorReloadingGeofences = 7,
    MNNotificationsManagerErrorDB = 8,
    MNNotificationsManagerErrorOptions = 9
};