//
//  ProductListViewController.m
//  Preit
//
//  Created by sameer on 29/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProductListViewController.h"

#define MAXROWS 30
#define REMOVEROWS 30

#define pickerCheckTag 100
#define pickerTextTag 200

@implementation ProductListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated {
//    [self.navigationItem setTitle:@"Product Search"];
    
    [self setNavigationTitle:@"Product Search" withBackButton:YES];
    
    [delegate hideProductScreen:YES];
//    [delegate.mHomeViewController.view removeFromSuperview];
    
    [listCountLabel setText:[NSString stringWithFormat:@"%d",[[Database sharedDatabase] getCount]]];
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    ///kk
    [self addMaxMinTextField];
    
    delegate = (PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    UIView *barV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [barV setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *barImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"date"]];
    CGRect frame = barV.frame;
    frame.origin = CGPointZero;
    [barImageView setFrame:frame];
    [barV addSubview:barImageView];
    listCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(5.5, 0, 20, 20)];
    [listCountLabel setBackgroundColor:[UIColor clearColor]];
    [listCountLabel setTextColor:[UIColor whiteColor]];
    [listCountLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [listCountLabel setTextAlignment:UITextAlignmentCenter];
//        [listCountLabel sizeToFit];
    [barV addSubview:listCountLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(showShoppingList:)];
    [barV addGestureRecognizer:tap];
//    [tap release];
    
    UIBarButtonItem *shoppingListView = [[UIBarButtonItem alloc]initWithCustomView:barV];
    [self.navigationItem setRightBarButtonItem:shoppingListView];
//    [shoppingListView release];
//    [barV release];
    
    
    [lblFind setText:[NSString stringWithFormat:@"Find what you are looking for at %@ from participating retailers",(NSString*)[delegate.mallData objectForKey:@"name"]]];
    
    
    sortArray = [[NSArray alloc]initWithObjects:@"Sort: Relevance",@"Price: Low-High",@"Price: High-Low", nil];
    
    frame = self.view.frame;
    frame.origin.y = 69;
    //kk

    if (is_iOS7) {
        frame.size.height -= 20;
    }
        
    if(isIPhone5){frame.size.height -= 81;}else{frame.size.height -= 155;}
    [overView setBackgroundColor:[UIColor clearColor]];
    productListView = [[ProductListView alloc]initWithFrame:frame];
    productListView.loadMoreDelegate = self;
    productListView.loadMoreSelector = @selector(loadMore);
    productListView.loadPreviousSelector = @selector(loadPrevious);
    
    productListView.showProductDetailDelegate = self;
    productListView.showProductDetailSelector = @selector(showProductDetail:);
    
    [self.view insertSubview:productListView belowSubview:pickerSort];
    [productListView setHidden:YES];
//    [productListView release];
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setHidesWhenStopped:YES];
    [spinner setCenter:self.view.center];
    [self.view addSubview:spinner];
    [spinner stopAnimating];
    sortString = @"Sort: Relevance";
    [pickerSort selectRow:0 inComponent:0 animated:NO];
    [productSearchBar becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
    
    page = 1;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//-(void)dealloc {
//    [super dealloc];
//    [mainArray release];
//    [sortArray release];
//    [sortString release];
//    [urlString release];
//    
//    [tabNavigation release];
////    [searchString release];
//}


#pragma mark - search bar delegate

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"textchange %lu",(unsigned long)searchText.length);
    if (searchBar.text.length == 0 && !spinner.isAnimating) {
//        [productListView.productListTable setContentOffset:CGPointZero];
        [productListView.productsArray removeAllObjects];
        [barView setHidden:YES];
        [productListView setHidden:YES];
        [overView setHidden:NO];
        [self hidePicker];
        
        [searchBar setShowsCancelButton:NO];
    }
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if (![productListView isHidden]) {
        [searchBar setShowsCancelButton:YES];
    }
    [self hidePicker];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    NSLog(@"search %@",searchBar.text);
    [searchBar resignFirstResponder];
    [overView setHidden:YES];
    [minmumPriceLabel setText:@""];
    [maximunPriceLabel setText:@""];
    
//    searchString = searchBar.text;
    NSLog(@"searchstsring %@",searchBar.text);
    [self makeRequestForString:searchBar.text];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    searchString = [[NSString alloc]initWithFormat:@"%@",searchBar.text];
    if (![productListView isHidden]) {
        [searchBar resignFirstResponder];
    }
    NSLog(@"searchBarCancelButtonClicked::: %@",searchBar.text);
}

