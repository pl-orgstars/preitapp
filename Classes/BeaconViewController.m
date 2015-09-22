//
//  BeaconViewController.m
//  Preit
//
//  Created by kuldeep on 1/13/15.
//
//

#import "BeaconViewController.h"


@interface BeaconViewController ()

@end

@implementation BeaconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    277d825b-7e1f-4418-895f-0d1cf248ff80

    [FYX setAppId:@"9dae2f0e00d4a200249a462486817f69dea75a9adf2a47edc2dabb6ffc044879" appSecret:@"ef72be76cab78d28cd199dd28c5f1827119c2f50465a571e477f303e496da8ce" callbackUrl:@"comr5ipreit://authcode"];
     [FYX startService:self];
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)locationUpdate{
    //disable location udpates
//    [FYX disableLocationUpdates];
    
    //enable location updates. Uses Low Power location by default.
    [FYX enableLocationUpdates];
    
    //enable location updates with options
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    [options setObject:[NSString stringWithString:FYXHighAccuracyLocation] forKey:FYXLocationModeKey];
    [FYX enableLocationUpdatesWithOptions:options];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Beacon Delegate

- (void)serviceStarted{
    // this will be invoked if the service has successfully started
    // bluetooth scanning will be started at this point.
    NSLog(@"FYX Service Successfully Started");
    [Utils showAlertMesage:@"serviceStarted"];
    
    self.visitManager = [FYXVisitManager new];
    self.visitManager.delegate = self;
    [self.visitManager start];
}

/// comment for documentation
- (void)startServiceFailed:(NSError *)error{
    // this will be called if the service has failed to start
    NSLog(@"%@", error);
}
#pragma mark - FYXVisitDelegate Delegate

- (void)didArrive:(FYXVisit *)visit{
    // this will be invoked when an authorized transmitter is sighted for the first time
    [Utils showAlertMesage:[@"I arrived at a Gimbal Beacon!!!   " stringByAppendingString:visit.transmitter.name]];
    NSLog(@"I arrived at a Gimbal Beacon!!! %@", visit.transmitter.name);
}

/// Delegate callback to notify when a Visit has been updated
- (void)receivedSighting:(FYXVisit *)visit updateTime:(NSDate *)updateTime RSSI:(NSNumber *)RSSI{
    // this will be invoked when an authorized transmitter is sighted during an on-going visit
    NSLog(@"I received a sighting!!! %@", visit.transmitter.name);
    [Utils showAlertMesage:[@"I received a sighting!!!   " stringByAppendingString:visit.transmitter.name]];
}

/// Delegate callback to notify when a Visit has ended and the beacon has departed
- (void)didDepart:(FYXVisit *)visit{
    // this will be invoked when an authorized transmitter has not been sighted for some time
    NSLog(@"I left the proximity of a Gimbal Beacon!!!! %@", visit.transmitter.name);
    NSLog(@"I was around the beacon for %f seconds", visit.dwellTime);
    [Utils showAlertMesage:[@"I left the proximity of a Gimbal Beacon!!!!   " stringByAppendingString:visit.transmitter.name]];

}
@end
