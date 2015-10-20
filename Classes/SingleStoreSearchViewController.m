//
//  SingleStoreSearchViewController.m
//  Preit
//
//  Created by sameer on 11/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SingleStoreSearchViewController.h"
#define MAXROWS 30
#define REMOVEROWS 30
@implementation SingleStoreSearchViewController

@synthesize productsArray;
@synthesize titleString;

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

-(void)viewWillAppear:(BOOL)animated
{
    [self setNavigationTitle:self.titleString withBackButton:YES];
//    [listCountLabel setText:[NSString stringWithFormat:@"%d",[[Database sharedDatabase] getCount]]];
    [self AddinList:[[Database sharedDatabase] getCount]];
    if(self.titleString.length == 0){
        lblHeaderStore.text = @"Store";
    }else {
        lblHeaderStore.text = self.titleString;
    }
        
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addMaxMinTextField];
    delegate = (PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setHidesWhenStopped:YES];
    [spinner setCenter:self.view.center];
    [self.view addSubview:spinner];
    [spinner stopAnimating];
    
    CGRect frame = self.view.frame;
   
    frame = self.view.frame;
    frame.origin.y = 123;
    
    frame.size.height -=  frame.origin.y ;
    
    productListView = [[ProductListView alloc]initWithFrame:frame];
    [productListView setProductsArray:self.productsArray];
    [productListView setShowProductDetailDelegate:self];
    [productListView setShowProductDetailSelector:@selector(showProductDetail:)];

    productListView.loadMoreDelegate = self;
    productListView.loadMoreSelector = @selector(loadMore);
    productListView.loadPreviousSelector = @selector(loadPrevious);
    
    self.btnPrevious.hidden = TRUE;
    
    lblResultCount.text = @"Page 1";
    
    if (self.currentCount>=self.totalCount)
    {
        productListView.hasMoreProducts = NO;
    } else
    {
    
        productListView.hasMoreProducts = YES;
    }
    page = 1;
    
    if (self.currentCount>=10) {
        self.btnNext.hidden = FALSE;
        [productListView setHasMoreProducts:YES];
        
    }else{
        
        [productListView setHasMoreProducts:NO];
    }
    
    [self.view addSubview:productListView];
    // Do any additional setup after loading the view from its nib.
    
    UIView *barV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [barV setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *barImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"date"]];
    frame = barV.frame;
    frame.origin = CGPointZero;
    [barImageView setFrame:frame];
    [barV addSubview:barImageView];
    listCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(5.5, 0, 20, 20)];
    [listCountLabel setBackgroundColor:[UIColor clearColor]];
    [listCountLabel setTextColor:[UIColor whiteColor]];
    [listCountLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [listCountLabel setTextAlignment:NSTextAlignmentCenter];
    [barV addSubview:listCountLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(showShoppingList:)];
    [barV addGestureRecognizer:tap];
    
    UIBarButtonItem *shoppingListView = [[UIBarButtonItem alloc]initWithCustomView:barV];
    [self.navigationItem setRightBarButtonItem:shoppingListView];
    
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

-(void)showProductDetail:(NSNumber *)productIndex {
    NSLog(@"show product detail");
    ProductDetailViewController *detailView = [[ProductDetailViewController alloc]initWithNibName:@"ProductDetailViewController" bundle:nil];
    [self.navigationItem setTitle:@"Back"];
    detailView.productsArray = [[NSMutableArray alloc]initWithArray:productListView.productsArray];
    detailView.productIndex = productIndex.intValue;
    [self.navigationController pushViewController:detailView animated:YES];
}

-(IBAction)showShoppingList:(id)sender {
    NSLog(@"show shopping list %d",[[Database sharedDatabase]getCount]);

    if ([[Database sharedDatabase]getCount]) {
        ShoppingListViewController *shoppingList = [[ShoppingListViewController alloc]initWithNibName:@"ShoppingListViewController" bundle:nil];
        [self.navigationController pushViewController:shoppingList animated:YES];
        [self.navigationItem setTitle:@"Back"];
    }
}

#pragma mark - load more
-(void)loadMore
{
    
    if (![spinner isAnimating])
    {
        [spinner setHidden:NO];
        [spinner startAnimating];
        //kuldeep
        
        RequestAgent *req = [[RequestAgent alloc]init];
        page++;
        
        if (page > 1)
        {
            self.btnPrevious.hidden = false;
        }
        
        lblResultCount.text = [NSString stringWithFormat:@"Page %d",page];
        NSString *urlStringM = [NSString stringWithFormat:@"%@&page=%d",self.urlString,page];
        
        NSLog(@"loadmoreurl %@",urlStringM);
        [req requestToServer:self callBackSelector:@selector(moreRequestFinished:) errorSelector:@selector(moreRequestFailed:) Url:urlStringM];
    }
}


-(void)moreRequestFinished:(NSData*)responseData
{
    [spinner stopAnimating];
    NSString *jsonString = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [jsonString JSONValue];
    NSArray *array = [dict objectForKey:@"results"];
    NSMutableArray *itemsArray = [[NSMutableArray alloc]initWithCapacity:array.count];
    
    self.totalCount = [[dict objectForKey:@"count"] longValue];
    
    for (int i=0; i<array.count; i++) {
        Product *prod = [[Product alloc]initWithValues:[[array objectAtIndex:i] objectForKey:@"SearchResult"]];
        [itemsArray addObject:prod];
        if (i==29) {
            break;
        }
    }
    
    self.currentCount += (int)itemsArray.count;
    
    NSLog(@"breakkk at count %d",(int)itemsArray.count);
    
    if (self.totalCount<10)
    {
        self.btnNext.hidden = TRUE;
        productListView.hasMoreProducts = NO;
        NSLog(@"x");
    } else
    {
        self.btnNext.hidden = FALSE;
        productListView.hasMoreProducts = YES;
        NSLog(@"x");
    }
    [mainArray removeAllObjects];
    [mainArray addObjectsFromArray:itemsArray];
    [productListView.productsArray removeAllObjects];
    productListView.productsArray = [[NSMutableArray alloc]initWithArray:itemsArray];
    productListView.currentCount = self.currentCount;
//    [mainArray addObjectsFromArray:itemsArray];
//    [productListView.productsArray addObjectsFromArray:itemsArray];
//    if (productListView.productsArray.count>MAXROWS) {
//        NSLog(@"z");
//        [productListView.productsArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, REMOVEROWS)]];
//        NSLog(@"z");
//        [mainArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, REMOVEROWS)]];
//        productListView.hasPreviousProducts = YES;
//        NSLog(@"4");
//    }
//    NSLog(@"5");
//    productListView.currentCount = self.currentCount;
    
    [self sort];
    [productListView refreshNow];
}

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

        page--;
        if (page < 2)
        {
            page = 1;
            self.btnPrevious.hidden = TRUE;
        }
        self.btnNext.hidden = FALSE;
        lblResultCount.text = [NSString stringWithFormat:@"Page %d",page];
        NSString *urlStringM = [NSString stringWithFormat:@"%@&page=%d",self.urlString,page];//currentCount-mainArray.count-REMOVEROWS+1];
        NSLog(@"loadprevurl %@",urlStringM);
        [req requestToServer:self callBackSelector:@selector(prevRequestFinished:) errorSelector:@selector(prevRequestFailed:) Url:urlStringM];
    }
}

