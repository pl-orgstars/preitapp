//
//  PreitAppDelegate.m
//  Preit
//
//  Created by Aniket on 9/15/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "PreitAppDelegate.h"
#import "NavigationRotateController.h"
#import "HomeScreen.h"
#import "ShoppingViewController.h"
#import "DiningViewController.h"
#import "WebViewController.h"
#import "EventsViewController.h"
#import "SpecialsViewController.h"
#import "SalesViewController.h"
#import "MoreViewController.h"

#import "ShoppingStoreViewController.h"
#import "StoreDetailsViewController.h"

#import "LocationViewController.h"

#import "RequestAgent.h"
#import "LoadingAgent.h"
#import "JSON.h"

#import <FYX/FYX.h>
#import <FYX/FYXLogging.h>

#import "UIAlertView+Blocks.h"
#define First_Button_Tag 123987
#define Second_Button_Tag 123986
#define Third_Button_Tag 123985
#define Forth_Button_Tag 123984
#define Fifth_Button_Tag 123983

#import "SearchScreenViewController.h"
#import "MapScreenViewController.h"
#import "MenuScreenViewController.h"
#import "DealScreenViewController.h"
#import "ParkScreenViewController.h"


/******* Set your tracking ID here *******/
static NSString *const kTrackingId = @"UA-39751767-1";
static NSString *const kAllowTracking = @"allowTracking";

@implementation PreitAppDelegate

@synthesize searchHomeNavController;
@synthesize mHomeViewController;
@synthesize shoppingViewController;
@synthesize mAllowSelectTab;
@synthesize window;
@synthesize tabBarController;
@synthesize navController;
@synthesize mallData;
@synthesize mallId;
@synthesize refreshShopping,refreshDining,refreshEvents,refreshSpecials,refreshMore;
@synthesize isDinning,isMovie;
@synthesize latitude,longitude;
@synthesize imageLink1,imageLink2,imageLink3;
@synthesize image1,image2,image3;
@synthesize check;
@synthesize shoppingStores;
@synthesize storeListContent;
@synthesize website_url;
@synthesize vc_MenuView;
@synthesize sideMenuV;

@synthesize tracker;
@synthesize isOnForeGround;
- (UINavigationController *)createNavControllerWrappingViewControllerOfClass:(Class)cntrloller
                                                                     nibName:(NSString*)nibName
                                                                 tabIconName:(NSString*)iconName
                                                           tabIconNameSected:(NSString*)iconNameSected
                                                                       frame:(CGRect)frame
                                                                         tag:(int)tag
{
    UIViewController* viewController = [[cntrloller alloc] initWithNibName:nibName bundle:nil];
    NavigationRotateController *theNavigationController;
    theNavigationController = [[NavigationRotateController alloc] initWithRootViewController:viewController];
    viewController.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];

    NSLog(@"WASEEM %@",viewController.navigationController.navigationItem.title);
//Waseem

    [self addCenterButtonWithImage:[UIImage imageNamed:iconName] highlightImage:[UIImage imageNamed:iconNameSected] frame:frame tag:tag];
    
    
    return theNavigationController ;
}



- (UINavigationController *)createNavControllerWrappingViewControllerOfClass:(Class)cntrloller
                                                                     nibName:(NSString*)nibName
                                                                 tabIconName:(NSString*)iconName
                                                                    tabTitle:(NSString*)tabTitle

{
    UIViewController* viewController = [[cntrloller alloc] initWithNibName:nibName bundle:nil];
    NSLog(@"TabTitle %@",tabTitle);
    NavigationRotateController *theNavigationController;
    theNavigationController = [[NavigationRotateController alloc] initWithRootViewController:viewController];
    
    viewController.title = NSLocalizedString(tabTitle, @"");
    viewController.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    viewController.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    if ([tabTitle isEqualToString:@"Events"]) {
      }else{
        viewController.tabBarItem.image = [UIImage imageNamed:iconName];
        
    }
    
    return theNavigationController ;
}

