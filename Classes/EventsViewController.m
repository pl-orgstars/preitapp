    //
//  EventsViewController.m
//  Preit
//
//  Created by Aniket on 10/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventsViewController.h"
#import "RequestAgent.h"
#import "EventsDetailsViewController.h"
#import "SelectMonthViewController.h"
#import "AsyncImageView.h"
#import "JSON.h"

@implementation EventsViewController
{

    
    UIView *showPickerView;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	delegate=(PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
	[self setHeader];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backNavigation.png"] forBarMetrics:UIBarMetricsDefault];
//	UIBarButtonItem *refreshButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(buttonAction:)] autorelease];
//	refreshButton.tag=102;
//	self.navigationItem.rightBarButtonItem=refreshButton;
	
//	tableEvents.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
//	tableEvents.separatorColor=[UIColor whiteColor];
	
    tableData=[[NSMutableArray alloc]init];
    constArray=[[NSMutableArray alloc]init];
	disclosureRow=[[NSMutableArray alloc]init];
	pickerItem=[[NSArray alloc]initWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December",nil];
	
	//NSDate *today=[NSDate date];
	NSDateComponents *components=[[NSCalendar currentCalendar]components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
	//NSInteger day=[components day];
	NSInteger month=[components month];
	NSInteger year=[components year];
	
	yearSelected=year;
	monthSelected=month;
//	[self pickerShow:NO];
//	[pickerView selectRow:month-1 inComponent:0 animated:YES];
	
	if(delegate.image3==nil)
	{
		imageView.image=[UIImage imageNamed:@"shopping.jpg"];
		if(delegate.imageLink3 && [delegate.imageLink3 length]!=0)
		{
			CGRect frame;
			frame.size.width=320;
			frame.size.height=480;
			frame.origin.x=0; frame.origin.y=0;
			AsyncImageView* asyncImage = [[AsyncImageView alloc] initWithFrame:frame] ;//autorelease];
			NSURL *url=[NSURL URLWithString:delegate.imageLink3];
			[asyncImage loadImageFromURL:url delegate:self requestSelector:@selector(responseData_Image:)];				
		}
	}
	else
	{
		imageView.image=delegate.image3;
	}

	
	[self getData:@""];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadEvent:) name:@"reloadEvent" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImage3:) name:@"updateGeneral_IMG" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
	if(delegate.refreshEvents)
	{
		delegate.refreshEvents=NO;
		[self viewDidLoad];
	}
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

//- (void)dealloc {
//    [constArray release];
//	[tableData release];
//	[disclosureRow release];
//	[[NSNotificationCenter defaultCenter]removeObserver:self name:@"reloadEvent" object:nil ];
//    [super dealloc];
//}

-(void)setHeader{
	UILabel *titleLabel;
	UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,200, 44)];
	[headerView sizeToFit];
	
	titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 2, 200, 20)];
	titleLabel.text=[delegate.mallData objectForKey:@"name"];
    NSLog(@"123 ==%@",[delegate.mallData objectForKey:@"name"]);

	titleLabel.textColor=[UIColor whiteColor];
	titleLabel.font=[UIFont boldSystemFontOfSize:18];
	titleLabel.shadowColor=[UIColor blackColor];
	titleLabel.textAlignment=UITextAlignmentCenter;
	titleLabel.backgroundColor=[UIColor clearColor];
	[headerView addSubview:titleLabel];
//	[titleLabel release];
	titleLabel =nil;
	titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, 20)];
//	NSString *title=[NSString stringWithFormat:@"Screen%d",screenIndex];
	NSString *title=NSLocalizedString(@"Screen3",@"");
	
	titleLabel.text=title;
    
	titleLabel.textColor=[UIColor whiteColor];
	titleLabel.font=[UIFont systemFontOfSize:14];
	titleLabel.textAlignment=UITextAlignmentCenter;
	titleLabel.backgroundColor=[UIColor clearColor];
	[headerView addSubview:titleLabel];
    headerView.backgroundColor = [UIColor clearColor];
	
	self.navigationItem.titleView=headerView;
    
    [self setNavigationLeftBackButton];
    self.navigationItem.titleView.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backNavigation.png"] forBarMetrics:UIBarMetricsDefault];

