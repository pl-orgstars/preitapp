//
//  PreitAppDelegate.h
//  Preit
//
//  Created by Aniket on 9/15/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductSearchHome.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

#import "IIViewDeckController.h"

#import <MNNotificationsManager/MNNotificationsManager.h>
#import "MNNotificationsManagerCustomDelegate.h"
#import <MNNotificationsManager/MNNMOptions+Internal.h>
#import "IntroductionView.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface PreitAppDelegate : NSObject <UIApplicationDelegate,UITabBarControllerDelegate>
{
    NSTimer *timer;
	UINavigationController *navController;
	
	NSDictionary *mallData;
	long mallId;
	BOOL refreshShopping;
	BOOL refreshDining;
	BOOL refreshEvents;
	BOOL refreshSpecials;
	BOOL refreshMore;
	
	BOOL isDinning;
	BOOL isMovie;
	
	double latitude;
	double longitude;
	
	BOOL check;
	
	NSMutableArray *shoppingStores;
	NSMutableArray *storeListContent;
	NSString *website_url;
    
    ProductSearchHome *mHomeViewController;
    
    UIBackgroundTaskIdentifier bgTask;

}

@property (nonatomic) BOOL isOnForeGround;
@property (nonatomic) int x;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) NSDictionary *mallData;
@property (nonatomic) long mallId;
@property (nonatomic) BOOL refreshShopping;
@property (nonatomic) BOOL refreshDining;
@property (nonatomic) BOOL refreshEvents;
@property (nonatomic) BOOL refreshSpecials;
@property (nonatomic) BOOL refreshMore;

@property (nonatomic) BOOL isDinning;
@property (nonatomic) BOOL isMovie;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, retain) NSString *imageLink1;
@property (nonatomic, retain) NSString *imageLink2;
@property (nonatomic, retain) NSString *imageLink3;

@property (nonatomic, retain) UIImage *image1;
@property (nonatomic, retain) UIImage *image2;
@property (nonatomic, retain) UIImage *image3;

@property (nonatomic) BOOL check;
@property (nonatomic,retain)NSMutableArray *shoppingStores;
@property (nonatomic,retain)NSMutableArray *storeListContent;
@property (nonatomic,retain)NSString *website_url;;

@property (nonatomic,retain) NSMutableArray *localiBeaconmsg;

@property(nonatomic) BOOL mAllowSelectTab;
@property(nonatomic,retain) id shoppingViewController;

@property (nonatomic,retain) ProductSearchHome *mHomeViewController; 
@property (nonatomic,retain) UINavigationController *searchHomeNavController;

@property (retain, nonatomic) NSString *deviceToken;


-(void) showNetworkIndicator:(BOOL )show;
- (void)setupPortraitUserInterface;
-(void)showAlert:(NSString *)msg title:(NSString *)title buttontitle:(NSString *)buttontitle;
-(BOOL)checkImage:(UIImage*)myImage;
-(void)showTabBar:(BOOL)animated;
-(void)hideTabBar:(BOOL)animated;

-(void)hideProductScreen:(BOOL)hide;
@property(nonatomic, retain) id<GAITracker> tracker;


@property (nonatomic,retain) NSString *searchURL;

@property(nonatomic,retain) id productSearchViewControllerDelegate;


//ibnetariq
@property(retain,nonatomic) NSArray* viewsArray;

// MNNotification By Jawad Ahmed
@property (retain, nonatomic) MNNotificationsManager *notificationsManager;
@property (retain, nonatomic) MNNotificationsManagerCustomDelegate *notificationsDelegate;
@property (retain, nonatomic) NSMutableArray *notificationsArray;


-(void)showLocalNotificationsWithMessage:(NSString *)message :(NSString*)beacon_id;
-(void)setlocationNotifcation;
-(void)AddmenuView;

-(void)ShowMenuViewOnTop;
-(void)HideMenuViewOnTop;

- (void)initilizeBeacon;
- (void)disableBeacon;

@end

