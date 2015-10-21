//
//  CustomTable.m
//  Preit
//
//  Created by Aniket on 10/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomTable.h"
#import "RequestAgent.h"
#import "ShoppingStoreViewController.h"
#import "JSON.h"
#import "LoadingAgent.h"
#import "ShoppingViewController.h"
#import "DirectoryTableViewCell.h"

@implementation CustomTable
@synthesize tableCustom,imageView,delegate,screenIndex,tableData,heading,apiString,disclosureRow;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	delegate=(PreitAppDelegate*)[[UIApplication sharedApplication]delegate];

	[self setHeader];
    
	tableCustom.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
	tableCustom.separatorColor=[UIColor lightGrayColor];
	if(!self.tableData)
		tableData=[[NSMutableArray alloc]init];
	if(!self.disclosureRow)
		self.disclosureRow=[[NSMutableArray alloc]init];
	if(screenIndex==1 && !self.heading)
	{

	}


	[self getData];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"Reload" object:nil];
    
    
    
    UITextField *textField = [searchBar_ valueForKey:@"_searchField"];
    textField.clearButtonMode = UITextFieldViewModeNever;
    searchBar_.delegate = self;
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)setHeader{
	UILabel *titleLabel;
	UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,200, 44)];
	[headerView sizeToFit];

	titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 2, 200, 20)];
	titleLabel.text=[delegate.mallData objectForKey:@"name"];
    NSLog(@"titleLabel ==%@",[delegate.mallData objectForKey:@"name"]);
    titleLabel.textColor = [UIColor whiteColor];
	titleLabel.font=[UIFont boldSystemFontOfSize:18];
	titleLabel.shadowColor=[UIColor blackColor];
	titleLabel.textAlignment=NSTextAlignmentCenter;
	titleLabel.backgroundColor=[UIColor clearColor];
	[headerView addSubview:titleLabel];
    //kuldeep
	
    UILabel *titleLabels;
	titleLabels=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, 20)];
	NSString *title=[NSString stringWithFormat:@"Screen%d",screenIndex];
	title=NSLocalizedString(title,@"");
	if(self.heading)
		title=[NSString stringWithFormat:@"%@-%@",title,self.heading];
	
	titleLabels.text=title;
	titleLabels.textColor=[UIColor whiteColor];
	titleLabels.font=[UIFont systemFontOfSize:14];
	titleLabels.textAlignment=NSTextAlignmentCenter;
	titleLabels.backgroundColor=[UIColor clearColor];
	[headerView addSubview:titleLabels];
    headerView.backgroundColor = [UIColor clearColor];
	self.navigationItem.titleView=headerView;
    self.navigationItem.titleView.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    if (![self isKindOfClass:[ShoppingViewController class]])
       [self setNavigationLeftBackButton];

    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backNavigation.png"] forBarMetrics:UIBarMetricsDefault];
    
}



- (IBAction)menuBtnCall:(id)sender {
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;

}


#pragma mark UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height=60.0;
	if(!isNoData)
		height= [self tableView_:tableView modified_heightForRowAtIndexPath:indexPath];
	
	return height;
}

- (CGFloat)tableView_:(UITableView *)tableView modified_heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *tmpDict=[[self.tableData objectAtIndex:indexPath.row]objectForKey:@"tenant_category"];
	CGSize constraint = CGSizeMake(200.0000, 20000.0f);
	CGSize titlesize = [[tmpDict objectForKey:@"name"] sizeWithFont:[UIFont boldSystemFontOfSize:25] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	return (titlesize.height<60?65:(titlesize.height+10));
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return isNoData?1:[self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    UITableViewCell *cell;
    
    if ([self.titleLabel.text isEqualToString:@"DINING"]) {
        
        DirectoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"directoryCell"];
        
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"DirectoryTableViewCell" owner:self options:nil].firstObject;
        }
        
        [self tableView_:tableView modified_cellForRowAtIndexPath:indexPath cell:cell];
        
        return cell;
        
        
    }
    
    else{
        
        NSString *cellIdentifier=isNoData?@"NoData":@"Cell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil){
            if ([cellIdentifier isEqualToString:@"Cell"])
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            else
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        if ([cellIdentifier isEqualToString:@"Cell"])
        {
            cell.textLabel.numberOfLines=0;
            cell.textLabel.font=[UIFont systemFontOfSize:17];
            cell.textLabel.textColor=LABEL_TEXT_COLOR;
            cell.selectionStyle=UITableViewCellSelectionStyleGray;
            [self tableView_:tableView modified_cellForRowAtIndexPath:indexPath cell:cell];
            
        }else
        {
            cell.textLabel.text=@"No Result";
            cell.textLabel.textColor=LABEL_TEXT_COLOR;
            cell.textLabel.backgroundColor=[UIColor clearColor];
            cell.textLabel.textAlignment=NSTextAlignmentCenter;
        }
    }
    
    return cell;	
}

