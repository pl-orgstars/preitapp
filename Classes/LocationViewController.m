//
//  LocationViewController.m
//  Preit
//
//  Created by Aniket on 10/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LocationViewController.h"
#import "LoadingAgent.h"
#import "HomeScreen.h"
#import "MapViewController.h"
#import "JSBridgeViewController.h"


#import "RequestAgent.h"

#import "JSON.h"
#import "UIAlertView+Blocks.h"
@implementation LocationViewController
{
    BOOL isNotificationShown;
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	delegate=(PreitAppDelegate *)[[UIApplication sharedApplication]delegate];

//	[[LoadingAgent defaultAgent]makeBusy:YES];
//	locationController = [[MyCLController alloc] init];
//	locationController.delegate = self;		
	
//	if(locationController.locationManager.locationServicesEnabled)
//	{
//		
//	}
//	[locationController.locationManager startUpdatingLocation];	
	
//	HomeScreen *screenHome=[[HomeScreen alloc]initWithNibName:@"HomeScreen" bundle:nil];
//	[self.navigationController pushViewController:screenHome animated:YES];
//	[screenHome release];

	pickerItem=[[NSArray alloc]initWithObjects:@"10",@"20",@"30",@"40",@"50",@"60",@"70",@"80",@"90",@"100",@"110",@"120",@"130",@"140",@"150",@"160",@"170",@"180",@"190",@"200",nil];
	radiusSelected=4;
	
}

-(void)viewWillAppear:(BOOL)animated
{

    [locationController.locationManager stopUpdatingLocation];

    delegate.mallData = nil;
    
	isFirstTime=YES;
    
    isNotificationShown = NO;

    
    
	self.navigationController.navigationBar.hidden=YES;

    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"mallData"]isKindOfClass:[NSData class]] && !delegate.isOnForeGround && !_shouldReload) {
       NSData *data2 = [[NSUserDefaults standardUserDefaults]objectForKey:@"mallData"];
       NSDictionary *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data2];

        if (is_LOCATION_SERVICE_ON) {
            isFirstTime = NO;
            [self startLocatioService];
        }
        [self fetchData:arr];

   }
    
    else{
        
        if (is_PUSH_NOTIFICATION_ON) {
            [self alertForGPs];
        }else{
            [[UIAlertView showWithTitle:NSLocalizedString(@"PushNotification_title",@"") message:NSLocalizedString(@"PushNotification_message",@"") cancelButtonTitle:@"Don't Allow" otherButtonTitles:@[@"OK"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [Utils setPushNotificationForApp:YES];
                }else{
                    [Utils setPushNotificationForApp:NO];
                }
                [self alertForGPs];
                
            }]show];
        }
        


    
    
    
	
//    [alert release];
   }
}
-(void)startLocatioService{
    if(CLLocationManager.locationServicesEnabled)
    {
        [Utils setLocationServiceForApp:YES];
        isLocationEnabled = YES;
        [[LoadingAgent defaultAgent]makeBusy:YES];
        locationController = [[MyCLController alloc] init];
        locationController.delegate = self;
        [locationController.locationManager startUpdatingLocation];
    }
    else
    {
        [Utils setLocationServiceForApp:NO];
        //            You have disabled location services for this app. If you'd like to take advantage of this app's location services in the future, please enable them in the Settings application
        isLocationEnabled = NO;
        
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"mallData"]isKindOfClass:[NSData class]] && !delegate.isOnForeGround)
        {
            [[UIAlertView showWithTitle:@"Message" message:@"Your Location services are disabled.Please enable location services from the Settings application by toggling the Location Services switch in General or continue without using location?" cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                [Utils setLocationServiceForApp:NO];
            }]show];
        
        }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Your Location services are disabled.Please enable location services from the Settings application by toggling the Location Services switch in General or continue without using location?" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Try Again",nil];
        //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"You have disabled location services for this app. If you'd like to take advantage of this app's location services in the future, please enable them in the Settings application" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Ok",nil];
        [alert show];
        }
        //			[alert release];
    }
}
-(void)alertForGPs{
    [self startLocatioService];
//    [[UIAlertView showWithTitle:@"Message" message:NSLocalizedString(@"Gps",@"") cancelButtonTitle:@"Don't Allow" otherButtonTitles:@[@"OK"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//
//        
//        if (buttonIndex == 1) {
//            [self startLocatioService];
//            [Utils setLocationServiceForApp:YES];
//
//        }else{
//            isLocationEnabled = NO;
//            [self getDataFromServer];
//            [Utils setLocationServiceForApp:NO];
//        }
//        
//    }]show];
    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:NSLocalizedString(@"Gps",@"") delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
//    [alert show];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - MainView Method

- (void)showMainViewController {
    ProductSearchHome *productSearchVC = [[ProductSearchHome alloc] initWithNibName:@"ProductSearchHome" bundle:nil];
    productSearchVC.view.frame = CGRectMake(0, 0, 320, isIPhone5?568:480);
    
    UINavigationController *navCont = [[UINavigationController alloc] initWithRootViewController:productSearchVC];
    navCont.navigationBarHidden = YES;
    
    MenuScreenViewController *sideMenu = [[MenuScreenViewController alloc] initWithNibName:@"MenuScreenViewController" bundle:[NSBundle mainBundle]];
    sideMenu.navController = navCont;
    
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController containerWithCenterViewController:navCont
                                                                                                 leftMenuViewController:nil
                                                                                                rightMenuViewController:sideMenu];
    container.rightMenuWidth = 320.0;
    [self presentViewController:container animated:YES completion:nil];
}