-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage frame:(CGRect)frame tag:(int)tag
{
    [[tabBarController.view viewWithTag:tag]removeFromSuperview];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    NSLog(@"frame %f==%f===%f===%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    button.frame = frame;//CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height+40);
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateSelected];
    [button addTarget:self action:@selector(centerButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat heightDifference = tabBarController.tabBar.frame.size.height + tabBarController.tabBar.frame.origin.y - frame.size.height;
    frame.origin.y = heightDifference;
    [button setFrame:frame];
    
    
    [button setUserInteractionEnabled:NO];
    
    [button setTag:tag];
    [tabBarController.view addSubview:button];
}
-(void)centerButtonTapped:(id)sender{
    [tabBarController setSelectedIndex:2];
}

-(UIImage *)getImage:(UIImage *)topImage width:(float)width{
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, topImage.size.height*2), NO, 0.0);
    
    // Create a stretchable image for the top of the background and draw it
    UIImage* stretchedTopImage = [topImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [stretchedTopImage drawInRect:CGRectMake(0, 0, width, topImage.size.height)];
    
    // Draw a solid black color for the bottom of the background
    [[UIColor blackColor] set];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, topImage.size.height, width, topImage.size.height));
    
    // Generate a new image
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}
- (void)setupPortraitUserInterface{
    
    mAllowSelectTab = NO;
    
    if ([[tabBarController.view subviews]containsObject:mHomeViewController.view]) {
        [mHomeViewController.view removeFromSuperview];
    }
    
    mHomeViewController = [[ProductSearchHome alloc] initWithNibName:@"ProductSearchHome" bundle:nil];
    
    mHomeViewController.view.frame = CGRectMake(0, 0, 320, isIPhone5?519:433);
    
    
    [tabBarController.view addSubview:mHomeViewController.view];
    
    
    NSMutableArray *localViewControllersArray = [[NSMutableArray alloc] initWithCapacity:5];
    UINavigationController *localNavigationController;
    localNavigationController =
    [self createNavControllerWrappingViewControllerOfClass:[ShoppingViewController class] nibName:@"CustomTable" tabIconName:@"shopping_normal.png"tabIconNameSected:@"shopping_selected.png" frame:CGRectMake(1, 0, 63, 50) tag:First_Button_Tag];
    [localViewControllersArray addObject:localNavigationController];
    
    
    
    localNavigationController = [self createNavControllerWrappingViewControllerOfClass:[SearchScreenViewController class] nibName:@"SearchScreenViewController" tabIconName:@"search_normal.png"tabIconNameSected:@"search_selected.png" frame:CGRectMake(65, 0, 63, 50) tag:Second_Button_Tag];
    [localViewControllersArray addObject:localNavigationController];
    
    localNavigationController = [self createNavControllerWrappingViewControllerOfClass:[MenuScreenViewController class] nibName:@"MenuScreenViewController" tabIconName:@"Menu_normal.png"tabIconNameSected:@"Menu_selected.png" frame:CGRectMake(125, 0, 70, 60) tag:Third_Button_Tag];
    [localViewControllersArray addObject:localNavigationController];
    
    localNavigationController = [self createNavControllerWrappingViewControllerOfClass:[DealScreenViewController class] nibName:@"DealScreenViewController" tabIconName:@"Deal_normal.png"tabIconNameSected:@"Deal_selected.png" frame:CGRectMake(320-128, 0, 63, 50) tag:Forth_Button_Tag];
    [localViewControllersArray addObject:localNavigationController];
    
    localNavigationController = [self createNavControllerWrappingViewControllerOfClass:[ParkScreenViewController class] nibName:@"ParkScreenViewController" tabIconName:@"Park_normal.png"tabIconNameSected:@"Park_selected.png" frame:CGRectMake(320-64, 0, 63, 50) tag:Fifth_Button_Tag];
    [localViewControllersArray addObject:localNavigationController];
    
    self.viewsArray = localViewControllersArray;
    
    
    
    tabBarController.viewControllers = localViewControllersArray;
    
    [tabBarController setSelectedIndex:2];
    tabBarController.tabBar.hidden = YES;
    tabBarController.hidesBottomBarWhenPushed = YES;


    
//    tabBarController.tabBar.frame = CGRectMake(0, 100, 320, 49);
    
    
    

    
}


