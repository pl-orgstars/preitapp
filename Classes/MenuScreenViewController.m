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
#import "Flurry.h"

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
#define MOVIE @"MOVIE LISTINGS"
#define JOB @"JOB OPENINGS"


#define SHOW_NEW_MALL @"Select a Different PREIT Property"

#define CONTACT_US @"CONTACT US"


#import "EventsViewController.h"
#import "DiningViewController.h"
#import "DirectionViewController.h"
#import "MovieListingViewController.h"
#import "JobsViewController.h"
#import "LocationViewController.h"
#import "DealScreenViewController.h"
#import "ShoppingViewController.h"
#import "MenuScreenViewController.h"

#import "HomeScreen.h"
#import "ContactUsViewController.h"
#import "DirectoryViewController.h"
#import "WinViewController.h"
#import "ScanReceiptViewController.h"
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowGiftView:) name:@"ShowGiftView" object:nil];
    [self.navigationController.navigationBar setTranslucent:YES];


     [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backNavigation.png"] forBarMetrics:UIBarMetricsDefault];
    
    [mallNameLabel setText:[appdelegate.mallData objectForKey:@"name"]];

    [self setSideMenuItems];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    
}




-(void)viewDidDisappear:(BOOL)animated{
    [beaconmsgUpdate invalidate];
    beaconmsgUpdate=nil;
}

- (IBAction)closeBtnCall:(id)sender {
    
    self.menuContainerViewController.menuState = MFSideMenuStateClosed;

}

- (void)ShowGiftView:(NSNotification *)notification
{
    NSString *strEvent = [NSString stringWithFormat:@"%@ Best Gift Ever.",[appdelegate.mallData objectForKey:@"name"]];
    [Flurry logEvent:strEvent timed:YES];
        WinViewController* winVC = [[WinViewController alloc] initWithNibName:@"WinViewController" bundle:[NSBundle mainBundle]];
        
        [_navController popToRootViewControllerAnimated:NO];
        [_navController pushViewController:winVC animated:NO];


}


- (void)viewDidLoad {
    [super viewDidLoad];

    beaconmsgUpdate =[NSTimer scheduledTimerWithTimeInterval:100.0
                                                      target:self
                                                    selector:@selector(targetMethod:)
                                                    userInfo:nil
                                                     repeats:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:) name:@"UpdateSideMenu" object:nil];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)targetMethod:(NSTimer*)timer{
    [appdelegate initilizeBeacon];
    NSLog(@"updating data");
}

- (void)setSideMenuItems {
    if (appdelegate.isDinning && appdelegate.isMovie) {
        tableData = [[NSMutableArray alloc]initWithObjects:
                     HOME,
                     GIFT,
                     STORE,
                     DINING,
                     PRODUCTS,
                     DEALS,
                     EVENTS,
                     TRENDS,
                     DIRECTIONS,
                     PARKING,
                     HOURS,
                     MOVIE,
                     JOB,
                     CONTACT_US,
                     nil];
    }else if (!appdelegate.isDinning){
        tableData = [[NSMutableArray alloc]initWithObjects:
                     
                     HOME,
                     GIFT,
                     STORE,
                     PRODUCTS,
                     DEALS,
                     EVENTS,
                     TRENDS,
                     DIRECTIONS,
                     PARKING,
                     HOURS,
                     MOVIE,
                     JOB,
                     CONTACT_US,
                     nil];
    }else if (!appdelegate.isMovie){
        tableData = [[NSMutableArray alloc]initWithObjects:
                     HOME,
                     GIFT,
                     STORE,
                     DINING,
                     PRODUCTS,
                     DEALS,
                     EVENTS,
                     TRENDS,
                     DIRECTIONS,
                     PARKING,
                     HOURS,
                     JOB,
                     CONTACT_US,
                     nil];
    }else{
        tableData = [[NSMutableArray alloc]initWithObjects:
                     HOME,
                     GIFT,
                     STORE,
                     PRODUCTS,
                     DEALS,
                     EVENTS,
                     TRENDS,
                     DIRECTIONS,
                     PARKING,
                     HOURS,
                     JOB,
                     nil];
    }
    

    
    [tableView_ reloadData];
    
}

