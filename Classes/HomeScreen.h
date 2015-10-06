//
//  HomeScreen.h
//  Preit
//
//  Created by Aniket on 9/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreitAppDelegate.h"
#import "MyCLController.h"

#import "BaseViewController.h"

@interface HomeScreen : BaseViewController<UITableViewDataSource,UITableViewDelegate> {
	IBOutlet UITableView *tableHome;
	NSMutableArray *tableData;
	NSMutableArray *distanceData;
	PreitAppDelegate *delegate;
	BOOL isNoData;
	NSString *city;
	CLLocationCoordinate2D coordinates;
	NSString *radius;
	IBOutlet UIActivityIndicatorView *indicator_;
    
    
    
}
@property(nonatomic,retain)NSMutableArray *tableData;
@property(nonatomic,retain)NSString *city;
@property(nonatomic)CLLocationCoordinate2D coordinates;
@property(nonatomic,retain)NSString *radius;

@property(nonatomic)BOOL isLocationEnabled;
@property (nonatomic) BOOL presentMainView;

-(void)getData;
-(void)getDistance;
-(void)requestForImages;
-(void)loadInitialView;
@end