//- (void)dealloc {	
//    [super dealloc];
//}

#pragma mark UIAlertView delegate methods

//-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//	if([[alertView buttonTitleAtIndex:buttonIndex] compare:@"Try again"] == NSOrderedSame)
//	{
//		[self viewDidLoad];
//	}
//	else if([[alertView buttonTitleAtIndex:buttonIndex] compare:@"Continue"] == NSOrderedSame)
//	{
//		HomeScreen *screenHome=[[HomeScreen alloc]initWithNibName:@"HomeScreen" bundle:nil];
//		[self.navigationController pushViewController:screenHome animated:YES];
//		[screenHome release];
//	}
//}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	BOOL flag=NO;
	if([[alertView buttonTitleAtIndex:buttonIndex] compare:@"Yes"] == NSOrderedSame)
	{

		if(CLLocationManager.locationServicesEnabled)
		{
            isFirstTime = NO;
            
            isLocationEnabled = YES;
			[[LoadingAgent defaultAgent]makeBusy:YES];
			locationController = [[MyCLController alloc] init];
			locationController.delegate = self;
			[locationController.locationManager startUpdatingLocation];
		}
		else
		{
//            You have disabled location services for this app. If you'd like to take advantage of this app's location services in the future, please enable them in the Settings application
			UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Your Location services are disabled.Please enable location services from the Settings application by toggling the Location Services switch in General or continue without using location?" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Try Again",nil];
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"You have disabled location services for this app. If you'd like to take advantage of this app's location services in the future, please enable them in the Settings application" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Ok",nil];
			[alert show];
//			[alert release];
		}
        
	}
	else if([[alertView buttonTitleAtIndex:buttonIndex] compare:@"Try Again"] == NSOrderedSame)
	{
        [self startLocatioService];
//		[[LoadingAgent defaultAgent]makeBusy:YES];
//		locationController=nil;
//		locationController = [[MyCLController alloc] init];
//		locationController.delegate = self;
//		[locationController.locationManager startUpdatingLocation];
	}
	else if([[alertView buttonTitleAtIndex:buttonIndex] compare:@"Continue"] == NSOrderedSame)
	{
		flag=YES;
	}
	else if([[alertView buttonTitleAtIndex:buttonIndex] compare:@"No"] == NSOrderedSame)
	{
        //change
		flag=YES;
        //		MapViewController *screenMap=[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
        //		screenMap.mapUrl=@"http://sabdekho.com:3010/api/v1/properties/24/areas/getarea?suit_id=7562";
        //		[self.navigationController pushViewController:screenMap animated:YES];
        //		[screenMap release];
		
        //		JSBridgeViewController *screenMap=[[JSBridgeViewController alloc]initWithNibName:@"JSBridgeViewController" bundle:nil];
        //		[self.navigationController pushViewController:screenMap animated:YES];
        //		[screenMap release];
        //		return;
	}
	else if(alertView.tag==100 && [[alertView buttonTitleAtIndex:buttonIndex] compare:@"Ok"] == NSOrderedSame)
	{
//        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"mallData"]isKindOfClass:[NSData class]] && !delegate.isOnForeGround)
//        {
//            flag = NO;
//        }else{
            flag = YES;
//        }
        
		
	}
	else if([[alertView buttonTitleAtIndex:buttonIndex] compare:@"Ok"] == NSOrderedSame)
	{
		flag=NO;
	}
	
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"mallData"]isKindOfClass:[NSData class]] && !delegate.isOnForeGround){
        
    }else
	if(flag)
	{
        isLocationEnabled = NO;
        [self getDataFromServer];
//		HomeScreen *screenHome=[[HomeScreen alloc]initWithNibName:@"HomeScreen" bundle:nil];
//		self.navigationItem.title=@"Back";
//		[self.navigationController pushViewController:screenHome animated:YES];
//		[screenHome release];
	}
	
}