#pragma mark make request 
///kuldeep new api
-(void)showStoreDetails{


    //
    NSString *str = NSLocalizedString(@"PRODUCT_SEARCH_IDS","");
    NSString *url= [NSString stringWithFormat:@"%@property_id=%ld", str,delegate.mallId];
    
//    NSString *url= [NSString stringWithFormat:@"http://cherryhillmall.com/api/product_search_ids?property_id=%ld",delegate.mallId];
    //    NSString *url= [NSString stringWithFormat:@"http://cherryhillmall.red5demo.com/api/product_search_ids?property_id=%ld",delegate.mallId];
    
    
	RequestAgent *req=[[RequestAgent alloc] init];// autorelease];
	[req requestToServer:self callBackSelector:@selector(responseSuccessForStoreID:) errorSelector:@selector(requestError:) Url:url];
    
    
}
-(void)responseSuccessForStoreID:(NSData *)receivedData
{
    NSLog(@"responseSuccessForTenantID");
    //	[self loadingView:NO];

    NSMutableString *storeId = [NSMutableString new];
	if(receivedData!=nil)
    {
		NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];// autorelease];
		// test string
//        Product *prod = [productsArray objectAtIndex:productIndex];
		//NSLog(@"jsonString===%@",jsonString);
		NSArray *tmpArray=[jsonString JSONValue];
        //        NSLog(@"kkkkkkkkkkkk %@",tmpArray);


        
        BOOL isFirst = NO;
        for (NSDictionary *dict in tmpArray)
        {
            NSDictionary *dict2 = [dict valueForKey:@"tenant_the_find_store"];
            NSLog(@":::: %@",dict2);
            if (isFirst == NO) {
                [storeId appendString:[dict2 valueForKey:@"store_id"]];
                isFirst = YES;
            }else{
                [storeId appendString:@","];
                [storeId appendString:[dict2 valueForKey:@"store_id"]];
            }
    
        }


        NSLog(@"store id string == %@",storeId);
        
    }
    
//    [self makeRequestForStringAndStoreId:storeId];
}



-(void)makeRequestForString:(NSString *)productStr {
    
    [spinner setHidden:NO];
    [spinner startAnimating];
    
    searchString = productStr;//[[NSString alloc]initWithFormat:@"%@",productStr];
//    [self showStoreDetails];
    [self makeRequestForStringAndStoreId];//:nil];
    
}
-(void)makeRequestForStringAndStoreId{//:(NSString*)storeid{
//    page =1;
    
    RequestAgent *req = [[RequestAgent alloc]init];
    //    urlString = [[NSString alloc]initWithFormat:@"%@/%d/search?q=%@",NSLocalizedString(@"SEARCHAPI", @""),delegate.mallId,[productStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //    urlString = [[NSString alloc]initWithFormat:@"%@/%ld?search=%@",NSLocalizedString(@"SEARCHAPI", @""),delegate.mallId,[productStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    urlString = [[NSString alloc]initWithFormat:@"%@%@&property_id=%ld", NSLocalizedString(@"SEARCHAPI", @""), [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],delegate.mallId];
    
    ///change api...search
    
    NSLog(@"store id to get %@",delegate.mallData);

//    urlString = [[NSString alloc]initWithFormat:@"%@%@&stores[]=%@&property_id=%ld", NSLocalizedString(@"SEARCHAPI", @""), [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],storeid,delegate.mallId];
    
    NSLog(@"url new:::::: %@",urlString);
    NSString *url = [NSString stringWithFormat:@"%@&page=%d",urlString,page];
    //    [req requestToServer:self callBackSelector:@selector(requestFinished:) errorSelector:@selector(requestError:) Url:urlString];
    [req requestToServer:self callBackSelector:@selector(requestForSearchFinishedSuccess:) errorSelector:@selector(requestError:) Url:url];
}
/*
-(void)requestFinished:(NSData*)responseData{
    
    NSString *jsonString = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];

    NSDictionary *dict = [jsonString JSONValue];
    
//    NSLog(@"reply ===%@",dict);
    totalCount = [[dict objectForKey:@"totalItems"] longValue];
    [lblResultCount setText:[NSString stringWithFormat:@"%ld results",totalCount]];
    NSArray *array = [dict objectForKey:@"items"];
    NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!%d",array.count);
    NSMutableArray *itemsArray = [[NSMutableArray alloc]initWithCapacity:array.count];
    for (NSDictionary *d in array) {
        Product *prod = [[Product alloc]initWithValues:d];
        [itemsArray addObject:prod];
        [prod release];
    }
    currentCount = itemsArray.count;
    if (currentCount>=totalCount) {
        productListView.hasMoreProducts = NO;
    } else {
        productListView.hasMoreProducts = YES;
    }
    [barView setHidden:NO];
    [lblSort setText:[NSString stringWithFormat:@"Sort: %@",sortString]];
    mainArray = [[NSMutableArray alloc]initWithArray:itemsArray];
    if (productListView.productsArray) {
        [productListView.productsArray release];
    }
    productListView.productsArray = [[NSMutableArray alloc]initWithArray:itemsArray];
    [productListView setHidden:NO];

    [overView setHidden:YES];
    [spinner stopAnimating];
    
    if (itemsArray.count==0) {
        [delegate showAlert:@"No product matching your criteria found" title:@"No result found" buttontitle:@"Dismiss"];
    }
    productListView.totalCount = totalCount;
    productListView.currentCount = currentCount;
    [self sort];

    [itemsArray release];
    
}
 */