-(void)prevRequestFailed:(NSError *)error {
    
    [delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Network error!" buttontitle:@"Dismiss"];
    [spinner stopAnimating];
    
}

-(void)prevRequestFinished:(NSData *)responseData {
//    
//    [spinner stopAnimating];
//    NSString *jsonString = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];
//    NSDictionary *dict = [jsonString JSONValue];
//    NSLog(@"Load Previous %@",dict);
//    NSArray *array = [[dict objectForKey:@"item_lists"]objectForKey:@"normal"];
//    NSMutableArray *itemsArray = [[NSMutableArray alloc]initWithCapacity:array.count];
//    
//    
//    for (int i=0; i<array.count; i++) {
//        Product *prod = [[Product alloc]initWithValues:[array objectAtIndex:i]];
//        [itemsArray addObject:prod];
//        if (i==29) {
//            break;
//        }
//    }
    
    [spinner stopAnimating];
    NSString *jsonString = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [jsonString JSONValue];
    NSArray *array = [dict objectForKey:@"results"];
    NSMutableArray *itemsArray = [[NSMutableArray alloc]initWithCapacity:array.count];
    
    self.totalCount = [[dict objectForKey:@"count"] longValue];
    
    for (int i=0; i<array.count; i++) {
        Product *prod = [[Product alloc]initWithValues:[[array objectAtIndex:i] objectForKey:@"SearchResult"]];
        [itemsArray addObject:prod];
        if (i==29) {
            break;
        }
    }
    
    NSLog(@"itemsArray %d",(int)itemsArray.count);
    self.currentCount -= (int)itemsArray.count;
    [mainArray removeAllObjects];
    [mainArray addObjectsFromArray:itemsArray];
    [productListView.productsArray removeAllObjects];
    productListView.productsArray = [[NSMutableArray alloc]initWithArray:itemsArray];
    productListView.currentCount = self.currentCount;
    
//    int mod = self.currentCount % MAXROWS;
//    
//    if (mod>0) {
//        int diff = MAXROWS - mod;
//        self.currentCount += diff;
//    }
//    
//    productListView.hasMoreProducts = YES;
//    
//    if (self.currentCount<=MAXROWS) {
//        productListView.hasPreviousProducts = NO;
//    } else {
//        productListView.hasPreviousProducts = YES;
//    }
//    productListView.currentCount = self.currentCount;
//    [mainArray insertObjects:itemsArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, itemsArray.count)]];
//    [productListView.productsArray insertObjects:itemsArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, itemsArray.count)]];
//    
//    [mainArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(MAXROWS,mainArray.count-MAXROWS)]];
//    [productListView.productsArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(MAXROWS, productListView.productsArray.count - MAXROWS)]];
    
    [self sort];
    [productListView refreshNow];
}
#pragma mark - methods
-(void)sort {
    [productListView.productListTable reloadData];
}

-(IBAction)BackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)menuBtnCall:(id)sender {
    
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;
    
}

-(IBAction)NxtCall:(id)sender
{
    [self loadMore];
}

-(IBAction)PreviousCall:(id)sender
{
    [self loadPrevious];
}

-(IBAction)ShowPriceTab:(id)sender
{
    if(viewPriceBAr.hidden)
        viewPriceBAr.hidden = FALSE;
    else
        viewPriceBAr.hidden = TRUE;
}

-(void)addMaxMinTextField
{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    
    NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [itemsArray addObject:flexButton];
    
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(userClickedDone:)];
    [itemsArray addObject:doneButton];
    
    toolbar.items = itemsArray;
    
    minmumPriceLabel.inputAccessoryView = maximunPriceLabel.inputAccessoryView = toolbar;
    
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

#pragma mark - textFieldDelegate
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

@end
