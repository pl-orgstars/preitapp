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
    
    [self setNavigationTitle:@"Product Search" withBackButton:YES];
    
    [delegate hideProductScreen:YES];
    
    [listCountLabel setText:[NSString stringWithFormat:@"%d",[[Database sharedDatabase] getCount]]];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self addMaxMinTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShoppingListRefresh:) name:@"ShoppingListRefresh" object:nil];

    viewPriceBAr.hidden = TRUE;
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
    [barV addSubview:listCountLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(showShoppingList:)];
    [barV addGestureRecognizer:tap];
    
    
    UIBarButtonItem *shoppingListView = [[UIBarButtonItem alloc]initWithCustomView:barV];
    [self.navigationItem setRightBarButtonItem:shoppingListView];
    
    [lblFind setText:[NSString stringWithFormat:@"Find what you are looking for at %@ from participating retailers",(NSString*)[delegate.mallData objectForKey:@"name"]]];
    
    
    sortArray = [[NSArray alloc]initWithObjects:@"Sort: Relevance",@"Price: Low-High",@"Price: High-Low", nil];
    
    frame = self.view.frame;
    frame.origin.y = 175;
    
    frame.size.height -=  frame.origin.y ;
    productListView = [[ProductListView alloc]initWithFrame:frame];
    productListView.loadMoreDelegate = self;
    productListView.loadMoreSelector = @selector(loadMore);
    productListView.loadPreviousSelector = @selector(loadPrevious);
    
    productListView.showProductDetailDelegate = self;
    productListView.showProductDetailSelector = @selector(showProductDetail:);
    
    [self.view insertSubview:productListView belowSubview:pickerSort];
    [productListView setHidden:YES];
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
    
    if (self.passedSearchString) {
        productSearchBar.text = self.passedSearchString;
        
        [self searchBarSearchButtonClicked:productSearchBar];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - navigation

- (IBAction)menuBtnCall:(id)sender {
    
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;
    
}


- (IBAction)backBtnCall:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}



#pragma mark - search bar delegate

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    viewPriceBAr.hidden = TRUE;
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    viewPriceBAr.hidden = TRUE;
    NSLog(@"textchange %lu",(unsigned long)searchText.length);
    if (searchBar.text.length == 0 && !spinner.isAnimating) {
        [productListView.productsArray removeAllObjects];
        [productListView setHidden:YES];
        self.btnNext.hidden = TRUE;
        self.btnPrevious.hidden = TRUE;
        
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
    [searchBar resignFirstResponder];
    //    [overView setHidden:YES];
    [minmumPriceLabel setText:@""];
    [maximunPriceLabel setText:@""];
    
    NSLog(@"searchstsring %@",searchBar.text);
    [self makeRequestForString:searchBar.text];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    if (![productListView isHidden]) {
        [searchBar resignFirstResponder];
    }
}

#pragma mark make request
///kuldeep new api
-(void)showStoreDetails{
    
    NSString *str = NSLocalizedString(@"PRODUCT_SEARCH_IDS","");
    NSString *url= [NSString stringWithFormat:@"%@property_id=%ld", str,delegate.mallId];
    
    
    RequestAgent *req=[[RequestAgent alloc] init];// autorelease];
    [req requestToServer:self callBackSelector:@selector(responseSuccessForStoreID:) errorSelector:@selector(requestError:) Url:url];
    
    
}
-(void)responseSuccessForStoreID:(NSData *)receivedData
{
    NSLog(@"responseSuccessForTenantID");
    
    NSMutableString *storeId = [NSMutableString new];
    if(receivedData!=nil)
    {
        NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];
        // test string
        NSArray *tmpArray=[jsonString JSONValue];
        
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
        
    }
    
}



