//
//  MNAppKey.h
//  MNProximityManager
//
//  Created by Alberto Salas on 23/01/14.
//  Copyright (c) 2014 Mobiquity Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * MNAppKey is the class that models the Application Key provided by Mobiquity Networks for authentication, authotization and configure the SDK.
 */
@interface MNAppKey : NSObject <NSCopying>

/**
 * Application Key
 * @since v1.0 and later
 */
@property (nonatomic, strong) NSString *appKey;

/**
 * Application Secret Key
 * @since v1.0 and later
 */
@property (nonatomic, strong) NSString *secretKey;

/**
 * Init method
 * @param appKey Application Key
 * @param secretKey Secret Key
 */
- (instancetype) initWithAppKey:(NSString *)appKey andSecretKey:(NSString *)secretKey;

@end