-(void)requestForSearchFinishedSuccess:(NSData*)responseData{
    [productListView.productsArray removeAllObjects];
    [mainArray removeAllObjects];
    productListView.hasMoreProducts = NO;
    productListView.hasPreviousProducts = NO;
    //kuldeep edited
    NSString *jsonString = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];//autorelease];
    
    NSDictionary *dict = [jsonString JSONValue];
    
    NSLog(@"reply ===%@",dict);
   // change 22 june
   totalCount = [[dict objectForKey:@"count"] longValue];
  

    NSArray *array = [dict objectForKey:@"results"];
   
    NSMutableArray *itemsArray = [[NSMutableArray alloc]initWithCapacity:array.count];
    
    for (int i=0; i<array.count; i++) {
        Product *prod = [[Product alloc]initWithValues:[[array objectAtIndex:i] objectForKey:@"SearchResult"]];
        [itemsArray addObject:prod];
//        [prod release];
        if (i==29) {
            break;
        }
    }
//    for (NSDictionary *d in array) {
//        Product *prod = [[Product alloc]initWithValues:d];
//        [itemsArray addObject:prod];
//        [prod release];
//    }
    NSLog(@"break at index,,,%d",itemsArray.count);
    currentCount = itemsArray.count;
    
    if (totalCount<10) {
        productListView.hasMoreProducts = NO;
    } else {
        productListView.hasMoreProducts = YES;
    }
    [barView setHidden:NO];
    [lblSort setText:[NSString stringWithFormat:@"Sort: %@",sortString]];
    mainArray = [[NSMutableArray alloc]initWithArray:itemsArray];
    if (productListView.productsArray) {
//        [productListView.productsArray release];
    }
    productListView.productsArray = [[NSMutableArray alloc]initWithArray:itemsArray];
    [productListView setHidden:NO];
    
    [overView setHidden:YES];
    [spinner stopAnimating];
    
    if (itemsArray.count==0) {
        [delegate showAlert:@"No product matching your criteria found" title:@"No result found" buttontitle:@"Dismiss"];
    }
    productListView.totalCount = totalCount;
    productListView.currentCount = currentCount;
//    sortString = @"Price: Low-High";
    [self sort];
    
