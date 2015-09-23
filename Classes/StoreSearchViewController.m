//
//  StoreSearchViewController.m
//  Preit
//
//  Created by Aniket on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StoreSearchViewController.h"
#import "StoreDetailsViewController.h"
#import "RequestAgent.h"
#import "QuartzCore/QuartzCore.h"
#import "JSON.h"


#define TAG_IMAGEVIEW 100;

@implementation StoreSearchViewController
@synthesize listContent, filteredListContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive;


#pragma mark - 
#pragma mark Lifecycle methods

- (void)viewDidLoad
{

	[self setNavigationTitle:@"Stores" withBackButton:YES];

	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(buttonAction:)];// autorelease];
	refreshButton.tag=100;
    [refreshButton setTintColor:[UIColor blackColor]];
    
	self.navigationItem.rightBarButtonItem=refreshButton;

    
    
	[self makeLoadingView];
	
	delegate=(PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
	
	//Initialize the array.
	listContent = [[NSMutableArray alloc] init];
	
	if([delegate.storeListContent count]>0)
		[listContent addObjectsFromArray:delegate.storeListContent];
	
		
	// create a filtered list that will contain products for the search results table.
	self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.listContent count]];
	
	// restore search settings if they were saved in didReceiveMemoryWarning.

	
	NSString *path = [[[NSBundle mainBundle] bundlePath]stringByAppendingPathComponent:@"checkDict.plist"];
	checkDict = [[NSDictionary dictionaryWithContentsOfFile:path] mutableCopy];

	
	indexArray = [[NSMutableArray alloc] init];
	NSNumber *num=[NSNumber numberWithInt:-1];
	[indexArray addObject:num];
	[indexArray addObject:num];
	[indexArray addObject:num];
	[indexArray addObject:num];
	[indexArray addObject:num];
	[indexArray addObject:num];
	[indexArray addObject:num];
	[indexArray addObject:num];
	[indexArray addObject:num];
	[indexArray addObject:num];
	[indexArray addObject:num];
	[indexArray addObject:num];
	[indexArray addObject:num];
	[indexArray addObject:num];
	[indexArray addObject:num];
	[indexArray addObject:num];
	[indexArray addObject:num];
	[indexArray addObject:num];
	[indexArray addObject:num];
	[indexArray addObject:num];
	[indexArray addObject:num];
	[indexArray addObject:num];
	[indexArray addObject:num];
	[indexArray addObject:num];
	[indexArray addObject:num];
	[indexArray addObject:num];
	[indexArray addObject:num];
	
	tempArray = [[NSMutableArray alloc] init];
	[tempArray addObject:@"123"];
	[tempArray addObject:@"A"];
	[tempArray addObject:@"B"];
	[tempArray addObject:@"C"];
	[tempArray addObject:@"D"];
	[tempArray addObject:@"E"];
	[tempArray addObject:@"F"];
	[tempArray addObject:@"G"];
	[tempArray addObject:@"H"];
	[tempArray addObject:@"I"];
	[tempArray addObject:@"J"];
	[tempArray addObject:@"K"];
	[tempArray addObject:@"L"];
	[tempArray addObject:@"M"];
	[tempArray addObject:@"N"];
	[tempArray addObject:@"O"];
	[tempArray addObject:@"P"];
	[tempArray addObject:@"Q"];
	[tempArray addObject:@"R"];
	[tempArray addObject:@"S"];
	[tempArray addObject:@"T"];
	[tempArray addObject:@"U"];
	[tempArray addObject:@"V"];
	[tempArray addObject:@"W"];
	[tempArray addObject:@"X"];
	[tempArray addObject:@"Y"];
	[tempArray addObject:@"Z"];
	
    NSLog(@"sadadasd dss    %@",listContent);
	if([listContent count]==0)
		[self getData];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backNavigation.png"] forBarMetrics:UIBarMetricsDefault];

}

- (void)viewDidUnload
{
	self.filteredListContent = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
}




