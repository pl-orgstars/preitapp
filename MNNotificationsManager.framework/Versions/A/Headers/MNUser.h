//
//  MNUser.h
//  MNProximityManager
//
//  Created by Alberto on 23/01/14.
//  Copyright (c) 2014 Mobiquity Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MNUserAudience.h"

/**
 * A C enum that hold User role types.
 * @since v1.0 and later
 */
typedef NS_ENUM(NSUInteger, MNUserRoleType) {
    /** Final User */
    MNUserRoleTypeFinalUser,
    /** Developer */
    MNUserRoleTypeDeveloper,
    /** Tester */
    MNUserRoleTypeTester
};

/**
 * MNUser models a final user. It's used for stats and the role type is used for the campaigns associted to beacons.
 */
@interface MNUser : NSObject <NSCopying>

/**
 * User name
 * @since v1.0 and later
 */
@property (nonatomic, copy) NSString *username;

/**
 * Authentication provider
 * @since v1.0 and later
 */
@property (nonatomic, copy) NSString *authProvider;

/**
 * Role type, used to getting campaigns associated to beacons. For a list of possible values, see the <MNUserRoleType> type.
 * @since v1.0 and later
 */
@property (nonatomic, assign) MNUserRoleType roleType;

/**
 * Role type, as a String
 * @since v1.0 and later
 */
//@property (nonatomic, readonly) NSString *roleTypeString;

/**
 * User Target
 * @since v1.0 and later
 */
@property (nonatomic, strong) MNUserAudience *userAudience;

/**
 * Init method
 * @param username User name, for stats
 * @since v1.0 and later
 */
- (instancetype) initWithUserName:(NSString *)username;

/**
 * Init method
 * @param username User name, for stats
 * @param authProvider Authentication provider, for stats
 * @since v1.0 and later
 */
- (instancetype) initWithUserName:(NSString *)username authProvider:(NSString *)authProvider;

/**
 * Init method
 * @param username User name, for stats
 * @param authProvider Authentication provider, for stats
 * @param roleType Role type, used to getting campaigns associated to beacons. For a list of possible values, see the <MNUserRoleType> type.
 * @since v1.0 and later
 */
- (instancetype) initWithUserName:(NSString *)username authProvider:(NSString *)authProvider roleType:(MNUserRoleType)roleType;

/**
 * Init method
 * @param roleType Role type, used to getting campaigns associated to beacons. For a list of possible values, see the <MNUserRoleType> type.
 * @since v1.0 and later
 */
- (instancetype) initWithRoleType:(MNUserRoleType)roleType;

@end