//    [itemsArray release];
}
/*
-(void)requestForSearchFinished:(NSData*)responseData{
    NSString *jsonString = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];
    
    NSDictionary *dict = [jsonString JSONValue];
    NSLog(@"RESPONSE for search is ===%@",dict);
    
    NSArray *array = [[dict objectForKey:@"item_lists"]objectForKey:@"normal"];
//    NSLog(@"arrar %@ %d",array,array.count);
    

    NSMutableArray *itemsArray = [[NSMutableArray alloc]initWithCapacity:array.count];
    for (NSDictionary *d in array) {
        Product *prod = [[Product alloc]initWithValues:d];
        [prod compareForPrice:prod];
        [itemsArray addObject:prod];
        [prod release];
    }
    [barView setHidden:NO];
//    currentCount = itemsArray.count;
//    if (currentCount>=totalCount) {
//        productListView.hasMoreProducts = NO;
//    } else {
//        productListView.hasMoreProducts = YES;
//    }

    mainArray = [[NSMutableArray alloc]initWithArray:itemsArray];
    if (productListView.productsArray) {
        [productListView.productsArray release];
    }
    productListView.productsArray = [[NSMutableArray alloc]initWithArray:itemsArray];

    [productListView setHidden:NO];
    
    [overView setHidden:YES];
    [spinner stopAnimating];
    

    if (array.count==0) {
        [delegate showAlert:@"No product matching your criteria found" title:@"No result found" buttontitle:@"Dismiss"];
    }else{
        NSLog(@"here");
    }
//    [lblSort setText:[NSString stringWithFormat:@"Sort: %@",sortString]];
    

//    totalCount = [[dict objectForKey:@"totalItems"] longValue];
//    [lblResultCount setText:[NSString stringWithFormat:@"%ld results",totalCount]];

    [overView setHidden:YES];
    [spinner stopAnimating];
    
    if (itemsArray.count==0) {
        [delegate showAlert:@"No product matching your criteria found" title:@"No result found" buttontitle:@"Dismiss"];
    }
    productListView.totalCount = totalCount;
    productListView.currentCount = currentCount;
    [self sort];
    
    [itemsArray release];
//    [lblResultCount setText:[NSString stringWithFormat:@"%ld results",totalCount]];
}
*/
-(void)requestError:(NSError*)error {
    [delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Network error" buttontitle:@"Dismiss"];
    [spinner stopAnimating];
}

#pragma mark - load more

-(void)loadMore {
    
    if (![spinner isAnimating]) {
        [spinner setHidden:NO];
        [spinner startAnimating];
        //kuldeep
        RequestAgent *req = [[RequestAgent alloc]init];//autorelease];
        page = (int)currentCount/10;
        page++;
        NSString *urlStringM = [NSString stringWithFormat:@"%@&page=%d",urlString,page];
        
//        NSString *urlStringM =[[NSString alloc]initWithFormat:@"%@%@%d&property_id=%ld", NSLocalizedString(@"SEARCHAPI", @""), @"handbag&startIndex=",currentCount+30,delegate.mallId];
        
        NSLog(@"loadmoreurl %@",urlStringM);
        [req requestToServer:self callBackSelector:@selector(moreRequestFinished:) errorSelector:@selector(moreRequestFailed:) Url:urlStringM];
    }
}


-(void)moreRequestFinished:(NSData*)responseData {
    [spinner stopAnimating];
    NSString *jsonString = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [jsonString JSONValue];
//    NSLog(@"::::::::dict===%@",dict);
//    NSArray *array = [dict objectForKey:@"items"];
    NSArray *array = [dict objectForKey:@"results"];
    //    NSLog(@"array count::::: %d",array.count);
    NSMutableArray *itemsArray = [[NSMutableArray alloc]initWithCapacity:array.count];
    
    totalCount = [[dict objectForKey:@"count"] longValue];
    
    for (int i=0; i<array.count; i++) {
        Product *prod = [[Product alloc]initWithValues:[[array objectAtIndex:i] objectForKey:@"SearchResult"]];
        [itemsArray addObject:prod];
//        [prod release];
        if (i==29) {
            break;
        }
    }
//    for (NSDictionary *d in array) {
//        Product *prod = [[Product alloc]initWithValues:d];
//        [itemsArray addObject:prod];
//         NSLog(@"2");
//        [prod release];
//    }
    currentCount += itemsArray.count;
    
    NSLog(@"3");
    if (totalCount<10) {
        productListView.hasMoreProducts = NO;
        NSLog(@"x");
    } else {
        productListView.hasMoreProducts = YES;
        NSLog(@"x");
    }
    [mainArray addObjectsFromArray:itemsArray];
    [productListView.productsArray addObjectsFromArray:itemsArray];
//    if (productListView.productsArray.count>MAXROWS) {
//        NSLog(@"z");
//        [productListView.productsArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, REMOVEROWS)]];
//        NSLog(@"z");
//        [mainArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, REMOVEROWS)]];
//        productListView.hasPreviousProducts = YES;
//         NSLog(@"4");
//    }
    NSLog(@"5");
    productListView.currentCount = currentCount; 
    
    
//    [itemsArray release];
    [self sort];
}
/*
-(void)moreRequestSuccesfull:(NSData*)responseData {
    [spinner stopAnimating];
    NSString *jsonString = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [jsonString JSONValue];
    NSLog(@"::::::::dict===%@",dict);
    NSArray *array = [dict objectForKey:@"items"];
    NSMutableArray *itemsArray = [[NSMutableArray alloc]initWithCapacity:array.count];
    for (NSDictionary *d in array) {
        Product *prod = [[Product alloc]initWithValues:d];
        [itemsArray addObject:prod];
        [prod release];
    }
    currentCount += itemsArray.count;
    
    if (currentCount>=totalCount) {
        productListView.hasMoreProducts = NO;
    } else {
        productListView.hasMoreProducts = YES;
    }
    [mainArray addObjectsFromArray:itemsArray];
    [productListView.productsArray addObjectsFromArray:itemsArray];
    if (productListView.productsArray.count>MAXROWS) {
        [productListView.productsArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, REMOVEROWS)]];
        [mainArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, REMOVEROWS)]];
        productListView.hasPreviousProducts = YES;
    }
    
    productListView.currentCount = currentCount;
    
    [itemsArray release];
    [self sort];
}
*/
-(void)moreRequestFailed:(NSError*)error {
    [delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Network error!" buttontitle:@"Dismiss"];
    [spinner stopAnimating];
}


-(void)loadPrevious {
    
    NSLog(@"load previous");
    
    if (![spinner isAnimating]) {
        [spinner setHidden:NO];
        [spinner startAnimating];
        RequestAgent *req = [[RequestAgent alloc]init];
        page = (int)currentCount/30;
        page--;
        NSString *urlStringM = [NSString stringWithFormat:@"%@&page=%d",urlString,page];//currentCount-mainArray.count-REMOVEROWS+1];
        NSLog(@"loadprevurl %@",urlStringM);
        [req requestToServer:self callBackSelector:@selector(prevRequestFinished:) errorSelector:@selector(prevRequestFailed:) Url:urlStringM];
    }
}

-(void)prevRequestFailed:(NSError *)error {

    [delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Network error!" buttontitle:@"Dismiss"];
    [spinner stopAnimating];

}

-(void)prevRequestFinished:(NSData *)responseData {
    
    [spinner stopAnimating];
    NSString *jsonString = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [jsonString JSONValue];
    //    NSLog(@"dict===%@",dict);
//    NSArray *array = [dict objectForKey:@"items"];
    NSArray *array = [[dict objectForKey:@"item_lists"]objectForKey:@"normal"];
    NSMutableArray *itemsArray = [[NSMutableArray alloc]initWithCapacity:array.count];
    
    
    for (int i=0; i<array.count; i++) {
        Product *prod = [[Product alloc]initWithValues:[array objectAtIndex:i]];
        [itemsArray addObject:prod];
//        [prod release];
        if (i==29) {
            break;
        }
    }
//    for (NSDictionary *d in array) {
//        Product *prod = [[Product alloc]initWithValues:d];
//        [itemsArray addObject:prod];
//        [prod release];
//    }
    
    currentCount -= itemsArray.count;
    
    int mod = currentCount % MAXROWS;
    
    if (mod>0) {
        int diff = MAXROWS - mod;
        currentCount += diff;
    }
    
    productListView.hasMoreProducts = YES;
    
    if (currentCount<=MAXROWS) {
        productListView.hasPreviousProducts = NO;
    } else {
        productListView.hasPreviousProducts = YES;
    }
    productListView.currentCount = currentCount;
    [mainArray insertObjects:itemsArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, itemsArray.count)]];
    [productListView.productsArray insertObjects:itemsArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, itemsArray.count)]];
    
    [mainArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(MAXROWS,mainArray.count-MAXROWS)]];
    [productListView.productsArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(MAXROWS, productListView.productsArray.count - MAXROWS)]];
    
