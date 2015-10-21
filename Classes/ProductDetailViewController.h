//
//  ProductDetailViewController.h
//  Preit
//
//  Created by sameer on 05/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreDetailsViewController.h"
#import "Product.h"
#import "DetailAsyncImageVIew.h"
#import "Database.h"
#import "ShoppingListViewController.h"
#import "PreitAppDelegate.h"
#import "SingleStoreSearchViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "RequestAgent.h"
#import "JSON.h"

#import "BaseViewController.h"
@interface ProductDetailViewController : BaseViewController <UIScrollViewDelegate>
{
    IBOutlet UIScrollView *scrollProductDetail;
    //    IBOutlet UIToolbar *toolBar;
    //    IBOutlet UIButton *btnNext;
    //    IBOutlet UIButton *btnPrev;
    //    IBOutlet UILabel *lblResultsCount;
    IBOutlet UIScrollView *showImageScrollView;
    IBOutlet UIImageView *productImageView;
    IBOutlet UIView *productBackView;
    IBOutlet UIButton *hideImage;
    UILabel *listCountLabel;
    NSMutableArray *imagesArray;
    Database *dbAgent;
    PreitAppDelegate *delegate;
    
    IBOutlet UIImageView *imgViewZoom;
    
    
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblPrice;
    IBOutlet UILabel *lblStoreName;
    IBOutlet UIImageView *imgViewMain;
    IBOutlet UILabel *lblCount;
    IBOutlet UIImageView *imgviewCircle;;
    IBOutlet UILabel *lblShareVia;
    ///////
    
    UIView *main_view1;
    NSMutableArray *listContent;
    NSDictionary *checkDict;
    NSMutableArray *indexArray,*tempArray;
    
    UIActivityIndicatorView *spinner;
    
    
    NSString *urlString;
}

@property (nonatomic, retain) NSMutableArray *productsArray;
@property (nonatomic) int productIndex;
@property (nonatomic) BOOL isShoppingList;


-(void)createScrollView:(Product *)objectToBeUsed;
//-(IBAction)nextClicked:(id)sender;
//-(IBAction)prevClicked:(id)sender;
-(void)showImage;
-(IBAction)hideImage:(UIButton*)sender;
-(void)refresh;
-(void)settingsForGetdata;

////////

-(void)loadingView:(BOOL)flag;
-(void)checkIndex:(NSString*)name forindex:(int)i;
-(void)getData;
-(void)showStoreDetails;
-(CGRect)getFrameForImageWithSize:(CGSize)size compareSize:(CGSize)cSize;

@end
