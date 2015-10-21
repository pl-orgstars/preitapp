//
//  HomeScreen.m
//  Preit
//
//  Created by Aniket on 9/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HomeScreen.h"
#import "LoadingAgent.h"
#import "RequestAgent.h"
#import <CoreLocation/CoreLocation.h>
#import "JSON.h"
#import "UIAlertView+Blocks.h"
#import "MenuScreenViewController.h"

#define LABEL_TAG 100

@implementation HomeScreen
{
    NSArray *tempArray;
}
@synthesize tableData,city,coordinates,radius;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadDefaultValues];
    
	if(self.radius)
		distanceData=[[NSMutableArray alloc]init];//autorelease];
    
    if (!tableData) {
        self.tableData=[[NSMutableArray alloc]init];
        [self getData];
    }else{
        if (_isLocationEnabled) {
            [self getDistance];
        }
        
        if (_presentMainView)
            menuButton.hidden = YES;
        
        [searchBar_ setReturnKeyType:UIReturnKeyDone];
        locateButton.layer.borderColor = [UIColor whiteColor].CGColor;
        locateButton.layer.borderWidth = 1.5;
        
        [self setDataByState];
        [tableHome reloadData];
    }
}

-(void)loadInitialView{
    [self loadDefaultValues];
    [self getData];
}

-(void)loadDefaultValues
{
	delegate=(PreitAppDelegate *)[[UIApplication sharedApplication]delegate];
//    [self setHeaderViewForTable];
}

- (void)setDataByState {
    if (!sections)
        sections = [NSMutableDictionary new];
    
    [sections removeAllObjects];
    
    for (NSDictionary *dict in tableData) {
        NSString *state = [dict objectForKey:@"address_state"];
        NSMutableArray *mallsArray = [sections objectForKey:state];
        if (!mallsArray) {
            mallsArray = [NSMutableArray new];
        }
        
        [mallsArray addObject:dict];
        [sections setObject:mallsArray forKey:state];
    }
    
    sectionKeys = [[sections allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
}

-(void)backButttontapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setHeaderViewForTable{
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, isNoData?15:50)];
    if (!isNoData) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 320, 50)];
        [label setTextColor:[UIColor whiteColor]];
        if (_isLocationEnabled) {
            label.text = @"Select the PREIT Mall nearest you";
        }else{
            label.text = @"Choose from a list of all PREIT Malls";
        }
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15]];
        [headerView addSubview:label];
    }
    headerView.backgroundColor = [UIColor colorWithRed:(51/255.0) green:(51/255.0) blue:(51/255.0) alpha:1];
	tableHome.tableHeaderView=headerView;
}
-(void)viewWillAppear:(BOOL)animated {
    delegate.mAllowSelectTab = NO;
  
}



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

- (NSDictionary *)getTempDictionary:(NSIndexPath *)indexPath {
    NSDictionary *tmpDict;
    if (displayOrder == DisplayOrderByState) {
        NSString *key = [sectionKeys objectAtIndex:indexPath.section];
        NSArray *arr = [sections objectForKey:key];
        tmpDict = [arr objectAtIndex:indexPath.row];
    }
    else if (displayOrder == DisplayOrderBySearch) {
        tmpDict = [searchArray objectAtIndex:indexPath.row];
    }
    else if (displayOrder == DisplayOrderNearestMall) {
        tmpDict = nearestMall;
    }
    else {
        tmpDict = [tableData objectAtIndex:indexPath.row];
    }
    
    return tmpDict;
}

- (void)reloadAllLocationsData {
    if (_isLocationEnabled) {
        _isLocationEnabled = NO;
        [self.tableData addObjectsFromArray:tempArray];
    }
    
    self.radius=nil;
    [self viewDidLoad];
}

#pragma mark - Action methods

-(void)buttonAction:(id)sender{
	[self getData];
}

- (IBAction)menuBtnCall:(id)sender {
    
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;
    
}


- (IBAction)locateNearestMallAction:(id)sender {
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:self.coordinates.latitude longitude:self.coordinates.longitude];
    CLLocationDistance distance = 0;
    
    for (NSDictionary *dict in tableData) {
        CLLocation *locB = [[CLLocation alloc] initWithLatitude:[[dict objectForKey:@"location_lat"] doubleValue]
                                                      longitude:[[dict objectForKey:@"location_lng"] doubleValue]];
        CLLocationDistance tempDistance = [locA distanceFromLocation:locB];
        if (tempDistance < distance || distance == 0) {
            distance = tempDistance;
            nearestMall = dict;
        }
    }
    
    byStateUnderline.hidden = YES;
    byAlphabetUnderline.hidden = YES;
    
    displayOrder = DisplayOrderNearestMall;
    [self reloadTableView];
}