-(void)makeRequestForString:(NSString *)productStr {
    
    [spinner setHidden:NO];
    [spinner startAnimating];
    
    searchString = productStr;
    [self makeRequestForStringAndStoreId];
    
}
-(void)makeRequestForStringAndStoreId{
    
    RequestAgent *req = [[RequestAgent alloc]init];
    
    urlString = [[NSString alloc]initWithFormat:@"%@%@&property_id=%ld", NSLocalizedString(@"SEARCHAPI", @""), [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],delegate.mallId];
    
    NSString *url = [NSString stringWithFormat:@"%@&page=%d",urlString,page];
    [req requestToServer:self callBackSelector:@selector(requestForSearchFinishedSuccess:) errorSelector:@selector(requestError:) Url:url];
}

-(void)requestForSearchFinishedSuccess:(NSData*)responseData
{
    self.btnPrevious.hidden = TRUE;
    self.btnNext.hidden = TRUE;
    
    [productListView.productsArray removeAllObjects];
    [mainArray removeAllObjects];
    productListView.hasMoreProducts = NO;
    productListView.hasPreviousProducts = NO;
    //kuldeep edited
    NSString *jsonString = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];//autorelease];
    
    NSDictionary *dict = [jsonString JSONValue];
    
    totalCount = [[dict objectForKey:@"count"] longValue];
    
    NSArray *array = [dict objectForKey:@"results"];
    
    NSMutableArray *itemsArray = [[NSMutableArray alloc]initWithCapacity:array.count];
    
    for (int i=0; i<array.count; i++) {
        Product *prod = [[Product alloc]initWithValues:[[array objectAtIndex:i] objectForKey:@"SearchResult"]];
        [itemsArray addObject:prod];
        if (i==29)
        {
            break;
        }
    }
    currentCount = (int)itemsArray.count;
    
    if (totalCount<10) {
        productListView.hasMoreProducts = NO;
        
    } else {
        productListView.hasMoreProducts = YES;
        self.btnNext.hidden = FALSE;
    }
    [barView setHidden:NO];
    [lblSort setText:[NSString stringWithFormat:@"Sort: %@",sortString]];
    mainArray = [[NSMutableArray alloc]initWithArray:itemsArray];
    if (productListView.productsArray) {
        
    }
    productListView.productsArray = [[NSMutableArray alloc]initWithArray:itemsArray];
    productListView.backgroundColor = [UIColor clearColor];
    [productListView setHidden:NO];
    
    //    [overView setHidden:YES];
    [spinner stopAnimating];
    
    if (itemsArray.count==0) {
        [delegate showAlert:@"No product matching your criteria found" title:@"No result found" buttontitle:@"Dismiss"];
    }
    productListView.totalCount = (int)totalCount;
    productListView.currentCount = currentCount;
    [self sort];
    
}