//    [itemsArray release];
    [self sort];
}

#pragma mark - show detail

-(void)showProductDetail:(NSNumber *)productIndex {
    if (!spinner.isAnimating) {
        NSLog(@"show product detail");
        ProductDetailViewController *detailView = [[ProductDetailViewController alloc]initWithNibName:@"ProductDetailViewController" bundle:nil];
        [self.navigationItem setTitle:@"Back"];
        //    NSLog(@"prodarr %@",productListView.productsArray);
        detailView.productsArray = [[NSMutableArray alloc]initWithArray:productListView.productsArray];
        detailView.productIndex = productIndex.intValue;
        
        delegate.searchURL = urlString;

        [self.navigationController pushViewController:detailView animated:YES];
//        [detailView release];
        [self hidePicker];
    }
}

-(IBAction)showShoppingList:(id)sender {
    NSLog(@"show shopping list");
    
    if ([[Database sharedDatabase]getCount]) {
        
    
    ShoppingListViewController *shoppingList = [[ShoppingListViewController alloc]initWithNibName:@"ShoppingListViewController" bundle:nil];
    [self.navigationController pushViewController:shoppingList animated:YES];
    [self.navigationItem setTitle:@"Back"];
    }
}


#pragma mark - sortbtn

-(IBAction)showSortPicker:(UIButton*)sender {
    [productSearchBar resignFirstResponder];
    [delegate hideTabBar:NO];
    [pickerSort setHidden:NO];
    [pickerToolBar setHidden:NO];
    [pickerDone setHidden:NO];
}