- (IBAction)byStateAction:(id)sender {
    byStateUnderline.hidden = NO;
    byAlphabetUnderline.hidden = YES;
    
    displayOrder = DisplayOrderByState;
    [self reloadTableView];
}

- (IBAction)byAlphabetAction:(id)sender {
    byStateUnderline.hidden = YES;
    byAlphabetUnderline.hidden = NO;
    
    displayOrder = DisplayOrderByAlphabet;
    [self reloadTableView];
}

#pragma mark - SearchBar Methods


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    byStateUnderline.hidden = YES;
    byAlphabetUnderline.hidden = YES;
    
    displayOrder = DisplayOrderBySearch;
    if (!searchArray)
        searchArray = [NSMutableArray new];
    
    [searchArray removeAllObjects];
    
    for (NSDictionary *dict in tableData) {
        if ([[dict objectForKey:@"name"] localizedCaseInsensitiveContainsString:searchText]) {
            [searchArray addObject:dict];
        }
    }
    
    [self reloadTableView];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [self byStateAction:nil];
}

- (void)resignSearchBar {
    if (displayOrder != DisplayOrderBySearch)
        searchBar_.text = @"";
    [searchBar_ resignFirstResponder];
}

#pragma mark UITableViewDelegate methods

- (void)reloadTableView {
    NSInteger count;
    if (displayOrder == DisplayOrderByState) {
        count = sectionKeys;
    }
    else if (displayOrder == DisplayOrderByAlphabet) {
        count = tableData.count;
    }
    else if (displayOrder == DisplayOrderBySearch) {
        count = searchArray.count;
    }
    else if (displayOrder == DisplayOrderNearestMall) {
        count = 1;
    }
    
    isNoData = (count == 0) ? YES : NO;
    [tableHome reloadData];
    if (displayOrder != DisplayOrderBySearch)
        [self resignSearchBar];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return (displayOrder == DisplayOrderByState) ? sections.count : 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (displayOrder == DisplayOrderByState) ? [sectionKeys objectAtIndex:section] : @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count;
    if (displayOrder == DisplayOrderByState) {
        NSString *key = [sectionKeys objectAtIndex:section];
        NSArray *arr = [sections objectForKey:key];
        count = arr.count;
    }
    else if (displayOrder == DisplayOrderBySearch) {
        count = searchArray.count;
    }
    else if (displayOrder == DisplayOrderNearestMall) {
        count = 1;
    }
    else {
        count = tableData.count;
    }
    
	return isNoData ? 1 : count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	CGFloat height=40.0;
	if(!isNoData){
        NSDictionary *tmpDict = [self getTempDictionary:indexPath];
        
		CGSize constraint = CGSizeMake(200.0000, 20000.0f);
		CGSize titlesize = [[tmpDict objectForKey:@"name"] sizeWithFont:[UIFont boldSystemFontOfSize:18] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		height= (titlesize.height<40?50:(titlesize.height+20));
	}
	return height;	
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *cellIdentifier=isNoData?@"NoData":@"Cell";
	UITableViewCell *cell;
	
	cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil){
        if ([cellIdentifier isEqualToString:@"Cell"])
			cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];// autorelease];
        else
			cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];// autorelease];
	}
	else
	{
		if([cell.contentView viewWithTag:LABEL_TAG])
			[[cell.contentView viewWithTag:LABEL_TAG] removeFromSuperview];
	}
	
    if([cellIdentifier isEqualToString:@"Cell"]){
		cell.textLabel.numberOfLines=0;
        
        NSDictionary *tmpDict = [self getTempDictionary:indexPath];
		cell.textLabel.text=[tmpDict objectForKey:@"name"];
		cell.textLabel.font=LABEL_TEXT_FONT;
        cell.textLabel.backgroundColor=[UIColor clearColor];
		cell.textLabel.textColor=LABEL_TEXT_COLOR;
        
        
		
		cell.detailTextLabel.text=[NSString stringWithFormat:@"%@, %@",[tmpDict objectForKey:@"address_city"],[tmpDict objectForKey:@"address_state"]];
		cell.detailTextLabel.textColor=DETAIL_TEXT_COLOR;
        [cell.detailTextLabel setFont:DETAIL_TEXT_FONT];
		cell.detailTextLabel.backgroundColor=[UIColor clearColor];
		
		if(self.radius)
		{
			NSString *distance=[distanceData objectAtIndex:indexPath.row];
			CGSize constraint = CGSizeMake(200.0000, 20000.0f);
			CGSize titlesize = [distance sizeWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
			
			
			UILabel *distanceLabel=[[UILabel alloc]initWithFrame:CGRectMake((280-titlesize.width),30,titlesize.width,titlesize.height)];
			distanceLabel.text=distance;
			distanceLabel.font=[UIFont boldSystemFontOfSize:15];
			distanceLabel.textColor=[UIColor blueColor];
			distanceLabel.tag=LABEL_TAG;
			distanceLabel.backgroundColor=[UIColor clearColor];
			[cell.contentView addSubview:distanceLabel];
		}
        
        UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_icon1.png"]];
        [view setFrame:CGRectMake(0, 0, 8, 14)];
        cell.accessoryView = view;
		cell.selectionStyle=UITableViewCellSelectionStyleGray;

		
	}else
	{
		cell.textLabel.text=@"No Result";
		cell.textLabel.textColor=[UIColor grayColor];
		cell.textLabel.backgroundColor=[UIColor clearColor];
		cell.textLabel.textAlignment=NSTextAlignmentCenter;
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}	
	return cell;	
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selectrow");
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if(!isNoData){
		NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithDictionary:[self getTempDictionary:indexPath]];
        
//        if ([[tmpDict objectForKey:@"name"] isEqualToString:@"Cherry Hill Mall"]) {
//            [tmpDict setObject:@"http://staging.cherryhillmall.red5demo.com" forKey:@"website_url"];
//        }
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tmpDict];
        [defaults setObject:data forKey:@"mallData"];

         NSLog(@".............dictionare to prionnasjkdfnksa %@ :::::",tmpDict);
        
       

        
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

		

        [[LoadingAgent defaultAgent]makeBusy:YES];
        
        NSString *url = [tmpDict objectForKey:@"website_resource_url"];

        NSLog(@"uuuuuuuuuuuuuu %@",url);
		RequestAgent *req=[[RequestAgent alloc] init];// autorelease];
		[req requestToServer:self callBackSelector:@selector(requestSuccess:) errorSelector:@selector(requestFailed:) Url:url];
		
		
	}
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if(!isNoData){
		NSDictionary *tmpDict = [self getTempDictionary:indexPath];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tmpDict];
        [defaults setObject:data forKey:@"mallData"];
        
        
        NSData *data2 = [defaults objectForKey:@"mallData"];
        NSDictionary *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
        
        NSLog(@".............dictionare to prionnasjkdfnksa %@ :::::%@",tmpDict,arr);
        
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
		RequestAgent *req=[[RequestAgent alloc] init];// autorelease];
		[req requestToServer:self callBackSelector:@selector(requestSuccess:) errorSelector:@selector(requestFailed:) Url:url];
		[[LoadingAgent defaultAgent]makeBusy:YES];
	}
	
}