- (void)setupPortraitUserInterface_PreviousCode
{
    NSLog(@">>>>>>>>>>>>>>>>.setupPortraitUserInterface");
    
    
    
    UINavigationController *localNavigationController;
    NSMutableArray *localViewControllersArray = [[NSMutableArray alloc] initWithCapacity:4];
    
    
    localNavigationController = [self createNavControllerWrappingViewControllerOfClass:[ShoppingViewController class] nibName:@"CustomTable" tabIconName:@"Tab1.png" tabTitle:@"Shopping"];
    [localViewControllersArray addObject:localNavigationController];
    [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_selected", localNavigationController, @"viewController",@"主页",@"title", nil],
    
    localNavigationController =nil;
    if(isDinning)
    {
        localNavigationController = [self createNavControllerWrappingViewControllerOfClass:[DiningViewController class] nibName:@"CustomTable" tabIconName:@"Tab2.png" tabTitle:@"Dining"];
        [localViewControllersArray addObject:localNavigationController];
        localNavigationController =nil;
    }
    
    localNavigationController = [self createNavControllerWrappingViewControllerOfClass:[EventsViewController class] nibName:@"EventsViewController" tabIconName:@"Tab3.png" tabTitle:@"Events"];
    
    
    [localViewControllersArray addObject:localNavigationController];
    localNavigationController =nil;
    
    localNavigationController = [self createNavControllerWrappingViewControllerOfClass:[SalesViewController class] nibName:@"SalesViewController" tabIconName:@"Tab4.png" tabTitle:@"Deals"];
    [localViewControllersArray addObject:localNavigationController];
    localNavigationController =nil;
    
    localNavigationController = [self createNavControllerWrappingViewControllerOfClass:[MoreViewController class] nibName:@"CustomTable" tabIconName:@"Tab5.png" tabTitle:@"More"];
    [localViewControllersArray addObject:localNavigationController];
    localNavigationController =nil;
    
    tabBarController.viewControllers = localViewControllersArray;
    NSLog(@"yyyyyyyyyyyyy");
    localNavigationController =nil;
    
    
    
    if (is_iOS7) {
        [tabBarController.tabBar setTintColor:[UIColor blackColor]];
        [tabBarController.tabBar setBackgroundColor:[UIColor whiteColor]];
    }
    
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor blackColor], UITextAttributeTextColor,
      [UIFont fontWithName:@"font" size:0.0], UITextAttributeFont,nil]forState:UIControlStateHighlighted];
}

-(void)setFrameForTabBar{
    if (isIPhone5) {

        for(UIView *view in self.tabBarController.view.subviews)
        {
            if([view isKindOfClass:[UITabBar class]])
            {
                [view setFrame:CGRectMake(0, 536, 320, 20)];
            }
            else
            {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 586)];
            }
        }
        
    }
}



#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                             settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                             categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    // Override point for customization after application launch.
    
    
    // Handle launching from a notification
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        // Show Alert Here
        
    }
 

    
    application.applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
    
    
    [self checkForSameVersion];
    NSDictionary *appDefaults = @{kAllowTracking: @(YES)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];

    _localiBeaconmsg=[[NSMutableArray alloc] init];
    
    
    // Override point for customization after application launch.
//    [window makeKeyAndVisible];
    
    tabBarController.delegate = self;
    tabBarController.hidesBottomBarWhenPushed = YES;
    
    
    refreshShopping=YES;
    refreshDining=YES;
    refreshEvents=YES;
    refreshSpecials=YES;
    refreshMore=YES;
    
    storeListContent=[[NSMutableArray alloc]init];
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"viewShow"])
    {
        LocationViewController *loaction = [[LocationViewController alloc]initWithNibName:@"LocationViewController" bundle:nil];
        loaction.presentMainView = YES;
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"mallData"] isKindOfClass:[NSData class]])
            loaction.shouldReload = NO;
        
        navController = [[UINavigationController alloc]initWithRootViewController:loaction];
    }else
    {
        IntroductionView *loaction = [[IntroductionView alloc]initWithNibName:@"IntroductionView" bundle:nil];
        
        navController = [[UINavigationController alloc]initWithRootViewController:loaction];
    }
    
   
    
    navController.navigationBarHidden= TRUE;

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
//    [window addSubview:navController.view];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    vc_MenuView = [[MenuView alloc]initWithNibName:@"MenuView" bundle:[NSBundle mainBundle]];

    
    sideMenuV = [[SideMenu alloc] customInit];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    /////////////////////////////////////
    
    self.x=0;
    
//    self.tabBarController.tabBar.frame = CGRectMake(0, 0, 0, 0);
    
    UILocalNotification *notification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    BOOL isNotificationsManagerNotification = [MNNotificationsManager processLocalNotification:notification];
    if (isNotificationsManagerNotification) {
        NSLog(@"Notifications Manager has processed the local notification for us, it was a Notifications SDK generated local notification");
    } else {
        NSLog(@"Notifications Manager has not processed the local notification %@", notification.userInfo);
    }
    
    return YES;
}

