//
//  MNNotificationsManagerVersion.h
//  MNNotificationsManager
//
//  Created by Alberto Salas on 24/11/14.
//  Copyright (c) 2014 Mobiquity Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * The MNNotificationsManagerVersion class represents the version of the SDK.
 */
@interface MNNotificationsManagerVersion : NSObject

/**
 * Marketing Version's Major
 */
+ (NSUInteger) major;

/**
 * Marketing Version's Minor
 */
+ (NSUInteger) minor;

/**
 * Marketing Version's Patch
 */
+ (NSUInteger) patch;

/**
 * Marketing Version's Label (alpha, beta, rc...)
 */
+ (NSString *) label;

/**
 * Build Version
 */
+ (NSUInteger) build;

/**
 * Marketing Version
 */
+ (NSString *) marketingVersion;

/**
 * Complete Version
 */
+ (NSString *) completeVersion;

@end
