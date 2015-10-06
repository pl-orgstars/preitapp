//
//  MNNMOptions+Internal.h
//  MNNotificationsManager
//
//  Created by Alberto Salas on 13/11/14.
//  Copyright (c) 2014 Mobiquity Networks. All rights reserved.
//

#import "MNNMOptions.h"
#import "MNProximityManagerDataTypes.h"

@interface MNNMOptions (Internal)

//Default value: MNPMEnvironmentProduction
@property (nonatomic, assign) MNPMEnvironment environment;
@property (nonatomic, assign) BOOL remoteLogging;
@property (nonatomic, strong) NSString *remoteLoggingId;

@end
