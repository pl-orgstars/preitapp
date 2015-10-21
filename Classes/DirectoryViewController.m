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
#import "LoadingAgent.h"

#define ALLSTORES @"All Stores"


@interface DirectoryViewController ()

@end

@implementation DirectoryViewController
@synthesize listContent,/* searchedListContent, */savedSearchTerm, savedScopeButtonIndex, searchWasActive;


#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    
//    [self makeLoadingView];
    // Do any additional setup after loading the view from its nib.
    
    delegate=(PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
    
    listContent = [[NSMutableArray alloc] init];
    displayContent = [[NSMutableArray alloc] init];

    
    if([delegate.storeListContent count]>0){
        [listContent addObjectsFromArray:delegate.storeListContent];
        [displayContent removeAllObjects];
        [displayContent addObjectsFromArray:listContent];
        [tableView_ reloadData];
    }
    
    // create a filtered list that will contain products for the search results table.
//    displayContent = [NSMutableArray arrayWithCapacity:[self.listContent count]];
    
    
    NSString *path = [[[NSBundle mainBundle] bundlePath]stringByAppendingPathComponent:@"checkDict.plist"];
    checkDict = [[NSDictionary dictionaryWithContentsOfFile:path] mutableCopy];
    
    UITextField *textField = [searchBar_ valueForKey:@"_searchField"];
    textField.clearButtonMode = UITextFieldViewModeNever;
    searchBar_.delegate = self;

    
// settings of filter table view
    
    filterTableOnFront = NO;
    
    CGRect frame = filterTableView.frame;
    frame.size.height = 0.0;
    [filterTableView setFrame:frame];
    
//    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
//    [filterTableView addSubview:indicator];
    
//    indicator.center = filterTableView.center;
    
    filterCategories = [[NSMutableArray alloc] init];
    selectedFilter = [[NSMutableArray alloc] init];
    
    [self getShoppingData];
    


    NSLog(@"Directory View, listContent:   %@",listContent);
    if([listContent count]==0)
        [self getData];
    
    
   
    
    


}
-(void)viewWillAppear:(BOOL)animated
{
    [tableView_ reloadData];
    
}

-(void)viewDidUnload{
    displayContent = nil;

    
}

