//
//  MenuScreenViewController.m
//  Preit
//
//  Created by kuldeep on 5/29/14.
//
//

#import "MenuScreenViewController.h"
#import "PreitAppDelegate.h"
#import "StoreSearchViewController.h"
#import "ProductListViewController.h"
#import "WebViewController.h"

#define HOME @"HOME"
#define GIFT @"BEST GIFT EVER"
#define STORE @"STORES"
#define DINING @"DINING"
#define PRODUCTS @"PRODUCT SEARCH"
#define DEALS @"DEALS"
#define EVENTS @"EVENTS"
#define TRENDS @"TRENDS"
#define DIRECTIONS @"DIRECTIONS"
#define PARKING @"PARKING REMINDERS"
#define HOURS @"HOURS"
#define MOVIE @"MOVIE LISTING"
#define JOB @"JOB OPENINGS"

#define SHOW_NEW_MALL @"Select a Different PREIT Property"

#define CONTACT_US @"CONTACT US"

//#define BEACON @"BEACON"
#import "BeaconViewController.h"

#import "EventsViewController.h"
#import "DiningViewController.h"
#import "DirectionViewController.h"
#import "MovieListingViewController.h"
#import "JobsViewController.h"
#import "LocationViewController.h"

#import "HomeScreen.h"
#import "ContactUsViewController.h"
@interface MenuScreenViewController ()
{
    NSMutableArray *tableData;
    PreitAppDelegate *appdelegate;
    
    IBOutlet UILabel* mallNameLabel;
}
@end

@implementation MenuScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        appdelegate= (PreitAppDelegate *)[[UIApplication sharedApplication]delegate];
        appdelegate.productSearchViewControllerDelegate = self;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTranslucent:YES];
    NSString *titleLabel = (NSString*)[appdelegate.mallData objectForKey:@"name"];
