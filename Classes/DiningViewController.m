    //
//  DinningViewController.m
//  Preit
//
//  Created by Aniket on 10/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DiningViewController.h"
#import "AsyncImageView.h"
#import "DiningDetailViewController.h"
#import "JSBridgeViewController.h"

@implementation DiningViewController

- (void)viewDidLoad {
	self.imageView.image=[UIImage imageNamed:@"dinning.jpg"];
	self.screenIndex=2;
    [super viewDidLoad];
	
	if(delegate.image2 == nil || delegate.image2==nil)
	{
		if(delegate.image3)
			imageView.image=delegate.image3;
		else
			imageView.image=[UIImage imageNamed:@"dinning.jpg"];
		
		if(delegate.imageLink2 && [delegate.imageLink2 length]!=0)
		{
			CGRect frame;
			frame.size.width=320;
			if(isIPhone5){frame.size.height=586;}else{frame.size.height=480;}
			frame.origin.x=0; frame.origin.y=0;
			AsyncImageView* asyncImage = [[AsyncImageView alloc] initWithFrame:frame];// autorelease];
			NSURL *url=[NSURL URLWithString:delegate.imageLink2];
			[asyncImage loadImageFromURL:url delegate:self requestSelector:@selector(responseData_Image:)];				
		}
	}
	else
	{
		imageView.image=delegate.image2;
	}
    
    self.titleLabel.text = @"DINING";
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImage2:) name:@"updateDining_IMG" object:nil];
    
    
    
    if ([tableCustom respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableCustom setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableCustom respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableCustom setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidAppear:(BOOL)animated{
	if(delegate.refreshDining)
	{
		delegate.refreshDining=NO;
		apiString=nil;
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


- (CGFloat)tableView_:(UITableView *)tableView modified_heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.tableData count];
}



- (void)tableView_:(UITableView *)tableView modified_cellForRowAtIndexPath:(NSIndexPath *)indexPath cell:(UITableViewCell*)cell {
  
    
    NSDictionary *tmpDict=[self.tableData objectAtIndex:indexPath.row];
    
    DirectoryTableViewCell* newCell;
    
    if (![cell.reuseIdentifier isEqualToString:@"directoryCell"]) {
        newCell = [tableView dequeueReusableCellWithIdentifier:@"directoryCell"];
        
        if (!newCell) {
            newCell = [[NSBundle mainBundle] loadNibNamed:@"DirectoryTableViewCell" owner:self options:nil].firstObject;
        }

    }
    else{
        
        newCell = (DirectoryTableViewCell*)cell;
    }
    
    newCell.titleLabel.text = tmpDict[@"name"];
    
    newCell.phoneBtn.tag = indexPath.row;
    [newCell.phoneBtn addTarget:self action:@selector(cellPhoneAction:) forControlEvents:UIControlEventTouchUpInside];
    
    newCell.mapButton.tag = indexPath.row;
    [newCell.mapButton addTarget:self action:@selector(cellMapAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)tableView:(UITableView *)tableView modified_didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DiningDetailViewController *screenStoreDetail=[[DiningDetailViewController alloc]initWithNibName:@"CustomStoreDetailViewController" bundle:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        screenStoreDetail.titleLabel.text = @"DINING";

    });
	NSDictionary *tmpDict=[self.tableData objectAtIndex:indexPath.row];
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"name"];
    
    // Send a screenview.
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
	screenStoreDetail.dictData=tmpDict;
	[self.navigationController pushViewController:screenStoreDetail animated:YES];
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self tableView:tableView modified_didSelectRowAtIndexPath:indexPath];	
}
-(void)updateImage2:(NSNotification *)notification
{
	imageView.image=delegate.image2;
}

-(void)responseData_Image:(NSData *)receivedData{
	delegate.image2=[UIImage imageWithData:receivedData];
	imageView.image=delegate.image2;
}


#pragma mark - Cell Button Actions

- (IBAction)cellPhoneAction:(UIButton *)sender {
    NSDictionary *tempDict = tableData[sender.tag];
    
    NSString* phoneNumber = tempDict[@"telephone"];
    phoneNumber = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    NSString *url = [NSString stringWithFormat:@"tel:%@", phoneNumber];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
   
}

- (IBAction)cellMapAction:(UIButton *)sender {
    
    
    NSDictionary *dictData = [tableData objectAtIndex:sender.tag];
    NSDictionary *suite=[dictData objectForKey:@"suite"];
    int suiteID=[[suite objectForKey:@"id"] intValue];
    if(suiteID>0)
    {
        JSBridgeViewController *screenMap=[[JSBridgeViewController alloc]initWithNibName:@"JSBridgeViewController" bundle:nil];
        
        screenMap.mapUrl=[NSString stringWithFormat:@"%@/areas/getarea?suit_id=%d",[delegate.mallData objectForKey:@"resource_url"],suiteID];
        [self.navigationController pushViewController:screenMap animated:YES];
    }
    
}

@end