-(void)sort {
    [lblSort setText:[NSString stringWithFormat:@"%@",sortString]];
    if ([sortString isEqualToString:@"Price: Low-High"]) {
        [productListView.productsArray sortUsingSelector:@selector(compareForPrice:)];

    } else if ([sortString isEqualToString:@"Price: High-Low"]) {
        [productListView.productsArray sortUsingSelector:@selector(compareForPriceDesc:)];        
    } else {
        [productListView.productsArray removeAllObjects];
        [productListView.productsArray addObjectsFromArray:mainArray];
    }
    [productListView.productListTable reloadData];
    
    [lblResultCount setText:[NSString stringWithFormat:@"%ld results",productListView.productsArray.count]];

//    [productListView.productListTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
//    [self setTheValueOfMaxAndMin];
}

#pragma mark - pickerdelegate

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    switch (row) {
//        case 0:
//            return @"Sort: Relevance";
//            break;
//        case 1:    
//            return @"Price: Low-High";
//            break;
//        case 2:
//            return @"Price: High-Low";
//            break;
//    }
//    return nil;
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [pickerView reloadComponent:component];
    sortString = [sortArray objectAtIndex:row];
}

-(IBAction)pickerDone:(id)sender {
    [self sort];
    [self hidePicker];
}

-(void)hidePicker {
    [delegate showTabBar:NO];
    [pickerSort setHidden:YES];
    [pickerToolBar setHidden:YES];
    [pickerDone setHidden:YES];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UIView *pView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, pickerView.frame.size.width, 40)] ;//autorelease];
    UIButton *check = [UIButton buttonWithType:UIButtonTypeCustom];
//    [check setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    UIImage *checkImage = [UIImage imageNamed:@"check.png"];
    [check setImage:checkImage forState:UIControlStateNormal];
    [check setTag:pickerCheckTag];
    [check setHidden:YES];
    CGRect frame = check.frame;
    frame.origin.x = 35;
    frame.origin.y = 7;
    frame.size = checkImage.size;
    [check setFrame:frame];
    [pView addSubview:check];
    UILabel *pLabel = [[UILabel alloc]initWithFrame:CGRectMake(check.frame.origin.x + 30, 0, 200, check.frame.size.height + 20)];
    [pLabel setTag:pickerTextTag];
    [pLabel setFont:[UIFont boldSystemFontOfSize:22]];
    [pLabel setBackgroundColor:[UIColor clearColor]];
    
    if (row==[pickerView selectedRowInComponent:0]) {
        [pLabel setTextColor:[UIColor colorWithRed:.20 green:.29 blue:.45 alpha:1]];
        [check setHidden:NO];
    }
    
    [pView addSubview:pLabel];
    [pLabel setText:[sortArray objectAtIndex:row]];
//    [pLabel release];
    UITapGestureRecognizer *pickerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickerViewTapped:)];
    [pView addGestureRecognizer:pickerTap];
//    [pickerTap release];
    [pView setTag:row];
    return pView;
}

-(void)pickerViewTapped:(UITapGestureRecognizer*)tap {
    
    int row = [[tap view]tag];
    for (int i = 0; i<3; i++) {
        UIView *view = [pickerSort viewForRow:i forComponent:0];
        UILabel *label = (UILabel*)[view viewWithTag:pickerTextTag];
        UIButton *check = (UIButton*)[view viewWithTag:pickerCheckTag];
        if (i==row) {
            [label setTextColor:[UIColor colorWithRed:.20 green:.29 blue:.45 alpha:1]];
            [check setHidden:NO];
        } else {
            [label setTextColor:[UIColor blackColor]];
            [check setHidden:YES];
        }
    }
        
    sortString = [sortArray objectAtIndex:[[tap view]tag]];
}

#pragma mark - pickerdatasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}
#pragma mark - keyboardButton
-(void)cancelNumberPad:(id)sender{
    
}
-(void)doneWithNumberPad:(id)sender{

}

#pragma mark - maxMinValueSet

