#import "MyCLController.h"

@implementation MyCLController

@synthesize locationManager;
@synthesize delegate;

- (id) init {
	self = [super init];
//	if (self != nil) {
    self.locationManager = [[CLLocationManager alloc] init] ;//autorelease];
		self.locationManager.delegate = self; // send loc updates to myself
//	}
    if (is_iOS8) {
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [locationManager requestAlwaysAuthorization];
    }
    
    
	return self;
}

//- (void)locationManager:(CLLocationManager *)manager
//	didUpdateToLocation:(CLLocation *)newLocation
//		   fromLocation:(CLLocation *)oldLocation
//{
//	[self.delegate locationUpdate:newLocation];
//}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
   
    [self.delegate locationUpdate: [locations lastObject]];
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	[self.delegate locationError:error];
}

//- (void)dealloc {
//	[self.locationManager release];
//    [super dealloc];
//}

@end