- (void)tableView_:(UITableView *)tableView modified_cellForRowAtIndexPath:(NSIndexPath *)indexPath cell:(UITableViewCell*)cell
{
	NSDictionary *tmpDict=[[self.tableData objectAtIndex:indexPath.row]objectForKey:@"tenant_category"];
	cell.textLabel.text=[tmpDict objectForKey:@"name"];	
	cell.textLabel.textColor=LABEL_TEXT_COLOR;
	cell.textLabel.backgroundColor=[UIColor clearColor];
    
	[cell.textLabel sizeToFit];
    UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_icon1.png"]];
    [view setFrame:CGRectMake(0, 0, 8, 14)];
    cell.accessoryView = view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if(!isNoData)
		[self tableView:tableView modified_didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView modified_didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"table data :: %@",self.tableData);
   
	ShoppingStoreViewController *screenStore=[[ShoppingStoreViewController alloc]initWithNibName:@"CustomTable" bundle:nil];
	NSDictionary *tmpDict=[[self.tableData objectAtIndex:indexPath.row]objectForKey:@"tenant_category"];
	screenStore.heading=[tmpDict objectForKey:@"name"];
	screenStore.tableData=[tmpDict objectForKey:@"tenants"];
    
    // Change google
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"name"];
    
    // Send a screenview.
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
    //kk
    
	[self.navigationController pushViewController:screenStore animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self tableView:tableView modified_didSelectRowAtIndexPath:indexPath];
}

#pragma mark Response methods

-(void)getData
{
    NSLog(@"Get data");
	if(!apiString)
		apiString=[NSString stringWithFormat:@"API%d",screenIndex];
	NSString *url=[NSString stringWithFormat:@"%@%@",[delegate.mallData objectForKey:@"resource_url"],NSLocalizedString(apiString,"")];

    NSLog(@"url:::::::::::%@",url);
	RequestAgent *req=[[RequestAgent alloc] init];// autorelease];
	[req requestToServer:self callBackSelector:@selector(responseData:) errorSelector:@selector(errorCallback:) Url:url];
//	[indicator_ startAnimating];
    [[LoadingAgent defaultAgent]makeBusy:YES];
	
	if(screenIndex==1)
		self.navigationItem.rightBarButtonItem.enabled=NO;
	
}

-(void)responseData:(NSData *)receivedData{
	
	if(screenIndex==1)
	{
		self.navigationItem.rightBarButtonItem.enabled=YES;
		NSLog(@"button enabled:::::::::::::::::::: ");
	}
	
//	[indicator_ stopAnimating];
    [[LoadingAgent defaultAgent]makeBusy:NO];
	if(receivedData!=nil){
		NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];// autorelease];
		NSArray *tmpArray=[jsonString JSONValue];

		[self.tableData removeAllObjects];
		if([tmpArray count]!=0)
        {
			[delegate.shoppingStores removeAllObjects];
			if(screenIndex==1)
				[delegate.shoppingStores addObjectsFromArray:tmpArray];
			if(screenIndex==2)
               tmpArray=[[[tmpArray objectAtIndex:0]objectForKey:@"tenant_category"]objectForKey:@"tenants" ];

			[self.tableData addObjectsFromArray:tmpArray];
            
            downloadedData = [[NSArray alloc] initWithArray:tmpArray];
            
			
		}
		else
        {
			isNoData=YES;
		}
	}
	else
		isNoData=YES;
	[tableCustom reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
}

-(void)errorCallback:(NSError *)error
{
//	[indicator_ stopAnimating];
    [[LoadingAgent defaultAgent]makeBusy:NO];
	if(screenIndex==1)
	{
		self.navigationItem.rightBarButtonItem.enabled=YES;
	}
	
	[delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Message" buttontitle:@"Ok"];
}

- (void)reload:(NSNotification*)notification
{
    
}

- (IBAction)backBtnCall:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)buttonAction:(id)sender
{
	[self getData];
}


#pragma mark search bar

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{

}


- (IBAction)searchBarClearBtn:(UIButton*)sender {

    if (searchBar_.isFirstResponder) {
        searchBar_.text = @"";
        [searchBar_ resignFirstResponder];
        [self filterContentForSearchText:@""];

    }


}



-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filterContentForSearchText:searchBar.text];
}


- (void)filterContentForSearchText:(NSString*)searchText
{
    /*
     Update the filtered array based on the search text and scope.
     */

    [tableData removeAllObjects]; // First clear the filtered array.

    /*
     Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
     */



        for (NSDictionary *dict in downloadedData)
        {
            
            NSString *sTemp=[dict objectForKey:@"name"];

            NSComparisonResult result = [sTemp compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];

            if (result == NSOrderedSame)
            {
                [tableData addObject:dict];
            }
        }

    [tableCustom reloadData];
}




/*
- (void)dealloc {
    [super dealloc];
}*/
@end
