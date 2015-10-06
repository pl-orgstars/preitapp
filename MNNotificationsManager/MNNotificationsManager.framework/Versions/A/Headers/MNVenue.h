//
//  MNVenue.h
//  MNProximityManager
//
//  Created by Alberto Salas on 05/09/14.
//  Copyright (c) 2014 Mobiquity Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  MNVenue models a venue
 *
 *  @since 1.1.0
 */
@interface MNVenue : NSObject

/**
 *  MNVenue's indentifier
 *
 *  @since 1.1.0
 */
@property (nonatomic, strong, readonly) NSString *identifier;

/**
 *  MNVenue's name
 *
 *  @since 1.1.0
 */
@property (nonatomic, strong, readonly) NSString *name;

/**
 *  MNVenue's type
 *
 *  @since 1.1.0
 */
@property (nonatomic, strong, readonly) NSString *type;

@end