//-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
////	BOOL flag=NO;	
////	if([[alertView buttonTitleAtIndex:buttonIndex] compare:@"Yes"] == NSOrderedSame)
////	{		
////		if(CLLocationManager.locationServicesEnabled)
////		{
////			[[LoadingAgent defaultAgent]makeBusy:YES];
////			locationController = [[MyCLController alloc] init];
////			locationController.delegate = self;	
////			[locationController.locationManager startUpdatingLocation];
////		}
////		else 
////		{	
////			UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Your Location services are disabled.Please enable location services from the Settings application by toggling the Location Services switch in General or continue without using location?" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Ok",nil];
////			[alert show];
////			[alert release];
////		}
////
////	}
//    
////	else if([[alertView buttonTitleAtIndex:buttonIndex] compare:@"Try Again"] == NSOrderedSame)
////	{
////		[[LoadingAgent defaultAgent]makeBusy:YES];
////		locationController=nil;
////		locationController = [[MyCLController alloc] init];
////		locationController.delegate = self;	
////		[locationController.locationManager startUpdatingLocation];
////	}
////	else if([[alertView buttonTitleAtIndex:buttonIndex] compare:@"Continue"] == NSOrderedSame)
////	{
////		flag=YES;
////	}
////	else if([[alertView buttonTitleAtIndex:buttonIndex] compare:@"No"] == NSOrderedSame)
////	
////    
////    {
//	
//    //change
//        flag=NO;
//		
//        
////        [[LoadingAgent defaultAgent]makeBusy:YES];
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"You have disabled location services for this app. If you'd like to take advantage of this app's location services in the future, please enable them in the Settings application." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        alert.tag = 20;
//        
//        [alert show];
//        
//        [alert release];
////		MapViewController *screenMap=[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
////		screenMap.mapUrl=@"http://sabdekho.com:3010/api/v1/properties/24/areas/getarea?suit_id=7562";
////		[self.navigationController pushViewController:screenMap animated:YES];
////		[screenMap release];
//		
////		JSBridgeViewController *screenMap=[[JSBridgeViewController alloc]initWithNibName:@"JSBridgeViewController" bundle:nil];
////		[self.navigationController pushViewController:screenMap animated:YES];
////		[screenMap release];
////		return;
//	}
//	else if(alertView.tag==100 && [[alertView buttonTitleAtIndex:buttonIndex] compare:@"Ok"] == NSOrderedSame)
//	{
//		flag=YES;
//	}
//	else if([[alertView buttonTitleAtIndex:buttonIndex] compare:@"Ok"] == NSOrderedSame)
//	{
//        if (alertView.tag == 20) {
////            [[LoadingAgent defaultAgent]makeBusy:NO];
//            flag =YES;
//        }else
//		flag=NO;
//	}
////    else if([[alertView buttonTitleAtIndex:buttonIndex] compare:@"Ok"] == NSOrderedSame && alertView.tag == 20)
////	{
////		flag=YES;
////	}
//	
//	if(flag)
//	{
//		HomeScreen *screenHome=[[HomeScreen alloc]initWithNibName:@"HomeScreen" bundle:nil];
//		self.navigationItem.title=@"Back";
//		[self.navigationController pushViewController:screenHome animated:YES];
//		[screenHome release];
//	}
//
//
//}

