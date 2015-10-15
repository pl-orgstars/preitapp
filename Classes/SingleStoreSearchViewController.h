//
//  SingleStoreSearchViewController.h
//  Preit
//
//  Created by sameer on 11/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProductListView.h"
#import "ProductDetailViewController.h"
#import <UIKit/UIKit.h>
#import "PreitAppDelegate.h"
#import "Database.h"

@interface SingleStoreSearchViewController : BaseViewController
{
    ProductListView *productListView;
    UILabel *listCountLabel;
    int page;
    UIActivityIndicatorView *spinner;
    NSMutableArray *mainArray;
    PreitAppDelegate *delegate;
    
    // New Outlet
    IBOutlet UIView *barView;
    IBOutlet UIView *viewPriceBAr;
    IBOutlet UILabel *lblResultCount;
    IBOutlet UIImageView *imgViewCircleBG;
    IBOutlet UILabel *lblTotalNumber;
    
    IBOutlet UITextField *maximunPriceLabel;
    IBOutlet  UITextField *minmumPriceLabel;
    
    long totalCount;
    
}
@property (nonatomic ,strong )IBOutlet UIButton *btnNext;
@property (nonatomic ,strong )IBOutlet UIButton *btnPrevious;
@property (nonatomic,retain) NSMutableArray *productsArray;
@property (nonatomic,retain) NSString *titleString;
@property (nonatomic,retain) NSString *urlString;
@property (nonatomic)long totalCount;
@property (nonatomic, readwrite)int currentCount;
-(void)AddinList:(int)totalIndex;
@end