//	[headerView release];
}

-(void)showActionSheet
{
    if (is_iOS7)
    {

        if (showPickerView != nil) {
            return;
        }
        
        CGRect frame = delegate.window.bounds;
        frame.origin.y = frame.size.height;

        showPickerView = [[UIView alloc]initWithFrame:frame];
        
        
        
        float height = 162 + 50 + 50 + 30;
        UIView *overlay = [[UIView alloc]initWithFrame:CGRectMake(10, (showPickerView.frame.size.height - height), 300, height - 5)];
        [overlay setBackgroundColor:[UIColor whiteColor]];
        
        overlay.layer.cornerRadius = 5;

        
        [showPickerView addSubview:overlay];
        
        UIPickerView *pickerView = [[UIPickerView alloc] init];//WithFrame:pickerFrame];
        pickerView.showsSelectionIndicator = YES;
        
        pickerView.dataSource = self;
        pickerView.delegate = self;
        
//        [pickerView setBackgroundColor:[UIColor grayColor]];
        [pickerView setFrame:CGRectMake(0, 100, 300, 162)];
        
        
        [overlay addSubview:pickerView];
        
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneButton addTarget:self action:@selector(pickerDoneBttnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        doneButton.tag = 1;
        [doneButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [doneButton setFrame:CGRectMake(0, 50, 300, 40)];
        [overlay addSubview:doneButton];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancel addTarget:self action:@selector(pickerDoneBttnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
        cancel.tag = 0;
        [cancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        
        [cancel setFrame:CGRectMake(0, 0, 300, 40)];
        [overlay addSubview:cancel];
        
        [showPickerView setBackgroundColor:[UIColor clearColor]];
        [self.tabBarController.view addSubview:showPickerView];
        
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = showPickerView.frame;
            frame.origin.y = 0;
            [showPickerView setFrame:frame];
        }];
        
       
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Done" destructiveButtonTitle:@"Cancel" otherButtonTitles:nil];
        [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        
        //	CGRect pickerFrame = CGRectMake(0, 140, 320, 400);
        
        UIPickerView *pickerView = [[UIPickerView alloc] init];//WithFrame:pickerFrame];
        pickerView.showsSelectionIndicator = YES;
        
        pickerView.dataSource = self;
        pickerView.delegate = self;
        
        
        
        //    CGRect pickerRect = pickerView.bounds;
        //    pickerRect.origin.y = -100;
        //    pickerView.bounds = pickerRect;
        
        
        [actionSheet addSubview:pickerView];
        
        
        [pickerView selectRow:monthSelected-1 inComponent:0 animated:YES];

        
        [actionSheet showInView:self.tabBarController.view];

        
        CGRect menuRect = actionSheet.frame;
        CGFloat orgHeight = menuRect.size.height;
        menuRect.origin.y -= 230; //height of picker
        menuRect.size.height = orgHeight+230;
        actionSheet.frame = menuRect;
        
        
        CGRect pickerRect = pickerView.frame;
        pickerRect.origin.y = orgHeight-15;
        pickerView.frame = pickerRect;
    }
    
	
}
-(void)pickerDoneBttnTapped:(UIButton *)sender{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = showPickerView.frame;
        frame.origin.y = frame.size.height;
        [showPickerView setFrame:frame];
    }completion:^(BOOL finished) {
        [showPickerView removeFromSuperview];
        if (sender.tag == 1) {
            [self selectMonthData];
        }
        showPickerView = nil;
        
    }];
}

#pragma mark UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	CGFloat height=60.0;
	if(!isNoData){
		NSDictionary *tmpDict=[[tableData objectAtIndex:indexPath.row]objectForKey:@"event"];
		CGSize constraint = CGSizeMake(200.0000, 20000.0f);
		CGSize titlesize = [[tmpDict objectForKey:@"title"] sizeWithFont:[UIFont boldSystemFontOfSize:18] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		height= (titlesize.height<60?65:(titlesize.height+20));
	}
	return height;	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return isNoData?1:[tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier=isNoData?@"NoData":@"Cell";
	UITableViewCell *cell;

	cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil){
//		if(cellIdentifier==@"Cell")
        if([cellIdentifier isEqualToString:@"Cell"])
			cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] ;//autorelease];
        else
			cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;//autorelease];
	}
//	if(cellIdentifier==@"Cell")
    if([cellIdentifier isEqualToString:@"Cell"])
	{
		cell.textLabel.numberOfLines=0;
		cell.textLabel.font=[UIFont boldSystemFontOfSize:25];
		NSDictionary *tmpDict=[[tableData objectAtIndex:indexPath.row]objectForKey:@"event"];
		cell.textLabel.text=[tmpDict objectForKey:@"title"];
		cell.textLabel.backgroundColor=[UIColor clearColor];
		cell.textLabel.font=LABEL_TEXT_FONT;
		cell.textLabel.textColor=LABEL_TEXT_COLOR;
		
		NSString *dateString=[NSString stringWithFormat:@"%@ - %@",[tmpDict objectForKey:@"startsAt"],[tmpDict objectForKey:@"endsAt"]];
		cell.detailTextLabel.text=dateString;
		cell.detailTextLabel.textColor=DETAIL_TEXT_COLOR;
		cell.detailTextLabel.backgroundColor=[UIColor clearColor];
		
		NSString *htmlString=[tmpDict objectForKey:@"content"];
		if(!htmlString || htmlString==nil || htmlString==[NSNull null] || htmlString==@"<p></p>" || htmlString==@"<p><p></p></p>")
			htmlString=@"";
		
		
		htmlString = [htmlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if([htmlString length]==0)
		{
			[disclosureRow addObject:[NSNumber numberWithBool:NO]];
			cell.accessoryType=UITableViewCellAccessoryNone;	
			cell.selectionStyle=UITableViewCellSelectionStyleNone;

		}
		else
		{
			[disclosureRow addObject:[NSNumber numberWithBool:YES]];
            
            UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_icon1.png"]];
            [view setFrame:CGRectMake(0, 0, 8, 14)];
            cell.accessoryView = view;
//			cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
			cell.selectionStyle=UITableViewCellSelectionStyleGray;

		}
		
	}else
	{
		cell.textLabel.text=@"No Result";
		cell.textLabel.backgroundColor=[UIColor clearColor];
		cell.textLabel.textColor=LABEL_TEXT_COLOR;
		cell.textLabel.textAlignment=UITextAlignmentCenter;
	}	
	return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if(!isNoData)
	{
		if([[disclosureRow objectAtIndex:indexPath.row] boolValue])
		{
			EventsDetailsViewController *screenEventDetail=[[EventsDetailsViewController alloc]initWithNibName:@"EventsDetailsViewController" bundle:nil];
            
            
            //kkkkk
            NSDictionary *tmpDict=[[tableData objectAtIndex:indexPath.row]objectForKey:@"event"];
            
            NSLog(@"event mill gaya %@",[tmpDict objectForKey:@"title"]);
            // Change google
            //[[GAI sharedInstance].defaultTracker sendView:[tmpDict objectForKey:@"title"]];
            [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"title"];
            
            // Send a screenview.
            [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
            
            //kk
			screenEventDetail.dictData=[[tableData objectAtIndex:indexPath.row]objectForKey:@"event"];
			screenEventDetail.flagScreen=YES;
			[self.navigationController pushViewController:screenEventDetail animated:YES];
//			[screenEventDetail release];
		}
	}
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}
#pragma mark Response methods

-(void)getData:(NSString *)apiString
{
	
	apiString=[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"API3",""),apiString];
	NSString *url=[NSString stringWithFormat:@"%@%@",[delegate.mallData objectForKey:@"resource_url"],apiString];
	RequestAgent *req=[[RequestAgent alloc] init];//autorelease];
	[req requestToServer:self callBackSelector:@selector(responseData:) errorSelector:@selector(errorCallback:) Url:url];
	[indicator_ startAnimating];
    //self.navigationItem.rightBarButtonItem.enabled=NO;
}

-(void)responseData:(NSData *)receivedData{
	[indicator_ stopAnimating];
    //self.navigationItem.rightBarButtonItem.enabled=YES;
	if(receivedData!=nil){
        //kuldeep edit
		NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];//autorelease];
		NSMutableArray *tmpArray=[jsonString JSONValue];
        
		[tableData removeAllObjects];
        [constArray removeAllObjects];
		[disclosureRow removeAllObjects];
        
        NSMutableArray* shortListedArray = [[NSMutableArray alloc] init];
        
        if (self.tenantID) {
            if (tmpArray) {
                if (tmpArray.count) {
                    for (NSDictionary *tmpDic in tmpArray) {
                        NSDictionary* eventDic = tmpDic[@"event"];
                        if ([[eventDic objectForKeyWithNullCheck:@"tenant_id"] intValue] == self.tenantID) {
                            [shortListedArray addObject:tmpDic];
                        }
                    }
                }
            }
        }
        
        
        [tmpArray removeAllObjects];
        [tmpArray addObjectsFromArray:shortListedArray];
        
        
		if([tmpArray count]!=0){
			isNoData=NO;
			[tableData addObjectsFromArray:tmpArray];
            [constArray addObjectsFromArray:tmpArray];
		}
		else{
			isNoData=YES;
		}
	}
	else
		isNoData=YES;
	
	[tableEvents reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
}

-(void)errorCallback:(NSError *)error{
	[indicator_ stopAnimating];
	//self.navigationItem.rightBarButtonItem.enabled=YES;
	[delegate showAlert:@"Sorry there was some error.Please check your internet connection and try agian later." title:@"Message" buttontitle:@"Ok"];
}

#pragma mark UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex==1)
	{
        [self selectMonthData];
	}
}

