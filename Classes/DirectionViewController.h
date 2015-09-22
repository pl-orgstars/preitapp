//
//  DirectionViewController.h
//  Preit
//
//  Created by Aniket on 10/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PreitAppDelegate.h"

@interface AddressAnnotation : NSObject<MKAnnotation> {
	//	CLLocationCoordinate2D coordinate;	
	NSString *mTitle;
	NSString *mSubTitle;
}
@property(nonatomic,retain) NSString *mTitle;
@property(nonatomic,retain)NSString *mSubTitle;
@end

////kkuldeeep changes
@interface DirectionViewController : UIViewController {
	IBOutlet MKMapView *mapView;
	PreitAppDelegate *delegate;
	NSString *latitude;
	NSString *longitude;
	NSString *mallAddress;
	IBOutlet UIActivityIndicatorView *indicator_;
	
}
@property(nonatomic,retain) NSString *latitude;
@property(nonatomic,retain) NSString *longitude;
@property(nonatomic,retain) NSString *mallAddress;

- (void) showAddress;
@end
