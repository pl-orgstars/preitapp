//
//  LocationViewController.h
//  Preit
//
//  Created by Aniket on 10/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MyCLController.h"
#import "PreitAppDelegate.h"
#import "MenuScreenViewController.h"

@interface LocationViewController : SuperViewController <MyCLControllerDelegate,MKReverseGeocoderDelegate,UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource> {
//	NSMutableData *receivedData;
	MyCLController *locationController;
	CLLocationCoordinate2D coordinates;
	NSArray *pickerItem;
	
	PreitAppDelegate *delegate;
	BOOL isFirstTime;
	int radiusSelected;
    
    BOOL isLocationEnabled;
    
}
-(void)showActionSheet;


-(void)fetchData:(NSDictionary*)tmpDict;
-(void)requestForImages;

//-(void)updateLocation;
-(void)prefomLocalNotification;

@property (nonatomic) BOOL presentMainView;
@property (nonatomic) BOOL shouldReload;

@end