#pragma mark Location methods

- (void)locationUpdate:(CLLocation *)location {
	[locationController.locationManager stopUpdatingLocation];
    coordinates=[location coordinate];
	[[LoadingAgent defaultAgent]makeBusy:NO];
	
	delegate.latitude = coordinates.latitude;//=39.9581;
	delegate.longitude = coordinates.longitude;//=-77.5772;
	
	// isFirstTime checks that the screen is loaded only once not multiple times sometimes the loaction updates very quickly before it can be stopped.
	if(isFirstTime)
	{
		isFirstTime=NO;
		// use whatever lat / long values or CLLocationCoordinate2D you like here.
//		CLLocationCoordinate2D locationToLookup = {latitude,longitude};
//		MKReverseGeocoder *reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:locationToLookup];
//		reverseGeocoder.delegate = self;
//		[reverseGeocoder start];		
		[self showActionSheet];
	}
    [self prefomLocalNotification];
    
    
//    [self performSelector:@selector(updateLocation) withObject:nil afterDelay:1 inModes:<#(NSArray *)#>]
    

//    [self performSelectorInBackground:@selector(prefomLocalNotification) withObject:nil];
}
-(void)updateLocation{
    NSLog(@"12323423423434434231234123");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSTimer* t = [NSTimer scheduledTimerWithTimeInterval:30 target:self  selector:@selector(loctionUpdate) userInfo:nil repeats:NO];
        
        [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
        
        [[NSRunLoop currentRunLoop] run];
    });
    
    
}
-(void)loctionUpdate{
    [locationController.locationManager startUpdatingLocation];
}
- (void)locationError:(NSError *)error {
    [Utils setLocationServiceForApp:NO];
    
	[[LoadingAgent defaultAgent]makeBusy:NO];
	[locationController.locationManager stopUpdatingLocation];
	
	if ([[error domain] isEqualToString: kCLErrorDomain] && [error code] == kCLErrorDenied) 
	{
//		NSString *msg=@"You have disabled location services for PREIT app.To perfrom location based search in future please enable location services for PREIT app from the Settings application by toggling the Location Services switch for PREIT in General";
        NSString *msg=@"You have disabled location services for this app. If you'd like to take advantage of this app's location services in the future, please enable them in the Settings application";
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
		alert.tag=100;
		[alert show];
//		[alert release];
    }
	else if([[error domain] isEqualToString: kCLErrorDomain] && [error code] == kCLErrorLocationUnknown)
	{
#warning pata nhi kya tha ye.....
//		NSString *msg=@"Sorry an unknown error occured,would you like to try again or continue without location?";
//		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:msg delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Try Again",nil];
//		[alert show];
//		[alert release];
	}
	else 
	{
//		NSString *msg=[NSString stringWithFormat:@"%@,would you like to try again or continue without location?",[error localizedDescription]];
        NSString *msg=@"Error geting your location,would you like to try again or continue without location?";
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:msg delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Try Again",nil];
		[alert show];
//		[alert release];
	}
    
    
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder  didFindPlacemark:(MKPlacemark *)placemark
{	
	HomeScreen *screenHome=[[HomeScreen alloc]initWithNibName:@"HomeScreen" bundle:nil];
	self.navigationItem.title=@"Back";
	NSString *city=[placemark.addressDictionary objectForKey:@"City"];
	city=[city stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	screenHome.city=city;
    screenHome.presentMainView = _presentMainView;
    
	[self.navigationController pushViewController:screenHome animated:YES];

//	[screenHome release];
//	[geocoder release];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
//	[geocoder release];
	UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Error getting location.Would you like to try again or continue with no location?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Try again",@"Continue",nil];
	[alert	show];
//	[alert release];
}

#pragma mark UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	HomeScreen *screenHome=[[HomeScreen alloc]initWithNibName:@"HomeScreen" bundle:nil];
	self.navigationItem.title=@"Back";
	screenHome.coordinates=coordinates;
	screenHome.radius=[pickerItem objectAtIndex:radiusSelected];
    screenHome.presentMainView = _presentMainView;
	[self.navigationController pushViewController:screenHome animated:YES];
//	[screenHome release];
}

#pragma mark UIPickerView methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
	return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    radiusSelected=row;
}



- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
	return [pickerItem count];
	
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
	return [pickerItem objectAtIndex:row];
	
}
-(void)showActionSheet{
    [self getDataFromServer];
}
-(void)showActionSheet_previousCode
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Please select the radius(miles) for search" delegate:self cancelButtonTitle:@"Done" destructiveButtonTitle:nil otherButtonTitles:nil];
	[actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
	
	CGRect pickerFrame = CGRectMake(0, 110, 320, 400);
	
	UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
	pickerView.showsSelectionIndicator = YES;
	
	pickerView.dataSource = self;
	pickerView.delegate = self;
	
	[actionSheet addSubview:pickerView];
	[pickerView selectRow:radiusSelected inComponent:0 animated:YES];
//	[pickerView release];

	[actionSheet showInView:self.view];	
	[actionSheet setBounds:CGRectMake(0,0, 320, 480)];
//	[actionSheet release];
}


/////////////////////
/////////////////////
////////////////////
-(void)fetchData:(NSDictionary*)tmpDict{
    //    NSDictionary *tmpDict;//=[self.tableData objectAtIndex:indexPath.row];
    
    NSLog(@"appdelegate");
    //////kuldeep
    NSLog(@".............dictionare to prionnasjkdfnksa %@",tmpDict);
    
    delegate.mallData=tmpDict;
    delegate.mallId=[[tmpDict objectForKey:@"id"] longValue];
    [delegate.tabBarController setSelectedIndex:0];
    
    delegate.refreshShopping=!delegate.refreshShopping;
    delegate.refreshDining=!delegate.refreshDining;
    delegate.refreshEvents=!delegate.refreshEvents;
    delegate.refreshSpecials=!delegate.refreshSpecials;
    delegate.refreshMore=!delegate.refreshMore;
    [delegate.storeListContent removeAllObjects];
    
    delegate.website_url=[tmpDict objectForKey:@"website_url"];
    NSLog(@"website Url=====%@",delegate.website_url);
    NSString *dining=[tmpDict objectForKey:@"dining"];
    delegate.isDinning=[dining isEqualToString:@"no"]?NO:YES;
    NSString *movie=[tmpDict objectForKey:@"movie"];
    delegate.isMovie=[movie isEqualToString:@"no"]?NO:YES;
    
    
    
    NSString *url = [tmpDict objectForKey:@"website_resource_url"];
    
    NSLog(@"uuuuuuuuuuuuuu %@",url);
    [self showHudWithMessage:@"Please Wait..."];
    RequestAgent *req= [[RequestAgent alloc] init];// autorelease];
    [req requestToServer:self callBackSelector:@selector(requestSucceed:) errorSelector:@selector(requestFailed:) Url:url];
//    [[LoadingAgent defaultAgent]makeBusy:YES];
}
-(void)requestSucceed:(NSData *)receiveData{
    //	[indicator_ stopAnimating];
    //	self.navigationItem.hidesBackButton=NO;
    //	self.navigationItem.rightBarButtonItem.enabled=YES;
//    NSLog(@"rec daTA :: %@",receiveData);
	if(receiveData!=nil)
	{

		NSString *jsonString = [[NSString alloc] initWithBytes:[receiveData bytes] length:[receiveData length] encoding:NSUTF8StringEncoding];// autorelease];
		NSDictionary *tmpArray=[jsonString JSONValue];
        
        
        NSLog(@"kuldeep %@,  %@",tmpArray,[jsonString JSONValue]);
        NSDictionary *dict = [tmpArray valueForKey:@"website"];
        
        NSDictionary *dd= [dict valueForKey:@"settings"];
        
        
        NSString *tracerID= [dd valueForKey:@"ga_property_id_for_mobile"];
        
        
        delegate.tracker = nil;
        delegate.tracker = [[GAI sharedInstance] trackerWithTrackingId:tracerID];
        
        [GAI sharedInstance].defaultTracker = delegate.tracker;
        
        
        
        
        
        //        [GAI sharedInstance].defaultTracker =  [[GAI sharedInstance] trackerWithTrackingId:@"UA-39751767-1"];
        NSString *str = [NSString stringWithFormat:@"IOS %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] ];
        NSLog(@"version +++ === %@",str);
        //change google
      //  [delegate.tracker setAppVersion:str];
        
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:str];
        
        // Send a screenview.
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
    }
    [self hideHud];
    [delegate setupPortraitUserInterface];
//	[delegate.navController.view removeFromSuperview];
//    [delegate.window addSubview:delegate.tabBarController.view];
    
    if (_presentMainView)
        [self showMainViewController];
    else
        [self.navigationController popToRootViewControllerAnimated:YES];
    
    [delegate initilizeBeacon];
//    [self requestForImages];
}
-(void)requestFailed:(NSError *)error{
    //	[indicator_ stopAnimating];
    //	self.navigationItem.hidesBackButton=NO;
    //	self.navigationItem.rightBarButtonItem.enabled=YES;
    [self hideHud];
    
    [[UIAlertView showWithTitle:@"Message" message:@"Sorry there was some error.Please check your internet connection and try again" cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        NSData *data2 = [[NSUserDefaults standardUserDefaults]objectForKey:@"mallData"];
        NSDictionary *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
        
        //		[navController.view removeFromSuperview];
        //	[window addSubview:tabBarController.view];
        NSLog(@"aaaaaa");
        [self fetchData:arr];
    }]show];
    
    
