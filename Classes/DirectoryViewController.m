//
//  DirectoryViewController.m
//  Preit
//
//  Created by Noman iqbal on 9/23/15.
//
//

#import "DirectoryViewController.h"
#import "JSBridgeViewController.h"
#import "JSON.h"

@interface DirectoryViewController ()

@end

@implementation DirectoryViewController
@synthesize listContent, filteredListContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive;


#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    
    [self makeLoadingView];
    // Do any additional setup after loading the view from its nib.
    
    delegate=(PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
    
//    for (UIView* subview in searchBar_.subviews) {
//        if ([subview isKindOfClass:[UIButton class]]) {
//            UIButton* cancel = (UIButton*)subview;
//            [cancel setTitle:@"" forState:UIControlStateNormal];
//            [cancel setImage:[UIImage imageNamed:@"searchfield-icon-clear"] forState:UIControlStateNormal];
//        }
//    }
    
    
    listContent = [[NSMutableArray alloc] init];
    
    if([delegate.storeListContent count]>0)
        [listContent addObjectsFromArray:delegate.storeListContent];
    
    // create a filtered list that will contain products for the search results table.
    self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.listContent count]];
    
    
    NSString *path = [[[NSBundle mainBundle] bundlePath]stringByAppendingPathComponent:@"checkDict.plist"];
    checkDict = [[NSDictionary dictionaryWithContentsOfFile:path] mutableCopy];
    
    
/*    indexArray = [[NSMutableArray alloc] init];
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
 
 */

    NSLog(@"Directory View, listContent:   %@",listContent);
    if([listContent count]==0)
        [self getData];
    
    
    searchBar_.delegate = self;


}

-(void)viewDidUnload{
    self.filteredListContent = nil;

    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - navigation
- (IBAction)menuBtnCall:(id)sender {
    
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;

}

#pragma mark - Table Views




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
     If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
     */
    
//    if (tableView == self.searchDisplayController.searchResultsTableView)
//    {
//        return [self.filteredListContent count];
//    }
//    else
//    {
//        if([self.listContent count] && [self.listContent count]>section)
//        {
//            NSArray *tmpArray=[self.listContent objectAtIndex:section];
//            if(tmpArray)
//                return [tmpArray count];
//            
//        }
//        else if(isNoData) return 1;
//        
//        return 0;
//    }
    
    
    if (searchBar_.isFirstResponder) {
        return filteredListContent.count;
    }
    
    return listContent.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DirectoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"directoryCell"];
    
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"DirectoryTableViewCell" owner:self options:nil].firstObject;
    }
    
    NSDictionary *tmpDict;
    
    if (searchBar_.isFirstResponder) {
        tmpDict=[filteredListContent objectAtIndex:indexPath.row];
    }
    else{
        tmpDict=[listContent objectAtIndex:indexPath.row];
    }
    
    
    cell.titleLabel.text = tmpDict[@"tenant"][@"name"];
    
    cell.phoneBtn.tag = indexPath.row;
    [cell.phoneBtn addTarget:self action:@selector(cellPhoneAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.mapButton.tag = indexPath.row;
    [cell.mapButton addTarget:self action:@selector(cellMapAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (isNoData) {
        
    }
    
    else
    {
        
        NSDictionary* tempDic = [listContent objectAtIndex:indexPath.row];
         StoreDetailsViewController *screenStoreDetail=[[StoreDetailsViewController alloc]initWithNibName:@"CustomStoreDetailViewController" bundle:nil];
        screenStoreDetail.dictData=tempDic[@"tenant"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            screenStoreDetail.titleLabel.text = @"STORES";
        });
        
        
        [self.navigationController pushViewController:screenStoreDetail animated:YES];

    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    
   

}



#pragma mark - search bar methods

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
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
    
    [self.filteredListContent removeAllObjects]; // First clear the filtered array.
    
    /*
     Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
     */
    for (NSDictionary *dict in listContent)
    {
//        for (NSDictionary *dict in array)
//        {
            NSDictionary *tmpDict=[dict objectForKey:@"tenant"];
            NSString *sTemp=[tmpDict objectForKey:@"name"];
            
            NSComparisonResult result = [sTemp compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            
            if (result == NSOrderedSame)
            {
                [self.filteredListContent addObject:dict];
            }
//        }
    }
    
    [tableView_ reloadData];
}



#pragma mark - set data

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
            
            [listContent addObjectsFromArray:tmpArray];
            
            
            
//            for(int i=0;i<[tmpArray count];i++)
//            {
//                NSDictionary *tmpDict=[[tmpArray objectAtIndex:i]objectForKey:@"tenant"];
//                [self checkIndex:[tmpDict objectForKey:@"name"] forindex:i];
//            }
            
/*            for(int i=0;i<[indexArray count];i++)
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
            }*/
            
            
            delegate.storeListContent=listContent;
        }
        else{
            isNoData=YES;
        }
    }
    else
        isNoData=YES;
    
    [tableView_ reloadData];
}

-(void)errorCallback:(NSError *)error{
    [self loadingView:NO];
    [delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Message" buttontitle:@"Ok"];
}

#pragma mark - loading

-(void)makeLoadingView
{
    UIWindow* keywindow = [[UIApplication sharedApplication] keyWindow];
    CGRect keyFrame=[keywindow frame];
    CGRect frame=CGRectMake(keyFrame.origin.x, keyFrame.origin.y, keyFrame.size.width, keyFrame.size.height);
    
    main_view = [[UIView alloc] initWithFrame:frame];
    main_view.backgroundColor = [UIColor lightGrayColor];
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
    loadingLabel.textAlignment = NSTextAlignmentCenter;
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
        
        [self.view addSubview:main_view];
        [self.view bringSubviewToFront:main_view];
//        [[[UIApplication sharedApplication] keyWindow] addSubview:main_view];
//        [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:main_view];
    }else
        [main_view removeFromSuperview];
}

#pragma mark - Cell Button Actions

- (IBAction)cellPhoneAction:(UIButton *)sender {
    NSDictionary *tempDict = listContent[sender.tag];
    NSString *url = [NSString stringWithFormat:@"tel:%@", tempDict[@"tenant"][@"telephone"]];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    else {
        NSLog(@"Error Calling");
    }
}

- (IBAction)cellMapAction:(UIButton *)sender {
    
    
    NSDictionary *dictData = [listContent objectAtIndex:sender.tag];
    NSLog(@"Map==%@",dictData);
    NSDictionary *suite=[[dictData objectForKey:@"tenant"] objectForKey:@"suite"];
    int suiteID=[[suite objectForKey:@"id"] intValue];
    if(suiteID>0)
    {
        JSBridgeViewController *screenMap=[[JSBridgeViewController alloc]initWithNibName:@"JSBridgeViewController" bundle:nil];
       
        screenMap.mapUrl=[NSString stringWithFormat:@"%@/areas/getarea?suit_id=%d",[delegate.mallData objectForKey:@"resource_url"],suiteID];
        [self.navigationController pushViewController:screenMap animated:YES];
        //				[screenMap release];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