-(void)viewWillLayoutSubviews
{
    if ([tableView_ respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView_ setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView_ respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView_ setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([filterTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        UIEdgeInsets insets = filterTableView.separatorInset;
                insets.right = insets.left;
        [filterTableView setSeparatorInset:insets];
    }
    
    if ([filterTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        UIEdgeInsets insets = filterTableView.layoutMargins;
        insets.right = insets.left;
        [filterTableView setLayoutMargins:insets];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - navigation
- (IBAction)menuBtnCall:(id)sender {
    
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;

}

- (IBAction)backBtnCall:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark - Table Views




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 201) {
        return displayContent.count;

    }
    
    return filterCategories.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 201) {
        DirectoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"directoryCell"];
        
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"DirectoryTableViewCell" owner:self options:nil].firstObject;
        }
        
        NSDictionary *tmpDict;

        
        tmpDict = [displayContent objectAtIndex:indexPath.row];
        
        cell.titleLabel.text = tmpDict[@"tenant"][@"name"];
        
        cell.phoneBtn.tag = indexPath.row;
        [cell.phoneBtn addTarget:self action:@selector(cellPhoneAction:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.mapButton.tag = indexPath.row;
        [cell.mapButton addTarget:self action:@selector(cellMapAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    }
    
    else{
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"filterCell"];
        
        if (!cell) {
            cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"filterCell"];
        }
        
        cell.backgroundColor = [UIColor darkGrayColor];
        
        if (indexPath.row == 0) {
            cell.textLabel.text = [filterCategories objectAtIndex:0];
        }
        else{
            NSDictionary* tenantCategory = [[filterCategories objectAtIndex:indexPath.row] objectForKey:@"tenant_category"];
            cell.textLabel.text = [tenantCategory objectForKey:@"name"];
        }
        
        cell.textLabel.textColor = [UIColor whiteColor];
        
        return cell;
        
    }
    
  
    return [[UITableViewCell alloc] init];
  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (isNoData) {
        
    }
    
    else
    {
        if (tableView.tag == 201) {
            NSDictionary* tempDic = [displayContent objectAtIndex:indexPath.row];
            StoreDetailsViewController *screenStoreDetail=[[StoreDetailsViewController alloc]initWithNibName:@"CustomStoreDetailViewController" bundle:nil];
            screenStoreDetail.dictData=tempDic[@"tenant"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                screenStoreDetail.titleLabel.text = @"STORES";
            });
            
            
            [self.navigationController pushViewController:screenStoreDetail animated:YES];
        }
        else{
            
            [self applyFilterAtPosition:indexPath.row];
        }
   

    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == 201) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    
    else{
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            
            UIEdgeInsets inset = cell.separatorInset;
            inset.right = inset.left;
            [cell setSeparatorInset:inset];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            
            UIEdgeInsets inset = cell.layoutMargins;
            inset.right = inset.left;
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
    }
  
}

#pragma mark - Filter Funcs

-(void)applyFilterAtPosition:(NSInteger)position
{
    if (position==0) {
        
        [displayContent removeAllObjects];
        [displayContent addObjectsFromArray:listContent];
        [self toggleFilterTableView:toggleFilterBtn];
        filterON = NO;
        
        filterByLabel.text = ALLSTORES;
        
        
        
    }else{
        filterON = YES;
        
        [selectedFilter removeAllObjects];
        NSDictionary* tmpDic = [filterCategories objectAtIndex:position];
        
        filterByLabel.text = tmpDic[@"tenant_category"][@"name"];
        
        NSMutableArray* categoryArray = [[NSMutableArray alloc] initWithArray:tmpDic[@"tenant_category"][@"tenants"]];
        
        for (NSDictionary* tenantDic in categoryArray) {
            [selectedFilter addObject:[[NSDictionary alloc] initWithObjectsAndKeys:tenantDic,@"tenant", nil]];
        }
        
        [displayContent removeAllObjects];
        [displayContent addObjectsFromArray:selectedFilter];
    
        [self toggleFilterTableView:toggleFilterBtn];
        
    }
    
    [tableView_ reloadData];

}


- (IBAction)toggleFilterTableView:(UIButton*)sender {
    
    sender.enabled = NO;
    
    if (filterTableOnFront) {
        filterTableView.userInteractionEnabled = NO;
        tableView_.hidden = NO;
        CGRect frame = filterTableView.frame;
        frame.size.height = 0.0;
        
        filterTableOnFront = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [sender setImage:[UIImage imageNamed:@"exoandArrowDown50"]  forState:UIControlStateNormal];
            [sender setImage:[UIImage imageNamed:@"exoandArrowDown50"] forState:UIControlStateDisabled];
            
            
            
        });
        
        
        [UIView animateWithDuration:0.5 animations:^{
            
            filterTableView.frame = frame;
            
        } completion:^(BOOL finished) {
            filterTableView.hidden = YES;
            tableView_.userInteractionEnabled = YES;
            
            sender.enabled = YES;
            
        }];
        
        
    }
    else{
        
        filterTableOnFront = YES;
        filterTableView.hidden = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [sender setImage:[UIImage imageNamed:@"collapseArrow"]  forState:UIControlStateNormal];
            [sender setImage:[UIImage imageNamed:@"collapseArrow"] forState:UIControlStateDisabled];


        });
        
        [UIView animateWithDuration:1.0 animations:^{
        
            filterTableView.frame = tableView_.frame;
            filterTableView.userInteractionEnabled = YES;
            
        } completion:^(BOOL finished) {
            tableView_.hidden = YES;
            tableView_.userInteractionEnabled = NO;
            
            sender.enabled = YES;
            
            
        }];
    }
}