//	[delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Message" buttontitle:@"Ok"];
}
- (NSString *)appNameAndVersionNumberDisplayString {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appDisplayName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *minorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    return [NSString stringWithFormat:@"%@, Version %@ (%@)",
            appDisplayName, majorVersion, minorVersion];
}
-(void)requestForImages{
    NSString *url=[NSString stringWithFormat:@"%@%@",[delegate.mallData objectForKey:@"resource_url"],NSLocalizedString(@"API_BgImages","")];
    //NSString *url=NSLocalizedString(@"API_BgImages",@"");
    NSLog(@"uuuuuuuuuuuuuu %@",url);
    RequestAgent *req=[[RequestAgent alloc] init];// autorelease];
    [req requestToServer:self callBackSelector:@selector(responseData_Image:) errorSelector:@selector(errorCallback_Image:) Url:url];
    //    [[LoadingAgent defaultAgent]makeBusy:YES];
    
    
}

-(void)responseData_Image:(NSData *)receiveData
{
    [self hideHud];
	NSString *jsonString = [[NSString alloc] initWithBytes:[receiveData bytes] length:[receiveData length] encoding:NSUTF8StringEncoding] ;//autorelease];
    
	NSArray *tmpArray=[jsonString JSONValue];
    
	delegate.imageLink1=nil;
	delegate.imageLink2=nil;
	delegate.imageLink3=nil;
	delegate.image1=nil;
	delegate.image2=nil;
	delegate.image3=nil;
	
	NSLog(@"tmpArray response Image===%@",tmpArray);
	if([tmpArray count])
	{
		NSDictionary *tmpDict=[tmpArray objectAtIndex:0];
        if([[tmpDict objectForKey:@"iphone"]objectForKey:@"shopping_image"]!=[NSNull null])
			delegate.imageLink1=[[tmpDict objectForKey:@"iphone"]objectForKey:@"shopping_image"];
		if([[tmpDict objectForKey:@"iphone"]objectForKey:@"dining_image"]!=[NSNull null])
			delegate.imageLink2=[[tmpDict objectForKey:@"iphone"]objectForKey:@"dining_image"];
		if([[tmpDict objectForKey:@"iphone"]objectForKey:@"general_image"]!=[NSNull null])
			delegate.imageLink3=[[tmpDict objectForKey:@"iphone"]objectForKey:@"general_image"];
        
	}
	[delegate setupPortraitUserInterface];
    [delegate.navController.view removeFromSuperview];
    
    [delegate.window addSubview:delegate.tabBarController.view];
    [delegate initilizeBeacon];
}

-(void)errorCallback_Image:(NSError *)error{
	NSLog(@"error");
    [self hideHud];
    //	[[LoadingAgent defaultAgent]makeBusy:NO];
    [delegate.navController.view removeFromSuperview];
    
    [delegate.window addSubview:delegate.tabBarController.view];
    [delegate initilizeBeacon];
}

