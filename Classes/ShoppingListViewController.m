//
//  ShoppingListViewController.m
//  Preit
//
//  Created by sameer on 29/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShoppingListViewController.h"

@implementation ShoppingListViewController

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
    [super viewWillAppear:YES];
    [delegate showTabBar:NO];
    [self setNavigationTitle:@"Shopping List" withBackButton:YES];

    if ([[Database sharedDatabase] getCount] > 0) {
        viewEmptyShoppingList.hidden = TRUE;
        [productListView.productListTable reloadData];
        [lblResultCount setText:[NSString stringWithFormat:@"%d item%@",[[Database sharedDatabase] getCount],[[Database sharedDatabase] getCount]==1?@"":@"s"]];
        productListView.productsArray = [[NSMutableArray alloc]initWithArray:[[Database sharedDatabase]getShoppingList]];
        [productListView refreshNow];
    }else
        viewEmptyShoppingList.hidden = FALSE;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    viewEmptyShoppingList.hidden = TRUE;
    delegate = (PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    CGRect frame = self.view.frame;
    frame.origin.y = 110;
    frame.size.height -=  frame.origin.y ;
    productListView = [[ProductListView alloc]initWithFrame:frame];
    productListView.editFlag = 0;
    productListView.showProductDetailDelegate = self;
    productListView.showProductDetailSelector = @selector(showProductDetail:);
    productListView.removeFromShListSelector = @selector(deleteFromTable:);

    productListView.productsArray = [[NSMutableArray alloc]initWithArray:[[Database sharedDatabase]getShoppingList]];//autorelease];
    productListView.isShoppingList = YES;
    [productListView setShowProductDetailDelegate:self];
    [productListView setShowProductDetailSelector:@selector(showProductDetail:)];
    [self.view addSubview:productListView];
    [self.view insertSubview:toolBar aboveSubview:productListView];

    [self.view insertSubview:lblResultCount aboveSubview:toolBar];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)emailList {
    EmailListViewController *emailList = [[EmailListViewController alloc]initWithNibName:@"EmailListViewController" bundle:nil];
    emailList.productsArray = [NSArray arrayWithArray:productListView.productsArray];
    [self.navigationController pushViewController:emailList animated:YES];
    [self.navigationItem setTitle:@"Back"];
    [delegate hideTabBar:NO];
}

-(void)showProductDetail:(NSNumber *)productIndex {
    NSLog(@"show product detail %d ",productIndex.intValue);
    
    ProductDetailViewController *detailView = [[ProductDetailViewController alloc]initWithNibName:@"ProductDetailViewController" bundle:nil];
    [self.navigationItem setTitle:@"Back"];
    detailView.productsArray = [[NSMutableArray alloc]initWithArray:productListView.productsArray];
    detailView.productIndex = productIndex.intValue;
    detailView.isShoppingList = TRUE;
    delegate.searchURL = @"";
    
    [self.navigationController pushViewController:detailView animated:YES];
}

-(IBAction)EmailBtn:(id)sender
{
    [self emailList];
}

-(void)deleteFromTable:(NSNumber*)row {
    if ([[Database sharedDatabase] getCount] > 0) {
        viewEmptyShoppingList.hidden = TRUE;
        [lblResultCount setText:[NSString stringWithFormat:@"%d item%@",[[Database sharedDatabase] getCount],[[Database sharedDatabase] getCount]==1?@"":@"s"]];
    }else {
        viewEmptyShoppingList.hidden = FALSE;
    }
}

#pragma mark - navigation

- (IBAction)menuBtnCall:(id)sender {
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;
}

- (IBAction)backBtnCall:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}


@end