-(void)requestError:(NSError*)error {
    [delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Network error" buttontitle:@"Dismiss"];
    [spinner stopAnimating];
}

#pragma mark - load more

-(void)loadMore {
    
    if (![spinner isAnimating]) {
        [spinner setHidden:NO];
        [spinner startAnimating];
        RequestAgent *req = [[RequestAgent alloc]init];//autorelease];
        page++;
        if (page > 1) {
            self.btnPrevious.hidden = FALSE;
        }else {
            self.btnPrevious.hidden = TRUE;
        }
        NSString *urlStringM = [NSString stringWithFormat:@"%@&page=%d",urlString,page];
        
        [req requestToServer:self callBackSelector:@selector(moreRequestFinished:) errorSelector:@selector(moreRequestFailed:) Url:urlStringM];
    }
}


-(void)moreRequestFinished:(NSData*)responseData {
    [spinner stopAnimating];
    NSString *jsonString = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [jsonString JSONValue];
    NSArray *array = [dict objectForKey:@"results"];
    NSMutableArray *itemsArray = [[NSMutableArray alloc]initWithCapacity:array.count];
    
    totalCount = [[dict objectForKey:@"count"] longValue];
    
    for (int i=0; i<array.count; i++) {
        Product *prod = [[Product alloc]initWithValues:[[array objectAtIndex:i] objectForKey:@"SearchResult"]];
        [itemsArray addObject:prod];
        if (i==29) {
            break;
        }
    }
    currentCount += itemsArray.count;
    
    if (totalCount<10) {
        productListView.hasMoreProducts = NO;
        self.btnNext.hidden = TRUE;
    } else {
        productListView.hasMoreProducts = YES;
        self.btnNext.hidden = FALSE;
    }
    [mainArray removeAllObjects];
    [mainArray addObjectsFromArray:itemsArray];
    [productListView.productsArray removeAllObjects];
    productListView.productsArray = [[NSMutableArray alloc]initWithArray:itemsArray];
    productListView.currentCount = currentCount;
    [self sort];
}

-(void)moreRequestFailed:(NSError*)error {
    [delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Network error!" buttontitle:@"Dismiss"];
    [spinner stopAnimating];
}


-(void)loadPrevious {
    
    
    if (![spinner isAnimating]) {
        [spinner setHidden:NO];
        [spinner startAnimating];
        RequestAgent *req = [[RequestAgent alloc]init];
        page--;
        if (page == 1) {
            self.btnPrevious.hidden = TRUE;
        }
        if (page < 1) {
            page = 1;
            self.btnPrevious.hidden = TRUE;
        }
        NSString *urlStringM = [NSString stringWithFormat:@"%@&page=%d",urlString,page];//currentCount-mainArray.count-REMOVEROWS+1];
        NSLog(@"loadprevurl %@",urlStringM);
        [req requestToServer:self callBackSelector:@selector(prevRequestFinished:) errorSelector:@selector(prevRequestFailed:) Url:urlStringM];
    }
}

-(void)prevRequestFailed:(NSError *)error {
    
    [delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Network error!" buttontitle:@"Dismiss"];
    [spinner stopAnimating];
    
}

-(void)prevRequestFinished:(NSData *)responseData
{
    [spinner stopAnimating];
    NSString *jsonString = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [jsonString JSONValue];
    NSArray *array = [dict objectForKey:@"results"];
    NSMutableArray *itemsArray = [[NSMutableArray alloc]initWithCapacity:array.count];
    
    totalCount = [[dict objectForKey:@"count"] longValue];
    
    for (int i=0; i<array.count; i++) {
        Product *prod = [[Product alloc]initWithValues:[[array objectAtIndex:i] objectForKey:@"SearchResult"]];
        [itemsArray addObject:prod];
        if (i==29) {
            break;
        }
    }
    currentCount -= itemsArray.count;
    
    NSLog(@"3");
    if (totalCount<10) {
        productListView.hasMoreProducts = NO;
        self.btnNext.hidden = TRUE;
        NSLog(@"x");
    } else {
        productListView.hasMoreProducts = YES;
        NSLog(@"x");
        self.btnNext.hidden = FALSE;
    }
    NSLog(@"Count ====%d",(int)itemsArray.count);
    [mainArray removeAllObjects];
    [mainArray addObjectsFromArray:itemsArray];
    //    [productListView.productsArray addObjectsFromArray:itemsArray];
    [productListView.productsArray removeAllObjects];
    productListView.productsArray = [[NSMutableArray alloc]initWithArray:itemsArray];
    productListView.currentCount = currentCount;
    [self sort];
}

#pragma mark - show detail

-(void)showProductDetail:(NSNumber *)productIndex {
    if (!spinner.isAnimating)
    {
        NSLog(@"show product detail");
        ProductDetailViewController *detailView = [[ProductDetailViewController alloc]initWithNibName:@"ProductDetailViewController" bundle:nil];
        [self.navigationItem setTitle:@"Back"];
        detailView.productsArray = [[NSMutableArray alloc]initWithArray:productListView.productsArray];
        detailView.productIndex = productIndex.intValue;
        
        delegate.searchURL = urlString;
        NSLog(@"urlString %@",urlString);
        [self.navigationController pushViewController:detailView animated:YES];
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
    [productListView.collectionView reloadData];
    
    lblResultCount.text = [NSString stringWithFormat:@"Page %d",page];
    
}


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
    UITapGestureRecognizer *pickerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickerViewTapped:)];
    [pView addGestureRecognizer:pickerTap];
    [pView setTag:row];
    return pView;
}

-(void)pickerViewTapped:(UITapGestureRecognizer*)tap {
    
    int row = (int)[[tap view]tag];
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
    
    [self makeRequestForString:str];
}
-(void)setTheValueOfMaxAndMin{
    float min= 0,max = 0;
    if(productListView.productsArray.count){
        Product *prod = [productListView.productsArray objectAtIndex:0];
        min = prod.price;
        max = prod.price;
        for (Product *d in productListView.productsArray) {
            if (d.price>max) {
                max = d.price;
            }
            if (d.price<min) {
                
                min = d.price;
            }
            
        }
        
    }
    maximunPriceLabel.text = [NSString stringWithFormat:@"%.2f",max];
    minmumPriceLabel.text = [NSString stringWithFormat:@"%.2f",min];
    
    
}



-(void)addMaxMinTextField
{
    
    [pickerBttn setHidden:YES];
    [lblSort setHidden:YES];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    
    NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
    
    
    //    tabNavigation = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Previous", @"Next", nil]];
    //    [tabNavigation setEnabled:YES forSegmentAtIndex:0];
    //    [tabNavigation setEnabled:YES forSegmentAtIndex:1];
    //    tabNavigation.momentary = YES;
    //    [tabNavigation addTarget:self action:@selector(segmentedControlHandler:) forControlEvents:UIControlEventValueChanged];
    //    UIBarButtonItem *barSegment = [[UIBarButtonItem alloc] initWithCustomView:tabNavigation];
    //
    //    [itemsArray addObject:barSegment];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [itemsArray addObject:flexButton];
    
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(userClickedDone:)];
    [itemsArray addObject:doneButton];
    
    toolbar.items = itemsArray;
    
    minmumPriceLabel.inputAccessoryView = maximunPriceLabel.inputAccessoryView = toolbar;
    
}
- (void)segmentedControlHandler:(id)sender
{
    
    
    currentSelectedTextboxIndex = (int)[(UISegmentedControl *)sender selectedSegmentIndex];
    
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
- (void)userClickedDone:(id)sender
{
    
    if (!maximunPriceLabel.text.length || minmumPriceLabel.text.floatValue<=maximunPriceLabel.text.floatValue) {
        viewPriceBAr.hidden = TRUE;
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
        [tabNavigation setEnabled:NO forSegmentAtIndex:0];
        [tabNavigation setEnabled:YES forSegmentAtIndex:1];
    }else{
        [tabNavigation setEnabled:YES forSegmentAtIndex:0];
        [tabNavigation setEnabled:NO forSegmentAtIndex:1];
        
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == maximunPriceLabel || textField == minmumPriceLabel )
    {
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


-(IBAction)ShowPriceTab:(id)sender
{
    
    viewPriceBAr.hidden = FALSE;
}


-(IBAction)NxtCall:(id)sender
{
    [self loadMore];
}

-(IBAction)PreviousCall:(id)sender
{
    [self loadPrevious];
}

- (void)ShoppingListRefresh:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    [self AddinList:[dictionary[@"total"] intValue]];
}

-(void)AddinList:(int)totalIndex
{
 
    if (totalIndex > 0)
    {
        lblTotalNumber.hidden = FALSE;
        imgViewCircleBG.hidden = FALSE;
        lblTotalNumber.text = [NSString stringWithFormat:@"%d",totalIndex];
    }else
    {
        lblTotalNumber.hidden = TRUE;
        imgViewCircleBG.hidden = TRUE;
    }
}
@end
