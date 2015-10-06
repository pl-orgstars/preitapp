//
//  MNSMGeoInfo.h
//  MNSignalsManager
//
//  Created by Alberto Salas on 29/10/14.
//  Copyright (c) 2014 Mobiquity Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MNVenue.h"
#import "MNPOI.h"

@interface MNNMGeoInfo : NSObject

@property (nonatomic, strong, readonly) MNVenue *venue;

@property (nonatomic, strong, readonly) NSArray *pois;

@end