-(void)getDataAccordingToMaxMin{
    NSLog(@"search string=== %@",productSearchBar.text);
    
    NSString *str;
    
    if (!minmumPriceLabel.text.length) {
    
        str = [NSString stringWithFormat:@"%@&price_low=%@&price_high=%.2f",productSearchBar.text,minmumPriceLabel.text,maximunPriceLabel.text.floatValue];
        
    }else if(!maximunPriceLabel.text.length){
        
        str = [NSString stringWithFormat:@"%@&price_low=%.2f&price_high=%@",productSearchBar.text,minmumPriceLabel.text.floatValue,maximunPriceLabel.text];
        
    }else if(!minmumPriceLabel.text.length && !maximunPriceLabel.text.length){
     
        str = [NSString stringWithFormat:@"%@&price_low=%@&price_high=%@",productSearchBar.text,minmumPriceLabel.text,maximunPriceLabel.text];
        
    }else{
        
        str = [NSString stringWithFormat:@"%@&price_low=%.2f&price_high=%.2f",productSearchBar.text,minmumPriceLabel.text.floatValue,maximunPriceLabel.text.floatValue];
        
    }
//
    
    
    [self makeRequestForString:str];
}
-(void)setTheValueOfMaxAndMin{
    float min= 0,max = 0;
    if(productListView.productsArray.count){
//        NSLog(@"product array::: %@",productListView.productsArray);
        Product *prod = [productListView.productsArray objectAtIndex:0];
         min = prod.price;
        max = prod.price;
//        [prod release];
        for (Product *d in productListView.productsArray) {
            if (d.price>max) {
                max = d.price;
            }
            if (d.price<min) {
            
                min = d.price;
            }
//            [d release];

        }
        
    }
    maximunPriceLabel.text = [NSString stringWithFormat:@"%.2f",max];
    minmumPriceLabel.text = [NSString stringWithFormat:@"%.2f",min];
    

}



-(void)addMaxMinTextField{
    [pickerBttn setHidden:YES];
    [lblSort setHidden:YES];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"box2.png"]];
    imgView.frame = CGRectMake(179, 3, 58, 22);
    [barView addSubview:imgView];
    imgView = nil;
    imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"box2.png"]];
    imgView.frame = CGRectMake(251, 3, 58, 22);
    [barView addSubview:imgView];