#pragma mark Response methods

-(void)getData{
	NSString *url=[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Server",""),NSLocalizedString(@"API0","")];
	if(self.radius)
		url=[NSString stringWithFormat:@"%@?lat=%f&lng=%f&radius=%@",url,self.coordinates.latitude,self.coordinates.longitude,radius];
	
	self.navigationItem.rightBarButtonItem.enabled=NO;
	[indicator_ startAnimating];

	RequestAgent *req=[[RequestAgent alloc] init];// autorelease];
	[req requestToServer:self callBackSelector:@selector(responseData:) errorSelector:@selector(errorCallback:) Url:url];
}

-(void)responseData:(NSData *)receivedData{
	[indicator_ stopAnimating];
    
	self.navigationItem.hidesBackButton=NO;
	self.navigationItem.rightBarButtonItem.enabled=YES;

    
	if(receivedData!=nil)
	{
		NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];// autorelease];
		NSArray *tmpArray=[jsonString JSONValue];
		NSLog(@"tmpArray==%@",tmpArray);
		[self.tableData removeAllObjects];
		if([tmpArray count]!=0){
			isNoData=NO;
			for(int i=0;i<[tmpArray count];i++)
			{
				NSDictionary *tmpDict=[tmpArray objectAtIndex:i];
				if(tmpDict && [tmpDict objectForKey:@"property"])
					[self.tableData addObject:[tmpDict objectForKey:@"property"]];
			}
			

            if (_isLocationEnabled) {
                [self getDistance];
            }
		}
		else
		{
			isNoData=YES;	
			if(self.radius)
			{
                [self reloadAllLocationsData];
//				UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:NSLocalizedString(@"ShowAll",@"") delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
//				[alert show];
			}
		}
 	}
	else
		isNoData=YES;

	[tableHome reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
}

-(void)errorCallback:(NSError *)error{
	[indicator_ stopAnimating];
	self.navigationItem.rightBarButtonItem.enabled=YES;

	[delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Message" buttontitle:@"Ok"];
}

-(void)responseData_Image:(NSData *)receivedData{
	[[LoadingAgent defaultAgent]makeBusy:NO];
	NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];// autorelease];

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
	[[LoadingAgent defaultAgent]makeBusy:NO];
    [delegate.navController.view removeFromSuperview];
    
    [delegate.window addSubview:delegate.tabBarController.view];
    [delegate initilizeBeacon];
}

-(void)getDistance
{
    NSMutableArray *tempTableData = [NSMutableArray new];
    [tempTableData addObjectsFromArray:self.tableData];
	for(int i=0;i<[self.tableData count];i++)
	{
		NSDictionary *tmpDict=[self.tableData objectAtIndex:i];
		
		if([tmpDict objectForKey:@"location_lat"] ==[NSNull null] || [tmpDict objectForKey:@"location_lng"]==[NSNull null] )
		{
			[distanceData addObject:@"NA"];
            [tempTableData removeObject:tmpDict];
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

            if (dist_Miles > 50) {
                [tempTableData removeObject:tmpDict];
            }else{
                NSString *strDist = [NSString stringWithFormat:@"%.2f miles", dist_Miles];
                
                [distanceData addObject:strDist];
            }
			
		}
	}
    if (!tempTableData.count && _isLocationEnabled) {
        tempArray = [[NSArray alloc]initWithArray:self.tableData];
        [self.tableData removeAllObjects];
        
        [self reloadAllLocationsData];
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:NSLocalizedString(@"ShowAll",@"") delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
//        [alert show];
    }else{
        [self.tableData removeAllObjects];
        [self.tableData addObjectsFromArray:tempTableData];
    }
    

    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if([[alertView buttonTitleAtIndex:buttonIndex] compare:@"Yes"] == NSOrderedSame)
	{
        [self reloadAllLocationsData];
	}
}

-(void)requestForImages{
    NSString *url=[NSString stringWithFormat:@"%@%@",[delegate.mallData objectForKey:@"resource_url"],NSLocalizedString(@"API_BgImages","")];
    NSLog(@"uuuuuuuuuuuuuu %@",url);
    RequestAgent *req=[[RequestAgent alloc] init];// autorelease];
    [req requestToServer:self callBackSelector:@selector(responseData_Image:) errorSelector:@selector(errorCallback_Image:) Url:url];
    
   
}

-(void)requestSuccess:(NSData *)receivedData{
    
	if(receivedData!=nil)
	{
		NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];// autorelease];
		NSDictionary *tmpArray=[jsonString JSONValue];

        NSDictionary *dict = [tmpArray valueForKey:@"website"];

        NSDictionary *dd= [dict valueForKey:@"settings"];


        NSString *tracerID= [dd valueForKey:@"ga_property_id_for_mobile"];
    
        id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:tracerID];
        [GAI sharedInstance].trackUncaughtExceptions = YES;
        [[GAI sharedInstance].logger setLogLevel:kGAILogLevelVerbose];

        delegate.tracker = tracker;
        
        
        
        NSString *str = [NSString stringWithFormat:@"IOS %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] ];
        NSLog(@"version +++ === %@",str);
	
    }
    
    [[LoadingAgent defaultAgent]makeBusy:NO];
    [delegate setupPortraitUserInterface];
    [delegate initilizeBeacon];
    
    if (_presentMainView)
        [self showMainViewController];
    else
        [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)requestFailed:(NSError *)error{
    [[LoadingAgent defaultAgent]makeBusy:YES];
	[indicator_ stopAnimating];
	self.navigationItem.hidesBackButton=NO;
	self.navigationItem.rightBarButtonItem.enabled=YES;
    
	[delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Message" buttontitle:@"Ok"];
}

- (NSString *)appNameAndVersionNumberDisplayString {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appDisplayName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *minorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    return [NSString stringWithFormat:@"%@, Version %@ (%@)",
            appDisplayName, majorVersion, minorVersion];
}

#pragma mark - MainView Method

- (void)showMainViewController {
    ProductSearchHome *productSearchVC = [[ProductSearchHome alloc] initWithNibName:@"ProductSearchHome" bundle:nil];
    productSearchVC.view.frame = CGRectMake(0, 0, 320, isIPhone5?568:480);
    
    PreitNavigationViewController *navCont = [[PreitNavigationViewController alloc] initWithRootViewController:productSearchVC];
    navCont.navigationBarHidden = YES;
    
    MenuScreenViewController *sideMenu = [[MenuScreenViewController alloc] initWithNibName:@"MenuScreenViewController" bundle:[NSBundle mainBundle]];
    sideMenu.navController = navCont;
    
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController containerWithCenterViewController:navCont
                                                                                                 leftMenuViewController:nil
                                                                                                rightMenuViewController:sideMenu];
    container.rightMenuWidth = 320.0;
    container.menuAnimationDefaultDuration = 0.5;
    container.menuSlideAnimationEnabled = YES;
    container.menuSlideAnimationFactor = 1.0;
    container.panMode = 0;
    [self presentViewController:container animated:YES completion:nil];
}

@end
