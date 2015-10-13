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

-(void)viewWillAppear:(BOOL)animated {
//    [self.navigationItem setTitle:self.titleString];
    
    [self setNavigationTitle:self.titleString withBackButton:YES];
    
    
    
    [listCountLabel setText:[NSString stringWithFormat:@"%d",[[Database sharedDatabase] getCount]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    delegate = (PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setHidesWhenStopped:YES];
    [spinner setCenter:self.view.center];
    [self.view addSubview:spinner];
    [spinner stopAnimating];
    
    CGRect frame = self.view.frame;
   
    frame = self.view.frame;
    frame.origin.y = 60;
    
    frame.size.height -=  frame.origin.y ;
    
    productListView = [[ProductListView alloc]initWithFrame:frame];
    [productListView setProductsArray:self.productsArray];
    [productListView setShowProductDetailDelegate:self];
    [productListView setShowProductDetailSelector:@selector(showProductDetail:)];

    productListView.loadMoreDelegate = self;
    productListView.loadMoreSelector = @selector(loadMore);
    productListView.loadPreviousSelector = @selector(loadPrevious);
    
    if (self.currentCount>=self.totalCount) {
        productListView.hasMoreProducts = NO;
    } else {
        productListView.hasMoreProducts = YES;
    }
    page = 0;
    
    if (self.currentCount>=10) {
        
        [productListView setHasMoreProducts:YES];
        
    }else{
        
        [productListView setHasMoreProducts:NO];
    }
    
//    productListView.totalCount = self.totalCount;
//    productListView.currentCount = self.currentCount;
    
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

//    [self loadMore];
    
    
}

//-(void)dealloc {
//    [productListView release];
//    [super dealloc];
//}

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
    //    NSLog(@"prodarr %@",productListView.productsArray);
    detailView.productsArray = [[NSMutableArray alloc]initWithArray:productListView.productsArray];
    detailView.productIndex = productIndex.intValue;
    [self.navigationController pushViewController:detailView animated:YES];
//    [detailView release];
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


-(void)loadMore {
    
    if (![spinner isAnimating]) {
        [spinner setHidden:NO];
        [spinner startAnimating];
        //kuldeep
        
        RequestAgent *req = [[RequestAgent alloc]init];//autorelease];
        page = (int)self.currentCount/10;
        page++;
        
        NSString *urlStringM = [NSString stringWithFormat:@"%@&page=%d",self.urlString,page];
        
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
    NSLog(@"array count::::: %d",array.count);
    NSMutableArray *itemsArray = [[NSMutableArray alloc]initWithCapacity:array.count];
    
    self.totalCount = [[dict objectForKey:@"count"] longValue];
    
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
    
    self.currentCount += itemsArray.count;
    
    NSLog(@"breakkk at count %d",itemsArray.count);
    if (self.totalCount<10) {
        productListView.hasMoreProducts = NO;
        NSLog(@"x");
    } else {
        productListView.hasMoreProducts = YES;
        NSLog(@"x");
    }
    [mainArray addObjectsFromArray:itemsArray];
    [productListView.productsArray addObjectsFromArray:itemsArray];
    if (productListView.productsArray.count>MAXROWS) {
        NSLog(@"z");
        [productListView.productsArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, REMOVEROWS)]];
        NSLog(@"z");
        [mainArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, REMOVEROWS)]];
        productListView.hasPreviousProducts = YES;
        NSLog(@"4");
    }
    NSLog(@"5");
    productListView.currentCount = self.currentCount;
    
    //    [itemsArray release];
    [self sort];
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
        page = (int)self.currentCount/30;
        page--;
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
    
    self.currentCount -= itemsArray.count;
    
    int mod = self.currentCount % MAXROWS;
    
    if (mod>0) {
        int diff = MAXROWS - mod;
        self.currentCount += diff;
    }
    
    productListView.hasMoreProducts = YES;
    
    if (self.currentCount<=MAXROWS) {
        productListView.hasPreviousProducts = NO;
    } else {
        productListView.hasPreviousProducts = YES;
    }
    productListView.currentCount = self.currentCount;
    [mainArray insertObjects:itemsArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, itemsArray.count)]];
    [productListView.productsArray insertObjects:itemsArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, itemsArray.count)]];
    
    [mainArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(MAXROWS,mainArray.count-MAXROWS)]];
    [productListView.productsArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(MAXROWS, productListView.productsArray.count - MAXROWS)]];
    
    //    [itemsArray release];
    [self sort];
}
#pragma mark - methods
-(void)sort {
//    [lblSort setText:[NSString stringWithFormat:@"%@",sortString]];
//    if ([sortString isEqualToString:@"Price: Low-High"]) {
//        [productListView.productsArray sortUsingSelector:@selector(compareForPrice:)];
//        
//    } else if ([sortString isEqualToString:@"Price: High-Low"]) {
//        [productListView.productsArray sortUsingSelector:@selector(compareForPriceDesc:)];
//    } else {
//        [productListView.productsArray removeAllObjects];
//        [productListView.productsArray addObjectsFromArray:mainArray];
//    }
    [productListView.productListTable reloadData];
    
    //    [productListView.productListTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
//    [self setTheValueOfMaxAndMin];
}

-(IBAction)BackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)menuBtnCall:(id)sender {
    
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;
    
}
@end
