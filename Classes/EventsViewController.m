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
    array_section =[NSMutableArray new];
	delegate=(PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
	[self setHeader];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backNavigation.png"] forBarMetrics:UIBarMetricsDefault];
	
    tableData=[[NSMutableArray alloc]init];
    constArray=[[NSMutableArray alloc]init];
	disclosureRow=[[NSMutableArray alloc]init];
	pickerItem=[[NSArray alloc]initWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December",nil];
	

	NSDateComponents *components=[[NSCalendar currentCalendar]components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];

	NSInteger month=[components month];
	NSInteger year=[components year];
	
	yearSelected = (int)year;
	monthSelected =(int) month;
	
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


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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

	titleLabel.textColor=[UIColor whiteColor];
	titleLabel.font=[UIFont boldSystemFontOfSize:18];
	titleLabel.shadowColor=[UIColor blackColor];
	titleLabel.textAlignment=NSTextAlignmentCenter;
	titleLabel.backgroundColor=[UIColor clearColor];
	[headerView addSubview:titleLabel];
	titleLabel =nil;
	titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, 20)];
	NSString *title=NSLocalizedString(@"Screen3",@"");
	
	titleLabel.text=title;
    
	titleLabel.textColor=[UIColor whiteColor];
	titleLabel.font=[UIFont systemFontOfSize:14];
	titleLabel.textAlignment=NSTextAlignmentCenter;
	titleLabel.backgroundColor=[UIColor clearColor];
	[headerView addSubview:titleLabel];
    headerView.backgroundColor = [UIColor clearColor];
	
	self.navigationItem.titleView=headerView;
    
    [self setNavigationLeftBackButton];
    self.navigationItem.titleView.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backNavigation.png"] forBarMetrics:UIBarMetricsDefault];

}