-(void)ShowMenuViewOnTop
{
//    [window addSubview:self.vc_MenuUpperview];
    
    [window addSubview:self.sideMenuV];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.sideMenuV.nameLabel.text = [mallData objectForKey:@"name"];

    });
    self.sideMenuV.frame = CGRectMake(self.window.frame.size.width, self.sideMenuV.frame.origin.y, self.sideMenuV.frame.size.width, self.sideMenuV.frame.size.height);
    NSLog(@"self %@",self.sideMenuV);
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: 2
                     animations:^{
                         [window bringSubviewToFront:self.sideMenuV];

                         self.sideMenuV.center = CGPointMake(self.window.frame.size.width/2, self.window.frame.size.height/2);
                     }
                     completion:^(BOOL finished){
                         [tabBarController.view removeFromSuperview];
                     }];
}


-(void)HideMenuViewOnTop
{
    [self.window addSubview:tabBarController.view];
    [self.window bringSubviewToFront:self.sideMenuV];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: 2
                     animations:^{
                         self.sideMenuV.frame = CGRectMake(self.window.frame.size.width, self.sideMenuV.frame.origin.y, self.sideMenuV.frame.size.width, self.sideMenuV.frame.size.height);

                     }
                     completion:^(BOOL finished){
                         [self.sideMenuV removeFromSuperview];
                     }];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        
    }];
    
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Do the work associated with the task.
        
        if (navController.viewControllers.count) {

            
        }else{
            [application endBackgroundTask:bgTask];
            bgTask = UIBackgroundTaskInvalid;
        }

    });
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application endBackgroundTask:bgTask];
    
    NSInteger *badgecount=[[UIApplication sharedApplication] applicationIconBadgeNumber];
    if ((int)badgecount>0)
    {
        
        for(int i=0;[_localiBeaconmsg count]>i;i++)
        {
            [self showAlert:[_localiBeaconmsg objectAtIndex:i] title:@"" buttontitle:@"ok"];
        }
    }
    [_localiBeaconmsg removeAllObjects];
    application.applicationIconBadgeNumber = 0;
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
    
}





-(BOOL)checkImage:(UIImage*)myImage
{
    UIImage *blank=[UIImage imageNamed:@""];
    if(UIImagePNGRepresentation(myImage)==UIImagePNGRepresentation(blank))
        return NO;
    
    return YES;
}

-(void) showNetworkIndicator:(BOOL)show{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = show;
}

- (void)showAlert:(NSString *)msg title:(NSString *)title buttontitle:(NSString *)buttontitle{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:title
                          message:msg
                          delegate:self
                          cancelButtonTitle:buttontitle
                          otherButtonTitles:nil];
    [alert show];
}


-(void)showTabBar:(BOOL)animated {
    
    return;
    if (animated) {
        [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            for(UIView *view in self.tabBarController.view.subviews)
            {
                if ([view isKindOfClass:[UIButton class]]) {
                    CGFloat heightDifference = tabBarController.tabBar.frame.size.height + tabBarController.tabBar.frame.origin.y - view.frame.size.height;
                    CGRect frame = view.frame;
                    frame.origin.y = heightDifference;
                    [view setFrame:frame];
                }else
                    if([view isKindOfClass:[UITabBar class]])
                    {
                        
                        NSLog(@"kuldeepyes1");
                        [view setFrame:CGRectMake(view.frame.origin.x, isIPhone5?520:431, view.frame.size.width, view.frame.size.height)];
                    }
                    else
                    {
                        NSLog(@"kuldeepyes2");
                        [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, isIPhone5?520:431)];
                    }
            }
        } completion:^(BOOL finished) {
            
        }];
    } else {
        
        for(UIView *view in self.tabBarController.view.subviews)
        {
            if ([view isKindOfClass:[UIButton class]]) {
                CGFloat heightDifference = tabBarController.tabBar.frame.size.height + tabBarController.tabBar.frame.origin.y - view.frame.size.height;
                CGRect frame = view.frame;
                frame.origin.y = heightDifference;
                [view setFrame:frame];
            }else
                if([view isKindOfClass:[UITabBar class]])
                {
                    NSLog(@"kuldeepyes3");
                    [view setFrame:CGRectMake(view.frame.origin.x,isIPhone5?520:431, view.frame.size.width, view.frame.size.height)];
                }
                else
                {
                    NSLog(@"kuldeepyes4");
                    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, isIPhone5?520:431)];
                }
        }
    }
    
}

