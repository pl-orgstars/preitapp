//
//  BeaconModel.m
//  Preit
//
//  Created by kuldeep on 1/23/15.
//
//

#import "BeaconModel.h"
#import <FYX/FYXTransmitterManager.h>
#import "PreitAppDelegate.h"
@implementation BeaconModel

SYNTHESIZE_SINGLETON_FOR_CLASS(BeaconModel);



- (void)dealloc
{
    [visitManager stop];
}
-(void)removeBeaconSearch{
    [visitManager stop];
    [transmitters removeAllObjects];
}
-(void)initilizeBeaconWithCallBack:(void(^)(BOOL hasdata, NSString *identifier))completion{
    callback = completion;
    
    NSString  *your_app_id = your_app_id_MICRO;
    NSString *secret = secret_MICRO;
    NSString *callbackURL = callback_MICRO;
    
    [FYX setAppId:your_app_id
        appSecret:secret
      callbackUrl:callbackURL];
    [FYXLogging setLogLevel:FYX_LOG_LEVEL_INFO];
    
    
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    [options setObject:[NSString stringWithString:FYXHighAccuracyLocation] forKey:FYXLocationModeKey]; [FYX enableLocationUpdatesWithOptions:options];
    
    [FYX startService:self];
}
#pragma mark - FYX Delegate methods
- (void)serviceStarted
{
    NSLog(@"#########Proximity service started!");
    
    transmitters = [NSMutableArray new];
    
    if (!visitManager) {
        visitManager = [[FYXVisitManager alloc] init];
    }
    
    
    visitManager.delegate = self;
    [visitManager startWithOptions:@{
                                     FYXVisitOptionBackgroundDepartureIntervalInSecondsKey:@300,
                                          FYXSightingOptionSignalStrengthWindowKey:@(FYXSightingOptionSignalStrengthWindowNone)}];
    
    

}

- (void)startServiceFailed:(NSError *)error
{
    NSLog(@"#########Proximity service failed to start! error is: %@", error);
   

    NSString *message = @"Service failed to start";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Proximity Service"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - FYX visit delegate

- (void)didArrive:(FYXVisit *)visit
{
    NSLog(@"############## didArrive: %@", visit);
}

- (void)didDepart:(FYXVisit *)visit
{
    NSLog(@"############## didDepart: %@", visit);
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentMall"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([[UIApplication sharedApplication]applicationState] == UIApplicationStateBackground) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            Transmitter *transmitter = [[transmitters filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", visit.transmitter.identifier]] firstObject];
            
            [transmitters removeObject:transmitter];
        });
    }else{
        Transmitter *transmitter = [[transmitters filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", visit.transmitter.identifier]] firstObject];
        
        [transmitters removeObject:transmitter];
    }
    
}

- (void)receivedSighting:(FYXVisit *)visit updateTime:(NSDate *)updateTime RSSI:(NSNumber *)RSSI
{
    
    if ([[UIApplication sharedApplication]applicationState] == UIApplicationStateBackground) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSLog(@"############## receivedSighting: %@", visit);
            
            Transmitter *transmitter = [[transmitters filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", visit.transmitter.identifier]] firstObject];
            if (transmitter == nil)
            {
                transmitter = [Transmitter new];
                transmitter.identifier = visit.transmitter.identifier;
                transmitter.name = visit.transmitter.name ? visit.transmitter.name : visit.transmitter.identifier;
                transmitter.lastSighted = [NSDate dateWithTimeIntervalSince1970:0];
                transmitter.rssi = [NSNumber numberWithInt:-100];
                transmitter.previousRSSI = transmitter.rssi;
                transmitter.batteryLevel = 0;
                transmitter.temperature = 0;
                
                [transmitters addObject:transmitter];
                
                
                callback(YES,visit.transmitter.identifier);
                
              }
            
            transmitter.lastSighted = updateTime;
            
            if ([self shouldUpdateTransmitterCell:visit transmitter:transmitter RSSI:RSSI])
            {
                transmitter.previousRSSI = transmitter.rssi;
                transmitter.rssi = RSSI;
                transmitter.batteryLevel = visit.transmitter.battery;
                transmitter.temperature = visit.transmitter.temperature;
  
            }
            
        });
    }else{
        
        Transmitter *transmitter = [[transmitters filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", visit.transmitter.identifier]] firstObject];
        if (transmitter == nil)
        {
            transmitter = [Transmitter new];
            transmitter.identifier = visit.transmitter.identifier;
            transmitter.name = visit.transmitter.name ? visit.transmitter.name : visit.transmitter.identifier;
            transmitter.lastSighted = [NSDate dateWithTimeIntervalSince1970:0];
            transmitter.rssi = [NSNumber numberWithInt:-100];
            transmitter.previousRSSI = transmitter.rssi;
            transmitter.batteryLevel = 0;
            transmitter.temperature = 0;
            
            [transmitters addObject:transmitter];
            
            
            callback(YES,visit.transmitter.identifier);
          }
        
        transmitter.lastSighted = updateTime;
        
        if ([self shouldUpdateTransmitterCell:visit transmitter:transmitter RSSI:RSSI])
        {
            transmitter.previousRSSI = transmitter.rssi;
            transmitter.rssi = RSSI;
            transmitter.batteryLevel = visit.transmitter.battery;
            transmitter.temperature = visit.transmitter.temperature;
        }
    }
}

#pragma mark Extra methods
- (BOOL)shouldUpdateTransmitterCell:(FYXVisit *)visit transmitter:(Transmitter *)transmitter RSSI:(NSNumber *)rssi
{
    if ([transmitter.rssi isEqual:rssi] &&
        [transmitter.batteryLevel isEqualToNumber:visit.transmitter.battery] &&
        [transmitter.temperature isEqualToNumber:visit.transmitter.temperature])
    {
        return NO;
    }
    return YES;
}
@end