#pragma mark -
#pragma mark UITableView data source and delegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	CGFloat height = 60.0;
	return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	if (tableView == self.searchDisplayController.searchResultsTableView || isNoData)
	{
        return 1;
    }
	else
	{
		return [tempArray count];
	}		
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	/*
	 If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
	 */
	
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredListContent count];
    }
	else
	{	
		if([self.listContent count] && [self.listContent count]>section)
		{
			NSArray *tmpArray=[self.listContent objectAtIndex:section];
			 if(tmpArray)
				return [tmpArray count];

		}
		else if(isNoData) return 1;

        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	if (tableView == self.searchDisplayController.searchResultsTableView || isNoData)
		return -1;	
	return index;	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *kCellID=isNoData?@"NoData":@"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellID];// autorelease];
	}
	
	
	/*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */
	
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
 		NSDictionary *tmpDict=[self.filteredListContent objectAtIndex:indexPath.row];
		cell.textLabel.text=[tmpDict objectForKey:@"name"];
        
		cell.textLabel.textColor=[UIColor whiteColor];
        
        cell.detailTextLabel.text = [tmpDict objectForKeyWithNullCheck:@"area_name"];
        
        UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_icon1.png"]];
        [view setFrame:CGRectMake(0, 0, 8, 14)];
        cell.accessoryView = view;
	}
	else
	{
		if([kCellID isEqual:@"cellID"])
		{
			NSArray *tmpArray = [self.listContent objectAtIndex:indexPath.section];
			if([tmpArray count]>0)
			{
				NSDictionary *tmpDict=[[tmpArray objectAtIndex:indexPath.row] objectForKey:@"tenant"];
				cell.textLabel.text=[tmpDict objectForKey:@"name"];
                cell.detailTextLabel.text = [tmpDict objectForKeyWithNullCheck:@"area_name"];
			}
            UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_icon1.png"]];
            [view setFrame:CGRectMake(0, 0, 8, 14)];
            cell.accessoryView = view;
		    cell.selectionStyle=UITableViewCellSelectionStyleGray;
		}
		else 
		{
			cell.textLabel.text=@"No Result";
			cell.textLabel.textAlignment = NSTextAlignmentCenter;
			cell.selectionStyle=UITableViewCellSelectionStyleNone;
		}

	}
    cell.textLabel.numberOfLines = 0;
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *tmpDict;
	/*
	 If the requesting table view is the search display controller's table view, configure the next view controller using the filtered content, otherwise use the main list.
	 */
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
		tmpDict=[self.filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
		if(isNoData) return;
		NSArray *tmpArray = [self.listContent objectAtIndex:indexPath.section];
    	tmpDict=[[tmpArray objectAtIndex:indexPath.row] objectForKey:@"tenant"];
	}
	
	StoreDetailsViewController *screenStoreDetail=[[StoreDetailsViewController alloc]initWithNibName:@"CustomStoreDetailViewController" bundle:nil];
	screenStoreDetail.dictData=tmpDict;	
	[self.navigationController pushViewController:screenStoreDetail animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	
	if (tableView == self.searchDisplayController.searchResultsTableView)
		return nil;
	
	return tempArray;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (tableView == self.searchDisplayController.searchResultsTableView)
		return @"Search Results";
	else if(isNoData)
		return nil;
	else 
		return [tempArray objectAtIndex:section];
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	for (NSArray *array in listContent)
	{
		for (NSDictionary *dict in array)
		{
			NSDictionary *tmpDict=[dict objectForKey:@"tenant"];
			NSString *sTemp=[tmpDict objectForKey:@"name"];
			
			NSComparisonResult result = [sTemp compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
 			
			if (result == NSOrderedSame)
			{
				[self.filteredListContent addObject:tmpDict];
            }
		}
	}	
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] ];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


-(void)getData{	
	isNoData=NO;
	NSString *url=[NSString stringWithFormat:@"%@%@",[delegate.mallData objectForKey:@"resource_url"],NSLocalizedString(@"API1.2","")];

	RequestAgent *req= [[RequestAgent alloc] init];// autorelease];
	[req requestToServer:self callBackSelector:@selector(responseData:) errorSelector:@selector(errorCallback:) Url:url];
	[self loadingView:YES];
}

