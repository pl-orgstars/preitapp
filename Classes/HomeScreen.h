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
#import "MFSideMenu.h"
#import "PreitNavigationViewController.h"

typedef enum {
    DisplayOrderByState = 0,
    DisplayOrderByAlphabet,
    DisplayOrderBySearch,
    DisplayOrderNearestMall
} DisplayOrder;

@interface HomeScreen : BaseViewController<UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate> {
	IBOutlet UITableView *tableHome;
	NSMutableArray *tableData;
	NSMutableArray *distanceData;
	PreitAppDelegate *delegate;
	BOOL isNoData;
	NSString *city;
	CLLocationCoordinate2D coordinates;
	NSString *radius;
	IBOutlet UIActivityIndicatorView *indicator_;
    
    IBOutlet UIButton *menuButton;
    IBOutlet UISearchBar *searchBar_;
    IBOutlet UIButton *locateButton;
    IBOutlet UIImageView *byStateUnderline;
    IBOutlet UIImageView *byAlphabetUnderline;
    
    NSMutableDictionary *sections;
    NSArray *sectionKeys;
    NSMutableArray *searchArray;
    NSDictionary *nearestMall;
    
    DisplayOrder displayOrder;
}

@property(nonatomic,retain)NSMutableArray *tableData;
@property(nonatomic,retain)NSString *city;
@property(nonatomic)CLLocationCoordinate2D coordinates;
@property(nonatomic,retain)NSString *radius;

@property(nonatomic)BOOL isLocationEnabled;
@property (nonatomic) BOOL presentMainView;

@property (nonatomic) BOOL showMenuButton;

-(void)getData;
-(void)getDistance;
-(void)requestForImages;
-(void)loadInitialView;
@end