#pragma mark - Table View


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsMake(tableView.separatorInset.top, 4.0, tableView.separatorInset.bottom, 4.0)];
    }
	CGFloat height = 50.0;
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
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
  	}
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    cell.imageView.image = [self getImageForCell:cell.textLabel.text];
    [cell.textLabel setFont:LABEL_TEXT_FONT];
    [cell.textLabel setTextColor:LABEL_TEXT_COLOR];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSString *str = [tableData objectAtIndex:indexPath.row];
    NSInteger count = _navController.viewControllers.count-1;
    if ([str isEqualToString:HOME]) {
        
        if (![[_navController.viewControllers objectAtIndex:count] isKindOfClass:[ProductSearchHome class]]) {
            
            [_navController popToRootViewControllerAnimated:YES];
        }
    }
    
    else if ([str isEqualToString:GIFT]){
        
        // flurry event here
        NSString *strEvent = [NSString stringWithFormat:@"%@ Best Gift Ever.",[appdelegate.mallData objectForKey:@"name"]];
        [Flurry logEvent:strEvent timed:YES];
        if (![[_navController.viewControllers objectAtIndex:count] isKindOfClass:[WinViewController class]]) {
            WinViewController* winVC = [[WinViewController alloc] initWithNibName:@"WinViewController" bundle:[NSBundle mainBundle]];
            
            [_navController popToRootViewControllerAnimated:NO];
            [_navController pushViewController:winVC animated:NO];
        }
    }
    else if ([str isEqualToString:STORE]){
        
//CHM Start ibnetariq update store view and solve this issue
        if (![[_navController.viewControllers objectAtIndex:count] isKindOfClass:[StoreSearchViewController class]]) {
      
            
            DirectoryViewController* directoryVC = [[DirectoryViewController alloc] initWithNibName:@"DirectoryViewController" bundle:[NSBundle mainBundle]];
            
            
            [_navController popToRootViewControllerAnimated:NO];
            [_navController pushViewController:directoryVC animated:NO];
            

            
        }
    }
    else if ([str isEqualToString:PRODUCTS]){
        
//#warning ibnetariq update products
        [self searchAction:nil];
    }
    
    else if ([str isEqualToString:DINING]) {
        
        if (![[_navController.viewControllers objectAtIndex:count] isKindOfClass:[DiningViewController class]]) {
            DiningViewController *viewCnt = [[DiningViewController alloc]initWithNibName:@"CustomTable" bundle:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                viewCnt.titleLabel.text = @"DINING";

            });
            
            [_navController popToRootViewControllerAnimated:NO];
            [_navController pushViewController:viewCnt animated:NO];
        }
        
    }
    else if([str isEqualToString:TRENDS]){
        WebViewController *screenWebView=[[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
        screenWebView.screenIndex=9;
        // Change google
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Trends"];
        
        // Send a screenview.
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            screenWebView.titleLabel.text = @"TRENDS";
        });
        
        [_navController popToRootViewControllerAnimated:NO];
        [_navController pushViewController:screenWebView animated:NO];
        
    }
    else if([str isEqualToString:EVENTS]){
        
        if (![[_navController.viewControllers objectAtIndex:count] isKindOfClass:[EventsViewController class]]) {
            EventsViewController *viewCnt = [[EventsViewController alloc]initWithNibName:@"EventsViewController" bundle:nil];
            
            [_navController popToRootViewControllerAnimated:NO];
            [_navController pushViewController:viewCnt animated:NO];
        }
        
    }
    else if([str isEqualToString:DIRECTIONS]){
        // Change google
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Direction"];
        
        // Send a screenview.
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
        
        if (![[_navController.viewControllers objectAtIndex:count] isKindOfClass:[DirectionViewController class]]) {
            DirectionViewController *screenDirection=[[DirectionViewController alloc]initWithNibName:@"DirectionViewController" bundle:nil];
            
            [_navController popToRootViewControllerAnimated:NO];
            [_navController pushViewController:screenDirection animated:NO];
        }
        
        
    }
    else if([str isEqualToString:MOVIE]){
        // Change google
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Movie Listings"];
        
        // Send a screenview.
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
        
        if (![[_navController.viewControllers objectAtIndex:count] isKindOfClass:[MovieListingViewController class]]) {
            MovieListingViewController *screenMovieListing=[[MovieListingViewController alloc]initWithNibName:@"MovieListingViewController" bundle:nil];
            [_navController popToRootViewControllerAnimated:NO];
            [_navController pushViewController:screenMovieListing animated:NO];
            
        }
        
    }
    else if([str isEqualToString:HOURS]){
        WebViewController *screenWebView=[[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
        screenWebView.screenIndex=8;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            screenWebView.titleLabel.text = @"HOURS";
        });
        // Change google
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Hours"];
        
        // Send a screenview.
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
        
        
        [_navController popToRootViewControllerAnimated:NO];
        [_navController pushViewController:screenWebView animated:NO];
        
    }
    else if([str isEqualToString:JOB]){
        // Change google
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Job Openings"];
        
        // Send a screenview.
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
        
        if (![[_navController.viewControllers objectAtIndex:count] isKindOfClass:[JobsViewController class]]) {
            JobsViewController *screenJobs=[[JobsViewController alloc]initWithNibName:@"JobsViewController" bundle:nil];
            
            [_navController popToRootViewControllerAnimated:NO];
            [_navController pushViewController:screenJobs animated:NO];
        }
        
    }
    else if ([str isEqualToString:SHOW_NEW_MALL]){
        
    }
    else if ([str isEqualToString:DEALS])
    {
        if (![[_navController.viewControllers objectAtIndex:count] isKindOfClass:[DealScreenViewController class]]) {
            
            DealScreenViewController* dealsVC = [[DealScreenViewController alloc] initWithNibName:@"DealScreenViewController" bundle:[NSBundle mainBundle]];
            
            [_navController popToRootViewControllerAnimated:NO];
            [_navController pushViewController:dealsVC animated:NO];
        }
        
    }
    else if ([str isEqualToString:CONTACT_US]){
        // Change google
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Contact Us"];
        
        // Send a screenview.
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
        
        if (![[_navController.viewControllers objectAtIndex:count] isKindOfClass:[ContactUsViewController class]]) {
            ContactUsViewController *screenContact=[[ContactUsViewController alloc]initWithNibName:@"ContactUsViewController" bundle:nil];
            
            [_navController popToRootViewControllerAnimated:NO];
            [_navController pushViewController:screenContact animated:NO];
        }
    }
    else if ([str isEqualToString:PARKING]){
        
        if (![[_navController.viewControllers objectAtIndex:count] isKindOfClass:[ParkScreenViewController class]]) {
            ParkScreenViewController *parkScreen = [[ParkScreenViewController alloc] initWithNibName:@"ParkScreenNew" bundle:[NSBundle mainBundle]];
            
            [_navController popToRootViewControllerAnimated:NO];
            [_navController pushViewController:parkScreen animated:NO];
        }
    }
    
 /*   else if ([str isEqualToString:SCAN]){
        if (![[_navController.viewControllers objectAtIndex:count] isKindOfClass:[ScanReceiptViewController class]]) {
            ScanReceiptViewController *scanVC = [[ScanReceiptViewController alloc] initWithNibName:@"ScanReceiptViewController" bundle:[NSBundle mainBundle]];
            
            [_navController popToRootViewControllerAnimated:NO];
            [_navController pushViewController:scanVC animated:NO];
        }
        
    }*/
    
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
    
    NSInteger count = _navController.viewControllers.count - 1;
    if (![[_navController.viewControllers objectAtIndex:count] isKindOfClass:[ProductListViewController class]]) {
        ProductListViewController *productListViewController = [[ProductListViewController alloc]initWithNibName:@"ProductListViewController copy" bundle:nil];
        [_navController popToRootViewControllerAnimated:NO];
        [_navController pushViewController:productListViewController animated:NO];
    }
    
}

#pragma mark - nav

- (IBAction)selectAnotherCall:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLocationView" object:nil];
    self.menuContainerViewController.menuState = MFSideMenuStateClosed;
    [appdelegate disableBeacon];
}


@end