-(void)responseData:(NSData *)receivedData{
	[self loadingView:NO];

	if(receivedData!=nil){
		NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];// autorelease];
		// test string

		NSArray *tmpArray=[jsonString JSONValue];


		[listContent removeAllObjects];
		if([tmpArray count]!=0){
            
            NSSortDescriptor *sortName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            NSArray *sortDescriptor = [NSArray arrayWithObject:sortName];
            tmpArray = [tmpArray sortedArrayUsingDescriptors:sortDescriptor];
			
			for(int i=0;i<[tmpArray count];i++)
			{
				NSDictionary *tmpDict=[[tmpArray objectAtIndex:i]objectForKey:@"tenant"];
				[self checkIndex:[tmpDict objectForKey:@"name"] forindex:i];
			}
			
			for(int i=0;i<[indexArray count];i++)
			{
				int x,y;				
				int number=[[indexArray objectAtIndex:i] intValue];

				if(number==-1)
				{
					NSArray *emptyArray=[[NSArray alloc]init];
					[listContent addObject:emptyArray];
				}
				else 
				{	
				x=number;	
				if([[tempArray objectAtIndex:i] isEqualToString:@"Z"])
				{
					y=[tmpArray count]-x;				
				}
				else 
				{
					int z=i+1;
					int num=[[indexArray objectAtIndex:z] intValue];

					if([[tempArray objectAtIndex:z] isEqualToString:@"Z"] && num==-1)
							num=-2;
					
 					while (num==-1) 
					{
						z++;
						num=[[indexArray objectAtIndex:z] intValue];
						if([[tempArray objectAtIndex:z] isEqualToString:@"Z"] && num==-1)
						    num=-2;
					}
	                if(num==-2)
					{
						y=[tmpArray count]-x;
					}
					else
						y=num-x;
				}
					
				// Starting at position x, get y characters
				NSRange range={x,y};
				NSIndexSet *indexes=[NSIndexSet indexSetWithIndexesInRange:range];
                    NSArray *objectArray=[tmpArray objectsAtIndexes:indexes];// retain];

				[listContent addObject:objectArray];
			}
			}
			

			delegate.storeListContent=listContent;
		}
		else{
			isNoData=YES;
		}
	}
	else
		isNoData=YES;
	
	[self.tableView reloadData];
}

-(void)errorCallback:(NSError *)error{
   [self loadingView:NO];
	[delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Message" buttontitle:@"Ok"];
}

-(void)buttonAction:(id)sender
{
	UIButton *button=(UIButton*)sender;
	if(button.tag==100)
		[self getData];
}

-(void)makeLoadingView
{
	UIWindow* keywindow = [[UIApplication sharedApplication] keyWindow];
	CGRect keyFrame=[keywindow frame];
	CGRect frame=CGRectMake(keyFrame.origin.x, keyFrame.origin.y, keyFrame.size.width, keyFrame.size.height);
    
	main_view = [[UIView alloc] initWithFrame:frame];
	main_view.backgroundColor = [UIColor clearColor];
	main_view.alpha =1.0;
	
	UIActivityIndicatorView *wait = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	wait.hidesWhenStopped = NO;			
	
	frame=CGRectMake(56.0,180.0, 211.0, 121.0);
	UIView *loadingView=[[UIView alloc]initWithFrame:frame];
	loadingView.backgroundColor=[UIColor darkGrayColor];

	frame=CGRectMake(32.0,20.0, 159.0,60.0);
	UILabel *loadingLabel = [[UILabel alloc] initWithFrame:frame];
	loadingLabel.textColor = [UIColor whiteColor];
	loadingLabel.backgroundColor = [UIColor clearColor];
	loadingLabel.font=[UIFont boldSystemFontOfSize:18];
	loadingLabel.textAlignment = UITextAlignmentCenter;
	loadingLabel.text = @"Please wait loading stores...";
	loadingLabel.numberOfLines=0;
	[loadingView addSubview:loadingLabel];
	[loadingView addSubview:wait];
	
	frame=CGRectMake(86.0, 77.0, 37.0,37.0);
	wait.frame=frame;
	
	CALayer *l=[loadingView layer];
	[l setCornerRadius:10.0];
	[l setBorderWidth:3.0];
	[l setBorderColor:[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]CGColor]];
	
	[main_view addSubview:loadingView];
	[wait startAnimating];
}