#pragma mark UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	CGFloat height=60.0;
	if(!isNoData){
        NSDictionary *tmpDict=tableData[indexPath.section][indexPath.row][@"event"];
		CGSize constraint = CGSizeMake(200.0000, 20000.0f);
		CGSize titlesize = [[tmpDict objectForKey:@"title"] sizeWithFont:[UIFont boldSystemFontOfSize:18] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		height= (titlesize.height<60?65:(titlesize.height+20));
	}
	return height;	
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 320.0, 35.0)] ;
    customView.backgroundColor = [UIColor grayColor];;
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero] ;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    headerLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    headerLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    headerLabel.frame = CGRectMake(10,0, 300.0, 35.0);
    headerLabel.textAlignment = UITextAlignmentLeft;
    headerLabel.text = array_section[section];
    [customView addSubview:headerLabel];
    return customView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return array_section.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return array_section[section];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"section %d",(int)[tableData[section] count]);
	return isNoData ? 1 : [tableData[section] count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = isNoData ? @"NoData" : @"Cell";
	UITableViewCell *cell;

	cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil)
    {
        if([cellIdentifier isEqualToString:@"Cell"])
			cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] ;
        else
			cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
	}
    if([cellIdentifier isEqualToString:@"Cell"])
	{

		cell.textLabel.numberOfLines=0;
		cell.textLabel.font=[UIFont boldSystemFontOfSize:25];
        NSDictionary *tmpDict=tableData[indexPath.section][indexPath.row][@"event"];

		cell.detailTextLabel.text=[tmpDict objectForKey:@"title"];
		cell.textLabel.backgroundColor=[UIColor clearColor];
		cell.textLabel.font=DETAIL_TEXT_FONT_BOLD;
		cell.textLabel.textColor=LABEL_TEXT_COLOR;
		
		NSString *dateString=[NSString stringWithFormat:@"%@ - %@",[tmpDict objectForKey:@"startsAt"],[tmpDict objectForKey:@"endsAt"]];
		cell.textLabel.text=dateString;
		cell.detailTextLabel.textColor=DETAIL_TEXT_COLOR;
        cell.detailTextLabel.font=LABEL_TEXT_FONT;
		cell.detailTextLabel.backgroundColor=[UIColor clearColor];
		
		NSString *htmlString=[tmpDict objectForKey:@"content"];
		if(!htmlString || htmlString==nil || htmlString ==[NSNull null] || htmlString==@"<p></p>" || htmlString==@"<p><p></p></p>")
			htmlString=@"";
		
		
		htmlString = [htmlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if([htmlString length]==0)
		{
            [tmpDict setValue:@"0" forKey:@"disclosureRow"];
			cell.accessoryType =UITableViewCellAccessoryNone;
			cell.selectionStyle=UITableViewCellSelectionStyleNone;
		}
		else
		{
            [tmpDict setValue:@"1" forKey:@"disclosureRow"];
            UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_icon1.png"]];
            [view setFrame:CGRectMake(0, 0, 8, 14)];
            cell.accessoryView = view;
			cell.selectionStyle=UITableViewCellSelectionStyleGray;
		}
        
        
        
        if(![tmpDict[@"disclosureRow"] boolValue])
        {
            cell.accessoryType =UITableViewCellAccessoryNone;
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            cell.accessoryView.hidden = TRUE;
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
        NSDictionary *tmpDict=tableData[indexPath.section][indexPath.row][@"event"];
        
		if([tmpDict[@"disclosureRow"] boolValue])
		{
			EventsDetailsViewController *screenEventDetail=[[EventsDetailsViewController alloc]initWithNibName:@"EventsDetailsViewController" bundle:nil];
            
            // Change google
            [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"title"];
            
            // Send a screenview.
            [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
            
			screenEventDetail.dictData=tableData[indexPath.section][indexPath.row][@"event"];
			screenEventDetail.flagScreen=YES;
			[self.navigationController pushViewController:screenEventDetail animated:YES];
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
}

-(void)responseData:(NSData *)receivedData{
	[indicator_ stopAnimating];
	if(receivedData!=nil){
        //kuldeep edit
		NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];//autorelease];
		NSMutableArray *tmpArray=[jsonString JSONValue];
        NSLog(@"receivedDatareceivedData %@",tmpArray);

		[tableData removeAllObjects];
        [constArray removeAllObjects];
		[disclosureRow removeAllObjects];
        
        
        if (self.tenantID) {
            if (tmpArray) {
                if (tmpArray.count) {
                    NSMutableArray* shortListedArray = [[NSMutableArray alloc] init];

                    for (NSDictionary *tmpDic in tmpArray) {
                        NSDictionary* eventDic = tmpDic[@"event"];
                        if ([[eventDic objectForKeyWithNullCheck:@"tenant_id"] intValue] == self.tenantID) {
                            [shortListedArray addObject:tmpDic];
                        }
                    }
                    [tmpArray removeAllObjects];
                    [tmpArray addObjectsFromArray:shortListedArray];
                }
            }
        }
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
  
    [self SortArray];
    [tableEvents reloadData];
}



-(void)SortArray
{
    NSMutableArray *sectionDummyArray = [NSMutableArray new];
    
    [array_section removeAllObjects];
    
    //////// Date Format ////////////
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    
    NSDateFormatter *formatterMonth = [[NSDateFormatter alloc] init];
    [formatterMonth setDateFormat:@"yyyyMM"];
   
    NSDateFormatter *formatterSection = [[NSDateFormatter alloc] init];
    [formatterSection setDateFormat:@"MMMM yyyy"];
    
    ///////// Make Section from Data Array //////////
    for (int index = 0; index <tableData.count ; index++)
    {
        
        NSDate *newDate = [formatter dateFromString:tableData[index][@"event"][@"start_date"]];
        
        NSString *strNew = [formatterMonth stringFromDate:newDate];

        BOOL isFound = FALSE;
        
        for (int indexSection = 0; indexSection < sectionDummyArray.count; indexSection++)
        {
            if ([sectionDummyArray[indexSection] integerValue] == [strNew integerValue])
                isFound = TRUE;
        }
        

        if (!isFound)
        {
            [sectionDummyArray addObject:strNew];
            [array_section addObject:[formatterSection stringFromDate:newDate]];
        }
        
    }

    NSMutableArray *newArray = [NSMutableArray new];

    //////// Make Group of data according to Section//////////
    for (int indexOuter = 0; indexOuter < sectionDummyArray.count; indexOuter++)
    {
        NSMutableArray *arrayDummy = [NSMutableArray new];
        
        for (int index = 0 ; index < tableData.count; index++)
        {
            NSDate *newDate = [formatter dateFromString:tableData[index][@"event"][@"start_date"]];
            
            NSString *strNew = [formatterMonth stringFromDate:newDate];
            
           if ([sectionDummyArray[indexOuter] integerValue] == [strNew integerValue])
               [arrayDummy addObject:tableData[index]];
        }
        [newArray addObject:arrayDummy];
    }

    [tableData removeAllObjects];
    [tableData addObjectsFromArray:newArray];
    NSLog(@"section %@",array_section);
    
}

-(void)errorCallback:(NSError *)error{
	[indicator_ stopAnimating];
	[delegate showAlert:@"Sorry there was some error.Please check your internet connection and try agian later." title:@"Message" buttontitle:@"Ok"];
}



#pragma mark UIPickerView methods

//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
//{
//	return 1;
//}
//
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    monthSelected = (int)row+1;
//}
//
//
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
//{
//	return [pickerItem count];
//	
//}
//
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
//{
//	return [pickerItem objectAtIndex:row];
//}

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
