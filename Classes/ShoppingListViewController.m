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

//-(void)dealloc {
//    [productListView release];
//}

#pragma mark - View lifecycle


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [delegate showTabBar:NO];
    
//    [self.navigationItem setTitle:@"Shopping List"];
    
    [self setNavigationTitle:@"Shopping List" withBackButton:YES];
    
    [productListView.productListTable reloadData];
    
    [lblResultCount setText:[NSString stringWithFormat:@"%lu item%@",(unsigned long)productListView.productsArray.count,productListView.productsArray.count==1?@"":@"s"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    delegate = (PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    CGRect frame = self.view.frame;
    frame.origin.y = toolBar.frame.size.height;
    //kk
    if (is_iOS7) {
        frame.size.height -= 20;
    }
    if(isIPhone5){frame.size.height -= 16;}else{frame.size.height -= 90;};
    productListView = [[ProductListView alloc]initWithFrame:frame];
    productListView.editFlag = 0;
    productListView.showProductDetailDelegate = self;
    productListView.showProductDetailSelector = @selector(showProductDetail:);
    productListView.removeFromShListSelector = @selector(deleteFromTable:);
    //kuldeep edit2
    productListView.productsArray = [[NSMutableArray alloc]initWithArray:[[Database sharedDatabase]getShoppingList]];//autorelease];
    productListView.isShoppingList = YES;
    [productListView setShowProductDetailDelegate:self];
    [productListView setShowProductDetailSelector:@selector(showProductDetail:)];
    [self.view addSubview:productListView];
    [self.view insertSubview:toolBar aboveSubview:productListView];
    [self.view insertSubview:editBtn aboveSubview:toolBar];

    [self.view insertSubview:lblResultCount aboveSubview:toolBar];
    
//    UIBarButtonItem *emailBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"messege.png"] style:UIBarButtonItemStylePlain target:self action:@selector(emailList)];
//    [self.navigationItem setRightBarButtonItem:emailBtn];
//    
//    [emailBtn release];
    
    UIImageView *emailBtnImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"messege.png"]];
    [emailBtnImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                               action:@selector(emailList)]];
    [emailBtnImage setUserInteractionEnabled:YES];
    UIBarButtonItem *emailBtn = [[UIBarButtonItem alloc]initWithCustomView:emailBtnImage];
    [self.navigationItem setRightBarButtonItem:emailBtn];
    
//    [emailBtn release];
//    [emailBtnImage release];
    
    done = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneClicked)];
    
    cancel = [[UIBarButtonItem alloc]initWithTitle:@"Clear" style:UIBarButtonItemStyleDone target:self action:@selector(cancelClicked)];
    
    // Do any additional setup after loading the view from its nib.
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

-(IBAction)editClicked:(id)sender {
//    editFlag = YES;
    [self.navigationItem setLeftBarButtonItem:cancel];
    [self.navigationItem setRightBarButtonItem:done];
    productListView.editFlag = 1;
    productListView.isEditing = YES;
    [productListView.productListTable setEditing:YES animated:YES];
//    removeTempArray = [[NSMutableArray alloc]init];
    [lblResultCount setHidden:YES];
    [editBtn setHidden:YES];    
}

-(void)emailList {
    EmailListViewController *emailList = [[EmailListViewController alloc]initWithNibName:@"EmailListViewController" bundle:nil];
    emailList.productsArray = [NSArray arrayWithArray:productListView.productsArray];
    [self.navigationController pushViewController:emailList animated:YES];
    [self.navigationItem setTitle:@"Back"];
    [delegate hideTabBar:NO];
//    [emailList release];
}

-(void)showProductDetail:(NSNumber *)productIndex {
    NSLog(@"show product detail %d ",productIndex.intValue);
    ProductDetailViewController *detailView = [[ProductDetailViewController alloc]initWithNibName:@"ProductDetailViewController" bundle:nil];
    //    NSLog(@"prodarr %@",productListView.productsArray);
    detailView.productsArray = productListView.productsArray;
    detailView.productIndex = productIndex.intValue;
    detailView.isShoppingList = YES;
    [self.navigationController pushViewController:detailView animated:YES];
    [self.navigationItem setTitle:@"Back"];
//    [detailView release];
}
//kuldeep
-(void)setMssgicon{
    UIImageView *emailBtnImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"messege.png"]];
    [emailBtnImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                               action:@selector(emailList)]];
    [emailBtnImage setUserInteractionEnabled:YES];
    UIBarButtonItem *emailBtn = [[UIBarButtonItem alloc]initWithCustomView:emailBtnImage];
    [self.navigationItem setRightBarButtonItem:emailBtn];
}
-(void)doneClicked {
   
    
    productListView.editFlag = 2;
    [productListView.productListTable setEditing:NO animated:YES];
    productListView.isEditing = NO;
    [self.navigationItem setLeftBarButtonItem:nil];
    [self.navigationItem setRightBarButtonItem:nil];
    [lblResultCount setHidden:NO];
    [editBtn setHidden:NO];
    [lblResultCount setText:[NSString stringWithFormat:@"%d item%@",productListView.productsArray.count,productListView.productsArray.count==1?@"":@"s"]];
     [self setMssgicon];
}

-(void)cancelClicked {

    [[[UIAlertView alloc] initWithTitle:@"Clear List?" message:@"Are you sure you want to delete all items in your shopping list?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete All", nil]show];// autorelease]show];
/* 
 
 for (NSDictionary *d in removeTempArray) {
 Product *p = [d objectForKey:@"product"];
 NSNumber *n = [d objectForKey:@"row"];
 [productListView.productsArray insertObject:p atIndex:n.intValue-1];
 }
 
 [productListView.productListTable setEditing:NO animated:YES];    
 [productListView.productListTable reloadData];
 [self.navigationItem setLeftBarButtonItem:nil];
 [self.navigationItem setRightBarButtonItem:nil];
 [removeTempArray release];
 [lblResultCount setHidden:NO];
 [editBtn setHidden:NO];
 editFlag = NO;
 */
}

-(void)clearList {
    for (Product* p in productListView.productsArray) {
        [[Database sharedDatabase]removeProductFromShoppingList:p.productId];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)deleteFromTable:(NSNumber*)row {
//    if (editFlag) {
//        NSLog(@"edit delete");
//        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[productListView.productsArray objectAtIndex:row.intValue - 1],@"product",row,@"row", nil];
//        [removeTempArray addObject:dict];
//        [productListView.productsArray removeObjectAtIndex:(row.intValue-1)];
//        [productListView.productListTable reloadData];
//    } else {
        NSLog(@"single delete");
        Product *p = [productListView.productsArray objectAtIndex:row.intValue];
        [[Database sharedDatabase]removeProductFromShoppingList:p.productId];
        [productListView.productsArray removeObjectAtIndex:(row.intValue)];
        [productListView.productListTable reloadData];
        [lblResultCount setText:[NSString stringWithFormat:@"%d item%@",productListView.productsArray.count,productListView.productsArray.count==1?@"":@"s"]];
//    }
    if ([[Database sharedDatabase]getCount]==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        [self clearList];
    }
}

@end