#pragma mark select month data

-(void)selectMonthData {
    
    [tableData removeAllObjects];
    for (NSDictionary *dict in constArray) {
        NSLog(@"dict %@",dict);
        int startMonth = [[[[[dict objectForKey:@"event"] objectForKey:@"end_date"] componentsSeparatedByString:@"-"] objectAtIndex:1]intValue];
        int endMonth = [[[[[dict objectForKey:@"event"]objectForKey:@"start_date"] componentsSeparatedByString:@"-"] objectAtIndex:1]intValue];
        NSLog(@"startmonth %d endmonth %d",startMonth,endMonth);
        if (startMonth==monthSelected||endMonth==monthSelected) {
            [tableData addObject:dict];
        } else {
            if (startMonth<endMonth && (monthSelected > startMonth && monthSelected < endMonth)) {
                [tableData addObject:dict];
            } else if (startMonth>endMonth && (monthSelected < startMonth && monthSelected > endMonth)) {
                [tableData addObject:dict];
            }
        }
        
    }
    [tableEvents reloadData];
}


#pragma mark UIPickerView methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
	return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    monthSelected=row+1;
}



- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
	return [pickerItem count];
	
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
	return [pickerItem objectAtIndex:row];
	
}



-(IBAction)buttonAction:(id)sender{
	UIButton *button=(UIButton *)sender;
	switch (button.tag) {
		case 100:
		{
			NSString *apiString=[NSString stringWithFormat:@"%@?month=%d&year=%d",NSLocalizedString(@"API3.1",@"API3"),monthSelected,yearSelected];
			[self getData:apiString];
			
		}
			break;
		case 101:
		{
		
			[self showActionSheet];

		}
			break;
		case 102:
		{
			[self getData:@""];
		}
			break;

		default:
			break;
	}
}

- (void)reload:(NSNotification*)notification
{

}

-(void)updateImage3:(NSNotification *)notification
{
	imageView.image=delegate.image3;
}

-(void)responseData_Image:(NSData *)receivedData{
	delegate.image3=[UIImage imageWithData:receivedData];
	imageView.image=delegate.image3;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateGeneral_IMG" object:nil];
}

- (IBAction)menuBtnCall:(id)sender {
    
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;

}

- (IBAction)backBtnCall:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}



@end