-(void)getDataFromServer
{
    [self showHudWithMessage:@"Locating Nearest PREIT Mall"];
	NSString *url=[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Server",""),NSLocalizedString(@"API0","")];
	//NSLog(@"url====%@",url);
//	if(self.radius)
//		url=[NSString stringWithFormat:@"%@%?lat=%f&lng=%f&radius=%@",url,self.coordinates.latitude,self.coordinates.longitude,radius];
	
	self.navigationItem.hidesBackButton=YES;
	self.navigationItem.rightBarButtonItem.enabled=NO;
//	[indicator_ startAnimating];
    
	RequestAgent *req=[[RequestAgent alloc] init];// autorelease];
	[req requestToServer:self callBackSelector:@selector(responseData:) errorSelector:@selector(errorCallback:) Url:url];
}
-(void)responseData:(NSData *)receivedData{
//	[indicator_ stopAnimating];
    [self hideHud];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSLog(@"hereaaa");
	self.navigationItem.hidesBackButton=NO;
	self.navigationItem.rightBarButtonItem.enabled=YES;
    BOOL isNoData;
    
	if(receivedData!=nil)
	{
		NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];// autorelease];
		NSArray *tmpArray=[jsonString JSONValue];
		NSLog(@"tmpArray==%@",tmpArray);
//		[self.tableData removeAllObjects];
		if([tmpArray count]!=0){
			isNoData=NO;
			for(int i=0;i<[tmpArray count];i++)
			{
				NSDictionary *tmpDict=[tmpArray objectAtIndex:i];
				if(tmpDict && [tmpDict objectForKey:@"property"])
					[array addObject:[tmpDict objectForKey:@"property"]];
			}
            if (isLocationEnabled) {
                if ([self getDistance:array]) {
                    return;
                }

            }
            //			[self getDistance:array];
//			if(self.radius)
//				[self getDistance];
		}
		else
		{
			isNoData=YES;
			
		}
 	}
	else
		isNoData=YES;
    
    
    
    if (isNoData) {
        [self showAlertForNoData];
    }else {
        HomeScreen *screenHome=[[HomeScreen alloc]initWithNibName:@"HomeScreen" bundle:nil];
        self.navigationItem.title=@"Back";
        //        screenHome.coordinates=coordinates;
        //        screenHome.radius=[pickerItem objectAtIndex:radiusSelected];
        screenHome.isLocationEnabled = isLocationEnabled;
        screenHome.tableData = [[NSMutableArray alloc]initWithArray:array];
        screenHome.presentMainView = _presentMainView;
        [self.navigationController pushViewController:screenHome animated:YES];
    }
    

    
//	[tableHome reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
}


-(void)errorCallback:(NSError *)error{
    [self hideHud];
//	[indicator_ stopAnimating];
	self.navigationItem.hidesBackButton=NO;
	self.navigationItem.rightBarButtonItem.enabled=YES;
    [self showAlertForNoData];
//	[delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Message" buttontitle:@"Ok"];
}
-(void)showAlertForNoData{
    [[UIAlertView showWithTitle:@"" message:@"Sorry there was some error.Please check your internet connection and try again" cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        [self getDataFromServer];
    }]show];
}

-(BOOL)getDistance:(NSArray *)tableData
{

//    NSMutableArray *distanceData = [NSMutableArray new];
	for(int i=0;i<[tableData count];i++)
	{
		NSDictionary *tmpDict=[tableData objectAtIndex:i];
		
		if([tmpDict objectForKey:@"location_lat"] ==[NSNull null] || [tmpDict objectForKey:@"location_lng"]==[NSNull null] )
		{
//			[distanceData addObject:@"NA"];
		}
		else
		{
            double lat=[[tmpDict objectForKey:@"location_lat"]doubleValue];
			double lng=[[tmpDict objectForKey:@"location_lng"]doubleValue];
			
			CLLocation *userLoc = [[CLLocation alloc] initWithLatitude:delegate.latitude longitude:delegate.longitude];
			CLLocation *poiLoc = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
            
			double dist_KM = [poiLoc distanceFromLocation:userLoc]/1000;
            //			1 km = 0.621371192 miles
            
			double dist_Miles=dist_KM*0.621;
            
            if (dist_Miles <= 0.5) {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tmpDict];
                [defaults setObject:data forKey:@"mallData"];
                [defaults synchronize];
                [self fetchData:tmpDict];
                return YES;
            }
            
//			NSString *strDist = [NSString stringWithFormat:@"%.2f miles", dist_Miles];
            
            
            
//			[distanceData addObject:strDist];
            //			[userLoc release];
            //			[poiLoc release];
		}
	}
    return NO;
}