-(void)loadingView:(BOOL)flag
{
	if(flag){
		[[[UIApplication sharedApplication] keyWindow] addSubview:main_view];
		[[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:main_view];
	}else 
		[main_view removeFromSuperview];
}


-(void)checkIndex:(NSString*)name forindex:(int)i
{	
	NSRange range = {0,1};
	name = [name substringWithRange:range];
	name=[name uppercaseString];
	NSNumber *num=[NSNumber numberWithInt:i];
	if(![name caseInsensitiveCompare:@"A"])
	{	
		if([[checkDict valueForKey:@"A"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"A"];
		}		
	}
	else if(![name caseInsensitiveCompare:@"B"])
	{	
		if([[checkDict valueForKey:@"B"]intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"B"];
		}
	}
	else if(![name caseInsensitiveCompare:@"C"])
	{	
		if([[checkDict valueForKey:@"C"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"C"];
		}
	}
	else if(![name caseInsensitiveCompare:@"D"])
	{	
		if([[checkDict valueForKey:@"D"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"D"];
		}
	}
	else if(![name caseInsensitiveCompare:@"E"])
	{	
		if([[checkDict valueForKey:@"E"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"E"];
		}
	}
	else if(![name caseInsensitiveCompare:@"F"])
	{	
		if([[checkDict valueForKey:@"F"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"F"];
		}
	}
	else if(![name caseInsensitiveCompare:@"G"])
	{	
		if([[checkDict valueForKey:@"G"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"G"];
		}
	}
	else if(![name caseInsensitiveCompare:@"H"])
	{	
		if([[checkDict valueForKey:@"H"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"H"];
		}
	}
	else if(![name caseInsensitiveCompare:@"I"])
	{	
		if([[checkDict valueForKey:@"i"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"I"];
		}
	}
	else if(![name caseInsensitiveCompare:@"J"])
	{	
		if([[checkDict valueForKey:@"J"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"J"];
		}
	}
	else if(![name caseInsensitiveCompare:@"K"])
	{	
		if([[checkDict valueForKey:@"K"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"K"];
		}
	}
	else if(![name caseInsensitiveCompare:@"L"])
	{	
		if([[checkDict valueForKey:@"L"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"L"];
		}
	}
	else if(![name caseInsensitiveCompare:@"M"])
	{	
		if([[checkDict valueForKey:@"M"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"M"];
		}
	}
	else if(![name caseInsensitiveCompare:@"N"])
	{	
		if([[checkDict valueForKey:@"N"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"N"];
		}
	}
	else if(![name caseInsensitiveCompare:@"O"])
	{	
		if([[checkDict valueForKey:@"O"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"O"];
		}
	}
	else if(![name caseInsensitiveCompare:@"P"])
	{	
		if([[checkDict valueForKey:@"P"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"P"];
		}
	}
	else if(![name caseInsensitiveCompare:@"Q"])
	{	
		if([[checkDict valueForKey:@"Q"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"Q"];
		}
	}
	else if(![name caseInsensitiveCompare:@"R"])
	{	
		if([[checkDict valueForKey:@"R"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"R"];
		}
	}
	else if(![name caseInsensitiveCompare:@"S"])
	{	
		if([[checkDict valueForKey:@"S"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"S"];
		}
	}
	else if(![name caseInsensitiveCompare:@"T"])
	{	
		if([[checkDict valueForKey:@"T"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"T"];
		}
	}
	else if(![name caseInsensitiveCompare:@"U"])
	{	
		if([[checkDict valueForKey:@"U"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"U"];
		}
	}
	else if(![name caseInsensitiveCompare:@"V"])
	{	
		if([[checkDict valueForKey:@"V"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"V"];
		}
	}
	else if(![name caseInsensitiveCompare:@"W"])
	{	
		if([[checkDict valueForKey:@"W"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"W"];
		}
	}
	else if(![name caseInsensitiveCompare:@"X"])
	{	
		if([[checkDict valueForKey:@"X"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"X"];
		}
	}
	else if(![name caseInsensitiveCompare:@"Y"])
	{	
		if([[checkDict valueForKey:@"Y"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"Y"];
		}
	}
	else if(![name caseInsensitiveCompare:@"Z"])
	{	
		if([[checkDict valueForKey:@"Z"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"Z"];
		}
	}	
	else
	{	
		if([[checkDict valueForKey:@"123"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:@"123"]];
			[checkDict setValue:num forKey:@"123"];
		}
	}
	
	
}

// recurrsion
-(int)nextCharacter:(int)index 
{
	if(index<26)
	{
		NSString *nextChar=[tempArray objectAtIndex:index];
		int number=[[checkDict objectForKey:nextChar] intValue];
		if(number!=-1)
			return number;
		
		return -1;
	}
	return -2;
}

@end