#pragma mark - search bar methods


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
    
    [displayContent removeAllObjects]; // First clear the filtered array.
    
    /*
     Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
     */
    
    if (filterON) {
        for (NSDictionary *dict in selectedFilter)
        {
            NSDictionary *tmpDict=[dict objectForKey:@"tenant"];
            NSString *sTemp=[tmpDict objectForKey:@"name"];
            
            NSComparisonResult result = [sTemp compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            
            if (result == NSOrderedSame)
            {
                [displayContent addObject:dict];
            }
        }
    }
    else {
        for (NSDictionary *dict in listContent)
        {
            NSDictionary *tmpDict=[dict objectForKey:@"tenant"];
            NSString *sTemp=[tmpDict objectForKey:@"name"];
            
            NSComparisonResult result = [sTemp compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            
            if (result == NSOrderedSame)
            {
                [displayContent addObject:dict];
            }
        }
    }
    
    [tableView_ reloadData];
}



#pragma mark - set data

-(void)getData{
    isNoData=NO;
//    NSString *url=[NSString stringWithFormat:@"%@%@",[delegate.mallData objectForKey:@"resource_url"],NSLocalizedString(@"API1.2","")];
    
    NSString* url = [NSString stringWithFormat:@"%@/tenant_categories/all_tenants_detail",[delegate.mallData objectForKey:@"resource_url"]];
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
            [displayContent addObjectsFromArray:listContent];
            
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
    
//    [indicator stopAnimating];
    [[LoadingAgent defaultAgent]makeBusy:NO];
}

#pragma mark - loading

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
    loadingView.backgroundColor=[UIColor clearColor];
    
    frame=CGRectMake(32.0,20.0, 159.0,60.0);
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:frame];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.font=[UIFont boldSystemFontOfSize:18];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.text = @"LOADING";
    loadingLabel.numberOfLines=0;
    [loadingView addSubview:loadingLabel];
    [loadingView addSubview:wait];
    
    frame=CGRectMake(86.0, 77.0, 37.0,37.0);
    wait.frame=frame;
    
//    CALayer *l=[loadingView layer];
//    [l setCornerRadius:10.0];
//    [l setBorderWidth:3.0];
//    [l setBorderColor:[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]CGColor]];
    
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
    NSDictionary *tempDict = displayContent[sender.tag];
    
    NSString* phoneNumber = tempDict[@"tenant"][@"telephone"];
    phoneNumber = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    NSString *url = [NSString stringWithFormat:@"tel:%@", phoneNumber];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    else {
        NSLog(@"Error Calling");
    }
}

- (IBAction)cellMapAction:(UIButton *)sender {
    
    
    NSDictionary *dictData = [displayContent objectAtIndex:sender.tag];
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


#pragma mark - Data and API for Filter categories


-(void)getShoppingData
{
    NSLog(@"Get data");
    
    NSString *apiString=[NSString stringWithFormat:@"API%d",1];
    NSString *url=[NSString stringWithFormat:@"%@%@",[delegate.mallData objectForKey:@"resource_url"],NSLocalizedString(apiString,"")];
    
    RequestAgent *req=[[RequestAgent alloc] init];// autorelease];
    [req requestToServer:self callBackSelector:@selector(responseDataFilter:) errorSelector:@selector(errorCallback:) Url:url];
//    [indicator startAnimating];
    [[LoadingAgent defaultAgent]makeBusy:YES];
//    [self makeLoadingView];
  
}


-(void)responseDataFilter:(NSData*)receivedData
{
    
//    [indicator stopAnimating];
    [[LoadingAgent defaultAgent]makeBusy:NO];
    
    if (receivedData != nil) {
        NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];
        
        NSArray* tmpArray = [jsonString JSONValue];
        
        NSLog(@"%@",tmpArray);
        
        [filterCategories removeAllObjects];
        [filterCategories addObjectsFromArray:tmpArray];
        [filterCategories insertObject:@"All Stores" atIndex:0];
        
        
        [filterTableView reloadData];
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