-(void)prefomLocalNotification{
    NSLog(@"1234567890");
    if (!is_PUSH_NOTIFICATION_ON) {
        return;
    }
    if (isNotificationShown) {
        return;
    }
    if (delegate.mallData) {
        
        NSString *location_message_end_at = [Utils checkForEmptyDatas:[delegate.mallData objectForKey:@"location_message_end_at"]]?@"":[delegate.mallData objectForKey:@"location_message_end_at"];
        
        
        NSString *location_message = [Utils checkForEmptyDatas:[delegate.mallData objectForKey:@"location_message"]]?@"":[delegate.mallData objectForKey:@"location_message"];
        NSLog(@"aaaaaaaaaaaaaaaaaa  %@ %@",location_message_end_at,location_message);
        if (![Utils checkForEmptyString:location_message_end_at] && ![Utils checkForEmptyString:location_message]) {
        
        
        
//        distance = .5;
        
            NSDateFormatter *format = [[NSDateFormatter alloc]init];
            [format setDateFormat:@"yyyy-MM-dd"];
            NSDate *date = [format dateFromString:location_message_end_at];
            
            
            if ([date compare:[[NSDate date]initWithTimeIntervalSinceNow:(-60*24*60)]] == NSOrderedDescending) {
                double distance = [Utils calculateDistance:[Utils getCLLocationCoordinate2DFromLatitude:[delegate.mallData objectForKey:@"location_lat"] longitude:[delegate.mallData objectForKey:@"location_lng"]] to:CLLocationCoordinate2DMake(delegate.latitude, delegate.longitude)];
                NSLog(@"distance from mall %f",distance);
                if (distance <= 1) {

//            "3/20/2014","location_message_end_date":"4/20/2014","location_message":"Hello people, you're close to the Cherry Hill Mall.
//            delegate.location_message_end_at = @"3/20/2014";
                    isNotificationShown = YES;
                    [locationController.locationManager stopUpdatingLocation];
                    
                    
                    UIApplication* app = [UIApplication sharedApplication];
                    NSArray*    oldNotifications = [app scheduledLocalNotifications];
                    
                    // Clear out the old notification before scheduling a new one.
                    if ([oldNotifications count] > 0)
                        [app cancelAllLocalNotifications];
                    
                    UILocalNotification* notifyAlarm = [[UILocalNotification alloc]
                                                        init];
                    
                    if (notifyAlarm)
                    {
                        notifyAlarm.fireDate = [NSDate date];
                        notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
                        notifyAlarm.repeatInterval = 0;
//                        notifyAlarm.soundName = @"bell_tree.mp3";
                        notifyAlarm.alertBody = location_message;//@"Staff meeting in 30 minutes";
                        notifyAlarm.soundName = UILocalNotificationDefaultSoundName;
                        notifyAlarm.applicationIconBadgeNumber += 1;
                        [app scheduleLocalNotification:notifyAlarm];
                    }
                    
                    
                    [UIAlertView showWithTitle:@"Message" message:location_message cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        //                "location_message" = "<null>";
                        //                "location_message_end_at" = "<null>";
                        //                "location_message_start_at" = "<null>";
                        
                    }];
                    
                    
                }else{
                    [self updateLocation];
//                    [self performSelector:@selector(updateLocation) withObject:nil afterDelay:0];
                }
            }else{
//                [self updateLocation];
                [locationController.locationManager stopUpdatingLocation];
            }
            
            
            
        }else{
            [locationController.locationManager stopUpdatingLocation];
            
//            [self performSelector:@selector(updateLocation) withObject:nil afterDelay:0];
        }
        
        
        
    }else{
        [self updateLocation];
//        [self performSelector:@selector(updateLocation) withObject:nil afterDelay:0];
    }
}

@end
