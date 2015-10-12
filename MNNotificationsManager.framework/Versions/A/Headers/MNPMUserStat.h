//
//  MNPMUserStat.h
//  MNProximityManager
//
//  Created by Alberto Salas on 11/11/14.
//  Copyright (c) 2014 Mobiquity Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNStat.h"

/**
 * MNPMUserStatType Enum
 *
 * @since v2.0 and later
 */
typedef NS_ENUM(NSUInteger, MNPMUserStatType) {
    
    /**
     * Viewed Campaign Stat
     * Require Campaign in value
     */
    MNPMUserStatTypeCampaignViewed,
    
    /**
     * Clicked Campaign Stat
     * Require Campaign in value
     */
    MNPMUserStatTypeCampaignClicked,
    
    /**
     * Viewed Campaign Stat
     * Shared Campaign in value
     */
    MNPMUserStatTypeCampaignShared,
    
    /**
     * Viewed Resource Stat
     * Require Resource in value
     */
    MNPMUserStatTypeResourceViewed,
    
    /**
     * Clicked Resource Stat
     * Require Resource in value
     */
    MNPMUserStatTypeResourceClicked,
    
    /**
     * Shared Resource Stat
     * Require Resource in value
     */
    MNPMUserStatTypeResourceShared,
    
    /**
     * Background Showed Notification Stat
     * Require Notification and Beacon/Geofence in value
     */
    MNPMUserStatTypeLocalNotificationShowedInBackground,
    
    /**
     * Foreground Showed Notification Stat
     * Require Notification and Beacon/Geofence in value
     */
    MNPMUserStatTypeLocalNotificationShowedInForeground,
    
    /**
     * Enter Foreground Using Notification Stat
     * Require Notification and Beacon/Geofence in value
     */
    MNPMUserStatTypeLocalNotificationClicked
    
};

static NSString *MNPMUserStatValueCampaignKey = @"campaign";
static NSString *MNPMUserStatValueResourceKey = @"resource";
static NSString *MNPMUserStatValueNotificationKey = @"notification";
static NSString *MNPMUserStatValueBeaconKey = @"beacon";
static NSString *MNPMUserStatValueGeofenceKey = @"geofence";

@interface MNPMUserStat : MNStat

- (instancetype)initWithUserStatType:(MNPMUserStatType)userStatType value:(NSDictionary *)value;
+ (instancetype)userStatWithUserStatType:(MNPMUserStatType)userStatType value:(NSDictionary *)value;

- (instancetype)initWithUserStatCustomType:(NSString *)customStatType value:(NSDictionary *)value;
+ (instancetype)userStatWithUserStatCustomType:(NSString *)customStatType value:(NSDictionary *)value;

@end
