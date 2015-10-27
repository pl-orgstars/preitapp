//
//  SearchScreenViewController.m
//  Preit
//
//  Created by kuldeep on 5/29/14.
//
//

#import "SearchScreenViewController.h"
#import "PreitAppDelegate.h"

#import "StoreSearchViewController.h"
#import "MovieListingViewController.h"
#import "ProductListViewController.h"
@interface SearchScreenViewController ()
{
    PreitAppDelegate *appdelegate;
}
@end

@implementation SearchScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        appdelegate= (PreitAppDelegate *)[[UIApplication sharedApplication]delegate];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    NSString *titleLabel = (NSString*)[appdelegate.mallData objectForKey:@"name"];
    [navigationLabel setText:[titleLabel uppercaseString]];
    NSLog(@"onLabel setTex ==%@",[appdelegate.mallData objectForKey:@"name"]);
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backNavigation.png"] forBarMetrics:UIBarMetricsDefault];

    
}

-(IBAction)MenuOpen:(UIButton *)btn
{
    [appdelegate ShowMenuViewOnTop];
}
    

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	CGFloat height = 60.0;
	return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return appdelegate.isMovie?2:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell;
	cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil){
        //		if(cellIdentifier==@"Cell")
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];// autorelease];
        
        UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_icon1.png"]];
        [view setFrame:CGRectMake(0, 0, 8, 14)];
        cell.accessoryView = view;
//        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
	}
    
//    if (indexPath.row == 0) {
//        cell.textLabel.text = @"STORES BY CATEGORY";
//    }else if (indexPath.row == 1){
//        cell.textLabel.text = @"DINING BY CATEGORY";
//    }else
        if (indexPath.row == 0){
        cell.textLabel.text = @"PRODUCT SEARCH";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"MOVIE TIMES";
    }
//    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    [cell.textLabel setFont:LABEL_TEXT_FONT];//[UIFont systemFontOfSize:17]];

    [cell.textLabel setTextColor:LABEL_TEXT_COLOR];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
    
//    if (indexPath.row == 0) {
//        StoreSearchViewController *screenShoppingindex=[[StoreSearchViewController alloc]initWithNibName:@"StoreSearchViewController" bundle:nil];
//
//        [self.navigationController pushViewController:screenShoppingindex animated:YES];
//    }else if (indexPath.row == 1){
//       
//    }else
        if (indexPath.row == 0){
        [self searchAction:nil];
    }else if (indexPath.row == 1){
        MovieListingViewController *screenMovieListing=[[MovieListingViewController alloc]initWithNibName:@"MovieListingViewController" bundle:nil];
        // Change google
       // [[GAI sharedInstance].defaultTracker sendView:@"Movie Listings"];
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Movie Listings"];
        
        // Send a screenview.
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
		[self.navigationController pushViewController:screenMovieListing animated:YES];
    }
    
    
    
}


-(void)searchAction:(id)sender {
    //    [delegate.mal];
    NSLog(@"searchAction here");
    
    UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"" message:@"Product Search is temporarily unavailable" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] ;
   // [alert show];
    
//    if (NSClassFromString(@"UIAlertController") != nil) {
//        
//        NSLog(@"UIAlertController can be instantiated");
//        UIAlertController * alert=   [UIAlertController
//                                      alertControllerWithTitle:@"My Title"
//                                      message:@"Product Search is temporarily unavailable."
//                                      preferredStyle:UIAlertControllerStyleAlert];
//        [alert ]
//        
//        [self presentViewController:alert animated:YES completion:nil];
//        //make and use a UIAlertController
//        
//    }
//    else {
//        NSLog(@"UIAlertController can no be instantiated");
//       
//        
//        //make and use a UIAlertView
//    }
    
    
   ProductListViewController *productListViewController = [[ProductListViewController alloc]initWithNibName:@"ProductListViewController" bundle:nil];
    [self.navigationItem setTitle:@"Back"];
    [self.navigationController pushViewController:productListViewController animated:YES];
    //kuldeep edit
    //    [productListViewController release];
    
}

@end