-(void)hideTabBar:(BOOL)animated {
    return;
    if (animated) {
        [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            for(UIView *view in self.tabBarController.view.subviews)
            {
                if([view isKindOfClass:[UITabBar class]] || [view isKindOfClass:[UIButton class]])
                {
                    [view setFrame:CGRectMake(view.frame.origin.x, isIPhone5?586:480, view.frame.size.width, view.frame.size.height)];
                }
                else
                {
                    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, isIPhone5?586:480)];
                }
            }
        } completion:^(BOOL finished) {
            
        }];
    } else {
        for(UIView *view in self.tabBarController.view.subviews)
        {
            if([view isKindOfClass:[UITabBar class]] || [view isKindOfClass:[UIButton class]])
            {
                
                
                [view setFrame:CGRectMake(view.frame.origin.x, isIPhone5?586:480, view.frame.size.width, view.frame.size.height)];
                
                
                
            }
            else
            {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, isIPhone5?586:480)];
            }
            
        }
    }
}

-(void)tabBarController:(UITabBarController *)tabBarControllers didSelectViewController:(UIViewController *)viewController {
    NSLog(@"didselect tab %d",(int)[tabBarControllers selectedIndex]);
    
    
    int  i = (int)[tabBarControllers selectedIndex];
    
    [((UIButton *)[tabBarController.view viewWithTag:First_Button_Tag])setSelected:i==0?YES:NO];
    [((UIButton *)[tabBarController.view viewWithTag:Second_Button_Tag])setSelected:i==1?YES:NO];
    [((UIButton *)[tabBarController.view viewWithTag:Third_Button_Tag])setSelected:i==2?YES:NO];
    [((UIButton *)[tabBarController.view viewWithTag:Forth_Button_Tag])setSelected:i==3?YES:NO];
    [((UIButton *)[tabBarController.view viewWithTag:Fifth_Button_Tag])setSelected:i==4?YES:NO];
    
    if (!isDinning) {
        
        if (i!=0) {
            i=i+1;
        }
    }
    NSLog(@"kkkkkkkkkkkk index no %d",i);
    switch (i) {
        case 0:
            [tracker set:kGAIScreenName value:@"Home Screen"];
            
            // Send a screenview.
            [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
            break;
        case 1:
            [tracker set:kGAIScreenName value:@"Search"];
            
            // Send a screenview.
            [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
            
            break;
        case 2:
            [tracker set:kGAIScreenName value:@"Menu"];
            
            // Send a screenview.
            [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
            break;
        case 3:
            [tracker set:kGAIScreenName value:@"Deals"];
            
            // Send a screenview.
            [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
            break;
        case 4:
            [tracker set:kGAIScreenName value:@"Park"];
            
            // Send a screenview.
            [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
            break;
        default:
            break;
    }
    
    
}

- (BOOL) tabBarController:(UITabBarController *)tabBController shouldSelectViewController:(UIViewController *)viewController
{
    
    NSLog(@"show view %@,,,,%@",viewController,tabBController);
    if (!mAllowSelectTab )
    {
        [self hideProductScreen:YES];
        [mHomeViewController hideMoreInfo:nil];
        mAllowSelectTab = YES;
    }
    return YES;
}

// Here we detect if UITabBarController wants to select one of the tabs and set back to unselected.
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (!mAllowSelectTab)
    {
        if (object == tabBarController && [keyPath isEqualToString:@"selectedViewController"])
        {
            NSNumber *changeKind = [change objectForKey:NSKeyValueChangeKindKey];
            
            if ([changeKind intValue] == NSKeyValueChangeSetting)
            {
                NSObject *newValue = [change objectForKey:NSKeyValueChangeNewKey];
                
                if ([newValue class] != [NSNull class])
                {
                    tabBarController.selectedViewController = nil;
                }
            }
        }
    }
}




-(void)checkForSameVersion{
    NSString* currentAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *previousVersion = [defaults objectForKey:@"appVersion"];
    
    NSLog(@"currentAppVersion = %@ \n previousVersion = %@",currentAppVersion,previousVersion);
    if (!previousVersion) {
        // first launch
        NSDictionary * dict = [defaults dictionaryRepresentation];
        for (id key in dict) {
            [defaults removeObjectForKey:key];
        }
        
        // ...
        NSLog(@"1");
        [defaults setObject:currentAppVersion forKey:@"appVersion"];
        [defaults synchronize];
        [self deleteDataBase];
        
    } else if ([previousVersion isEqualToString:currentAppVersion]) {
        // same version
        NSLog(@"2");
        
        
    } else {
        // other version
        
        // ...
        NSLog(@"3");
        NSDictionary * dict = [defaults dictionaryRepresentation];
        for (id key in dict) {
            [defaults removeObjectForKey:key];
        }
        
        [defaults setObject:currentAppVersion forKey:@"appVersion"];
        [defaults synchronize];
        [self deleteDataBase];
        
    }
}
-(void)deleteDataBase{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"PreitDB.sqlite"];
    NSLog(@"writeablepath==%@",writableDBPath);
    BOOL success = [fileManager fileExistsAtPath:writableDBPath];
    
    if (success) {
        [fileManager removeItemAtPath:writableDBPath error:NULL];
        
    }
    
}

-(void)hideProductScreen:(BOOL)hide{
    mAllowSelectTab = NO;
    [mHomeViewController.view setHidden:hide];
}

- (void)initilizeBeacon {
    MNAppKey *appKey = [[MNAppKey alloc] initWithAppKey:@"0b47040c219cb0b632a538e1c907dbd5" andSecretKey:@"18e7d79d401c2dd84e74296cb42c510d"];
    self.notificationsDelegate = [[MNNotificationsManagerCustomDelegate alloc] init];
    
    // MNNotificationsManager instantiation
    [MNNotificationsManager notificationsManagerWithAppKey:appKey
                                                   options:nil
                                                      user:nil
                                                  delegate:self.notificationsDelegate
                                         completionHandler:^(MNNotificationsManager *notificationsManager, NSError *error)
    {
        if (!error) {
            NSLog(@"NMNotificationsManager instantiation success");
            self.notificationsManager = notificationsManager;
            [self.notificationsManager start];
            
            MNNMOptions *options = [[MNNMOptions alloc] init];
            options.statsTrackingValues = @{@"specificapp" : @"Preit"};
            
        }
        else {
            NSLog(@"NMNotificationsManager instantiation error: %@", error.localizedDescription);
        }
    }];
     
    
//    if (self.beaconRequestManager)
//        [self.beaconRequestManager removeRequestManager];
//    else{
//        self.beaconRequestManager = [[BeaconRequestManager alloc]init];
//        [self.beaconRequestManager addingNotification];
//    }
//    
//    
//    NSString *url=[NSString stringWithFormat:@"%@/ibeacons",[self.mallData objectForKey:@"resource_url"]];
//    
//
//    [self.beaconRequestManager intWithUrl:url];
    
}
- (void)disableBeacon {
    [self.notificationsManager stop];
    self.notificationsManager = nil;
//    [self.beaconRequestManager removeRequestManager];
}

-(void)showLocalNotificationsWithMessage:(NSString *)message :(NSString*)beacon_id{
    
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground) {
        [[UIAlertView showWithTitle:@"" message:message cancelButtonTitle:@"Dismiss" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
        }]show];
        return;
    }
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    
    localNotif.fireDate =[NSDate dateWithTimeIntervalSinceNow:30];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.repeatInterval = 0;
    localNotif.alertBody = message;
    [localNotif setUserInfo:@{@"beacon_id":beacon_id}];
    [_localiBeaconmsg addObject:message];
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    int badgeVal=(int)[[UIApplication sharedApplication] applicationIconBadgeNumber]+1;
    
    localNotif.applicationIconBadgeNumber= badgeVal;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

-(void)setlocationNotifcation{
    
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    
    localNotif.fireDate =[NSDate dateWithTimeIntervalSinceNow:15];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.repeatInterval = 0;
    localNotif.alertBody = @" mymessage";
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    int badgeVal=(int)[[UIApplication sharedApplication] applicationIconBadgeNumber]+1;
    
    localNotif.applicationIconBadgeNumber= badgeVal;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [tracker send:
    [[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                             action:@"notification_read"
                                              label:[notification.userInfo valueForKey:@"beacon_id"]
                                              value:nil] build]];
    
    BOOL isNotificationsManagerNotification = [MNNotificationsManager processLocalNotification:notification];
    if (isNotificationsManagerNotification) {
        NSLog(@"SDK owned local notification, do nothing");
    } else {
        NSLog(@"SDK did not process the notification");
        // Process the notification
    }
}



@end