//    [imgView release];
//    imgView.frame = CGRectMake(182, 3, 55, 24);
    
    minmumPriceLabel = [[UITextField alloc]initWithFrame:CGRectMake(191, 7, 43, 16)];
    [minmumPriceLabel setBackgroundColor:[UIColor clearColor]];
    [minmumPriceLabel setTextColor:[UIColor whiteColor]];
    [minmumPriceLabel setFont:[UIFont systemFontOfSize:11]];
    [minmumPriceLabel setTextAlignment:UITextAlignmentLeft];
    
    maximunPriceLabel = [[UITextField alloc]initWithFrame:CGRectMake(262, 7, 43, 16)];
    [maximunPriceLabel setBackgroundColor:[UIColor clearColor]];
    [maximunPriceLabel setTextColor:[UIColor whiteColor]];
    [maximunPriceLabel setFont:[UIFont systemFontOfSize:11]];
    [maximunPriceLabel setTextAlignment:UITextAlignmentLeft];
    
    UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(181, 7, 10, 16)];
    [lbl1 setBackgroundColor:[UIColor clearColor]];
    [lbl1 setTextColor:[UIColor whiteColor]];
    [lbl1 setFont:[UIFont systemFontOfSize:11]];
    [lbl1 setTextAlignment:UITextAlignmentRight];
    [lbl1 setText:@"$"];
    
    UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(252, 7, 10, 16)];
    [lbl2 setBackgroundColor:[UIColor clearColor]];
    [lbl2 setTextColor:[UIColor whiteColor]];
    [lbl2 setFont:[UIFont systemFontOfSize:11]];
    [lbl2 setTextAlignment:UITextAlignmentRight];
    [lbl2 setText:@"$"];
    
    UILabel *lbl3 = [[UILabel alloc]initWithFrame:CGRectMake(238, 5, 12, 20)];
    [lbl3 setBackgroundColor:[UIColor clearColor]];
    [lbl3 setTextColor:[UIColor whiteColor]];
    [lbl3 setFont:[UIFont systemFontOfSize:11]];
    [lbl3 setTextAlignment:UITextAlignmentCenter];
    [lbl3 setText:@"to"];
    
    [maximunPriceLabel setKeyboardType:UIKeyboardTypeDecimalPad];
    [minmumPriceLabel setKeyboardType:UIKeyboardTypeDecimalPad];
    [maximunPriceLabel setDelegate:self];
    [minmumPriceLabel setDelegate:self];
    [barView addSubview:lbl3];
    [barView addSubview:lbl1];
    [barView addSubview:lbl2];
    [barView addSubview:maximunPriceLabel];
    [barView addSubview:minmumPriceLabel];
    
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    
    NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
    

    tabNavigation = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Previous", @"Next", nil]];
    tabNavigation.segmentedControlStyle = UISegmentedControlStyleBar;
    [tabNavigation setEnabled:YES forSegmentAtIndex:0];
    [tabNavigation setEnabled:YES forSegmentAtIndex:1];
    tabNavigation.momentary = YES;
    [tabNavigation addTarget:self action:@selector(segmentedControlHandler:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *barSegment = [[UIBarButtonItem alloc] initWithCustomView:tabNavigation];
    
    [itemsArray addObject:barSegment];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [itemsArray addObject:flexButton];
    
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(userClickedDone:)];
    [itemsArray addObject:doneButton];
    
    toolbar.items = itemsArray;
    
    
    minmumPriceLabel.inputAccessoryView = maximunPriceLabel.inputAccessoryView = toolbar;
    
    
//    [itemsArray release];
//    [toolbar release];
//    [doneButton release];
//    [barSegment release];
//    [flexButton release];
//    [tabNavigation release];
//    [lbl1 release];
//    [lbl2 release];
//    [lbl3 release];
    //[custum getToolbarWithDone];
    //    custum.currentSelectedTextboxIndex = text.tag;
    
}
- (void)segmentedControlHandler:(id)sender
{

    
   currentSelectedTextboxIndex = [(UISegmentedControl *)sender selectedSegmentIndex];

    if (currentSelectedTextboxIndex == 0 && page == 1) {
        return;
    }
    
    NSLog(@"segment selected => %d",currentSelectedTextboxIndex);
    if (currentSelectedTextboxIndex == 0 ) {
        maximunPriceLabel.userInteractionEnabled = NO;
        minmumPriceLabel.userInteractionEnabled = YES;
        [minmumPriceLabel becomeFirstResponder];
        page = page - 1;
    }else{
        maximunPriceLabel.userInteractionEnabled = YES;
        minmumPriceLabel.userInteractionEnabled = NO;
        [maximunPriceLabel becomeFirstResponder];
        page = page +1;
    }
}
- (void)userClickedDone:(id)sender {
    
    if (!maximunPriceLabel.text.length || minmumPriceLabel.text.floatValue<=maximunPriceLabel.text.floatValue) {
        
        [self getDataAccordingToMaxMin];
        
    }else{
        
        [Utils showAlertMesage:@"Minimum amount should be less than Maximum amount"];
        
    }
    
    maximunPriceLabel.userInteractionEnabled = YES;
    minmumPriceLabel.userInteractionEnabled = YES;
    [maximunPriceLabel resignFirstResponder];
    [minmumPriceLabel resignFirstResponder];

}

#pragma mark - textFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == minmumPriceLabel && totalCount == 10) {
//        minmumPriceLabel.userInteractionEnabled = NO;
        [tabNavigation setEnabled:NO forSegmentAtIndex:0];
        [tabNavigation setEnabled:YES forSegmentAtIndex:1];
    }else{
//        maximunPriceLabel.userInteractionEnabled = NO;
        [tabNavigation setEnabled:YES forSegmentAtIndex:0];
        [tabNavigation setEnabled:NO forSegmentAtIndex:1];
        
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == maximunPriceLabel || textField == minmumPriceLabel ) {
        NSLog(@"asdhks %@,%@",textField.text,string);
        if (string.length>0) {
            
            
            
            
            if ([string characterAtIndex:0]>='0' && [string characterAtIndex:0]<='9' &&[textField.text integerValue]<10000) {
                
                if (textField.text.floatValue == 0 && ![textField.text hasPrefix:@"."] && ![textField.text hasPrefix:@"0."]&& ![textField.text hasPrefix:@".0"])  {
                    textField.text = @"";
                    
                }
                
                NSArray *arr = [textField.text componentsSeparatedByString:@"."];
                if (arr.count==1) {
                    return YES;
                }else{
                    NSString *str = [arr objectAtIndex:1];
                    if (str.length == 2 ) {
                        NSString *str2 = [arr objectAtIndex:0];
                        if (str2.length>=range.location) {
                            return YES;
                        }else{
                        return NO;
                        }
                    }else{
                        return YES;
                    }
                    
                }
                
                
            }
            else  if([string characterAtIndex:0]=='.' &&[textField.text rangeOfString:@"."].location==NSNotFound) {
                
                
                return YES;
            }{
                return NO;
            }
        } else {
            return YES;
        }
     
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


@end
