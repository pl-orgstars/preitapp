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
//    [super dealloc];
}
-(void)removeBeaconSearch{
    [visitManager stop];
    [transmitters removeAllObjects];
//    visitManager = nil;
//    transmitters = nil;
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
//    [Utils showAlertMesage:@"Proximity service started"];
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"fyx_service_started_key"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    transmitters = [NSMutableArray new];
    
    if (!visitManager) {
        visitManager = [[FYXVisitManager alloc] init];
    }
    
    
    visitManager.delegate = self;
    [visitManager startWithOptions:@{
//                                     FYXVisitOptionDepartureIntervalInSecondsKey:@15,
                                     FYXVisitOptionBackgroundDepartureIntervalInSecondsKey:@300,
                                          FYXSightingOptionSignalStrengthWindowKey:@(FYXSightingOptionSignalStrengthWindowNone)}];
    
    

//FYXVisitOptionBackgroundDepartureIntervalInSecondsKey
//  FYXSightingOptionSignalStrengthWindowLarge
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
//    callback(YES,@"yyyyyy");
//    return;

    
    NSLog(@"############## didArrive: %@", visit);
}

- (void)didDepart:(FYXVisit *)visit
{
//    [Utils showAlertMesage:visit.transmitter.identifier];
    NSLog(@"############## didDepart: %@", visit);
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                    message:@"departing from here"
//                                                   delegate:nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentMall"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    callback(YES,@"yyyyyy");
    if ([[UIApplication sharedApplication]applicationState] == UIApplicationStateBackground) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            Transmitter *transmitter = [[transmitters filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", visit.transmitter.identifier]] firstObject];
//            callback(YES,@"yyyyyy");
            
            [transmitters removeObject:transmitter];
        });
    }else{
        Transmitter *transmitter = [[transmitters filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", visit.transmitter.identifier]] firstObject];
//        callback(YES,@"yyyyyy");
        
        [transmitters removeObject:transmitter];
    }
    
    
//

    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[transmitters indexOfObject:transmitter] inSection:0];
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    if ([cell isKindOfClass:[SightingsTableViewCell class]])
//    {
//        [self grayOutSightingsCell:((SightingsTableViewCell*)cell)];
//    }
}

- (void)receivedSighting:(FYXVisit *)visit updateTime:(NSDate *)updateTime RSSI:(NSNumber *)RSSI
{
    
//    PreitAppDelegate *delegate = (PreitAppDelegate *)[[UIApplication sharedApplication]delegate];
//    [delegate showLocalNotificationsWithMessage:@"yyyyyyyeeehaaa receivedSighting"];
//    [Utils showAlertMesage:@"yyyyyyyeeehaaa"];
//    callback(YES,visit.transmitter.identifier);
//    return;
    
    if ([[UIApplication sharedApplication]applicationState] == UIApplicationStateBackground) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            //
            
            //    callback(YES,@"kkkkk");
            //    return;
            
            
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
                
                
                
                //        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.transmitters.count - 1 inSection:0]]
                //                              withRowAnimation:UITableViewRowAnimationAutomatic];
                
                //        if ([self.transmitters count] == 1)
                //        {
                //            [self hideNoTransmittersView];
                //        }
            }
            
            transmitter.lastSighted = updateTime;
            
            if ([self shouldUpdateTransmitterCell:visit transmitter:transmitter RSSI:RSSI])
            {
                transmitter.previousRSSI = transmitter.rssi;
                transmitter.rssi = RSSI;
                transmitter.batteryLevel = visit.transmitter.battery;
                transmitter.temperature = visit.transmitter.temperature;
                
                //        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[transmitters indexOfObject:transmitter] inSection:0];
                
                //        SightingsTableViewCell *cell = (SightingsTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                
                //        [self updateSightingsCell:cell withTransmitter:transmitter];
            }
            
        });
    }else{
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
            
            
            
            //        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.transmitters.count - 1 inSection:0]]
            //                              withRowAnimation:UITableViewRowAnimationAutomatic];
            
            //        if ([self.transmitters count] == 1)
            //        {
            //            [self hideNoTransmittersView];
            //        }
        }
        
        transmitter.lastSighted = updateTime;
        
        if ([self shouldUpdateTransmitterCell:visit transmitter:transmitter RSSI:RSSI])
        {
            transmitter.previousRSSI = transmitter.rssi;
            transmitter.rssi = RSSI;
            transmitter.batteryLevel = visit.transmitter.battery;
            transmitter.temperature = visit.transmitter.temperature;
            
            //        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[transmitters indexOfObject:transmitter] inSection:0];
            
            //        SightingsTableViewCell *cell = (SightingsTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            //        [self updateSightingsCell:cell withTransmitter:transmitter];
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