//    [navigationLabel setText:titleLabel];
    NSLog(@"navigationLabelnavigationLabel ==%@",[appdelegate.mallData objectForKey:@"name"]);

     [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backNavigation.png"] forBarMetrics:UIBarMetricsDefault];
    
    


}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    
    [mallNameLabel setText:[appdelegate.mallData objectForKey:@"name"]];
}
-(void)targetMethod:(NSTimer*)timer{
    [appdelegate initilizeBeacon];
}
-(void)viewDidDisappear:(BOOL)animated{
    [beaconmsgUpdate invalidate];
    beaconmsgUpdate=nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    beaconmsgUpdate =[NSTimer scheduledTimerWithTimeInterval:100.0
                                     target:self
                                   selector:@selector(targetMethod:)
                                   userInfo:nil
                                    repeats:YES];
    
    if (appdelegate.isDinning && appdelegate.isMovie) {
        tableData = [[NSMutableArray alloc]initWithObjects:
                     HOME,
                     STORE,
                     PRODUCTS,
                     DINING,
                     TRENDS,
                     EVENTS,
                     DIRECTIONS,
                     MOVIE,
                     HOURS,
                     JOB,
                     CONTACT_US,
                     SHOW_NEW_MALL,
                     nil];
    }else if (!appdelegate.isDinning){
        tableData = [[NSMutableArray alloc]initWithObjects:
                     
                     HOME,
                     STORE,
                     PRODUCTS,
                     TRENDS,
                     EVENTS,
                     DIRECTIONS,
                     MOVIE,
                     HOURS,
                     JOB,
                     CONTACT_US,
                     SHOW_NEW_MALL,
                     nil];
    }else if (!appdelegate.isMovie){
        tableData = [[NSMutableArray alloc]initWithObjects:
                     HOME,
                     STORE,
                     PRODUCTS,
                     DINING,
                     TRENDS,
                     EVENTS,
                     DIRECTIONS,
                     HOURS,
                     JOB,
                     CONTACT_US,
                     SHOW_NEW_MALL,
                     nil];
    }else{
        tableData = [[NSMutableArray alloc]initWithObjects:
                     HOME,
                     STORE,
                     PRODUCTS,
                     TRENDS,
                     EVENTS,
                     DIRECTIONS,
                     HOURS,
                     JOB,
                     SHOW_NEW_MALL,
                     nil];
    }
    
    [tableData addObject:@"Parking"];
    
    
    

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsMake(tableView.separatorInset.top, 4.0, tableView.separatorInset.bottom, 4.0)];
    }
	CGFloat height = 60.0;
	return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell;
	cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil){
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
//       commented on sep 22,2015 Ali Bin Tariq Pure Logics
//        UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_icon1.png"]];
//        [view setFrame:CGRectMake(0, 0, 8, 14)];
//        cell.accessoryView = view;
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
      
        
	}
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    cell.imageView.image = [self getImageForCell:cell.textLabel.text];
    [cell.textLabel setFont:LABEL_TEXT_FONT];
    [cell.textLabel setTextColor:LABEL_TEXT_COLOR];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSString *str = [tableData objectAtIndex:indexPath.row];
    
    if ([str isEqualToString:HOME]) {
//        @"HOME",
//        [appdelegate hideProductScreen:NO];
        ProductSearchHome *productVC = [[ProductSearchHome alloc] initWithNibName:@"ProductSearchHome" bundle:[NSBundle mainBundle]];
        _navController.viewControllers = @[productVC];
        
        
    }else if ([str isEqualToString:STORE]){
//        @"STORES",

        StoreSearchViewController *screenShoppingindex=[[StoreSearchViewController alloc]initWithNibName:@"StoreSearchViewController" bundle:nil];
        self.navigationItem.title=@"Back";
        [self.navigationController pushViewController:screenShoppingindex animated:YES];
    }else if ([str isEqualToString:PRODUCTS]){
//        @"PRODUCTS",
        [self searchAction:nil];
    }else if ([str isEqualToString:DINING]) {

        DiningViewController *viewCnt = [[DiningViewController alloc]initWithNibName:@"CustomTable" bundle:nil];
        [self.navigationController pushViewController:viewCnt animated:YES];
        
    }else if([str isEqualToString:TRENDS]){
        WebViewController *screenWebView=[[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
		screenWebView.screenIndex=9;
        // Change google
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Trends"];
        
        // Send a screenview.
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
		[self.navigationController pushViewController:screenWebView animated:YES];

    }else if([str isEqualToString:EVENTS]){

        EventsViewController *viewCnt = [[EventsViewController alloc]initWithNibName:@"EventsViewController" bundle:nil];
        [self.navigationController pushViewController:viewCnt animated:YES];
        
    }else if([str isEqualToString:DIRECTIONS]){
        DirectionViewController *screenDirection=[[DirectionViewController alloc]initWithNibName:@"DirectionViewController" bundle:nil];
        // Change google
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Direction"];
        
        // Send a screenview.
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];

		[self.navigationController pushViewController:screenDirection animated:YES];

    }else if([str isEqualToString:MOVIE]){
        MovieListingViewController *screenMovieListing=[[MovieListingViewController alloc]initWithNibName:@"MovieListingViewController" bundle:nil];
        // Change google
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Movie Listings"];
        
        // Send a screenview.
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
		[self.navigationController pushViewController:screenMovieListing animated:YES];

    }else if([str isEqualToString:HOURS]){
        WebViewController *screenWebView=[[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
		screenWebView.screenIndex=8;
       // Change google
       // [[GAI sharedInstance].defaultTracker sendView:@"Hours"];
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Hours"];
        
        // Send a screenview.
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
		[self.navigationController pushViewController:screenWebView animated:YES];

    }else if([str isEqualToString:JOB]){
        JobsViewController *screenJobs=[[JobsViewController alloc]initWithNibName:@"JobsViewController" bundle:nil];
        // Change google
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Job Openings"];
        
        // Send a screenview.
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
        //[[GAI sharedInstance].defaultTracker sendView:@"Job Openings"];
		[self.navigationController pushViewController:screenJobs animated:YES];

    }else if ([str isEqualToString:SHOW_NEW_MALL]){
        appdelegate.isOnForeGround = YES;
        if (appdelegate.navController.viewControllers.count == 1) {
            HomeScreen *screenHome=[[HomeScreen alloc]initWithNibName:@"HomeScreen" bundle:nil];
            self.navigationItem.title=@"Back";
            screenHome.isLocationEnabled = NO;
            [appdelegate.navController pushViewController:screenHome animated:YES];
        }else{
            HomeScreen *homeView = ((HomeScreen *)[appdelegate.navController.viewControllers objectAtIndex:1]);
            
            if (homeView.isLocationEnabled) {
                homeView.isLocationEnabled = NO;
                [homeView loadInitialView];
            }
            
        }
		[appdelegate.tabBarController.view removeFromSuperview];     //Waseem Menu
		[appdelegate.window addSubview:appdelegate.navController.view];
        
        [appdelegate disableBeacon];
        
    }else if ([str isEqualToString:CONTACT_US]){
        ContactUsViewController *screenContact=[[ContactUsViewController alloc]initWithNibName:@"ContactUsViewController" bundle:nil];
        // Change google
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Contact Us"];
        
        // Send a screenview.
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
        [self.navigationController pushViewController:screenContact animated:YES];
    }else if ([str isEqualToString:@"Parking"]){
        ParkScreenViewController *parkScreen = [[ParkScreenViewController alloc] initWithNibName:@"ParkScreenViewController" bundle:[NSBundle mainBundle]];
        _navController.viewControllers = @[parkScreen];
    }
    
    self.menuContainerViewController.menuState = MFSideMenuStateClosed;

}

-(UIImage*)getImageForCell:(NSString*)cellName
{
    UIImage* cellImage;
    if ([cellName isEqualToString:HOME]) {
        cellImage = [UIImage imageNamed:@"mainmenu-icon-home"];
    }
    else if ([cellName isEqualToString:GIFT]){
        cellImage = [UIImage imageNamed:@"mainmenu-icon-gift"];
    }
    else if ([cellName isEqualToString:STORE]){
        cellImage = [UIImage imageNamed:@"mainmenu-icon-stores"];
    }
    else if ([cellName isEqualToString:DINING]){
        cellImage = [UIImage imageNamed:@"mainmenu-icon-dining"];
    }
    else if ([cellName isEqualToString:PRODUCTS]){
        cellImage = [UIImage imageNamed:@"mainmenu-icon-productsearch"];
    }
    else if ([cellName isEqualToString:DEALS]){
        cellImage = [UIImage imageNamed:@"mainmenu-icon-deals"];
    }
    else if ([cellName isEqualToString:EVENTS]){
        cellImage = [UIImage imageNamed:@"mainmenu-icon-events"];
    }
    else if ([cellName isEqualToString:TRENDS]){
        cellImage = [UIImage imageNamed:@"mainmenu-icon-trends"];
    }
    else if ([cellName isEqualToString:DIRECTIONS]){
        cellImage = [UIImage imageNamed:@"mainmenu-icon-directions"];
    }
    else if ([cellName isEqualToString:PARKING]){
        cellImage = [UIImage imageNamed:@"mainmenu-icon-parking"];
    }
    else if ([cellName isEqualToString:HOURS]){
        cellImage = [UIImage imageNamed:@"mainmenu-icon-hours"];
    }
    else if ([cellName isEqualToString:JOB]){
        cellImage = [UIImage imageNamed:@"mainmenu-icon-jobs"];
    }
    else if ([cellName isEqualToString:MOVIE]){
        cellImage = [UIImage imageNamed:@"mainmenu-icon-movies"];
    }
    else if ([cellName isEqualToString:CONTACT_US]){
        cellImage = [UIImage imageNamed:@"mainmenu-icon-contactus"];
    }
    else{
        return nil;
    }
    
    return cellImage;
    
}


-(void)searchAction:(id)sender {
    NSLog(@"searchAction");
//    UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"" message:@"Product Search is temporarily unavailable" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] ;
    
    ProductListViewController *productListViewController = [[ProductListViewController alloc]initWithNibName:@"ProductListViewController" bundle:nil];
    [self.navigationItem setTitle:@"Back"];
    [self.navigationController pushViewController:productListViewController animated:YES];
    
}

@end
