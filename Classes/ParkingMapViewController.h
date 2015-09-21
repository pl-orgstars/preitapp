//
//  ParkingMapViewController.h
//  Preit
//
//  Created by Aniket on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreitAppDelegate.h"

@interface ParkingMapViewController : UIViewController {
	PreitAppDelegate *delegate;
	IBOutlet UIScrollView *scrollMapView;
}

-(void)setHeader;
@end
