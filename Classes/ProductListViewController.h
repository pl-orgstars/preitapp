//
//  ProductListViewController.h
//  Preit
//
//  Created by sameer on 29/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductListView.h"
#import "RequestAgent.h"
#import "JSON.h"
#import "PreitAppDelegate.h"
#import "ProductDetailViewController.h"
#import "Database.h"

#import "BaseViewController.h"
@interface ProductListViewController : BaseViewController <UISearchBarDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
{
    IBOutlet UIButton *pickerDone;
    IBOutlet UIToolbar *pickerToolBar;
    IBOutlet UIPickerView *pickerSort;
    IBOutlet UIView *barView;
    IBOutlet UISearchBar *productSearchBar;
    IBOutlet UIView *overView;
    IBOutlet UILabel *lblResultCount;
    IBOutlet UILabel *lblSort;
    IBOutlet UILabel *lblFind;
    NSArray *sortArray;
    ProductListView *productListView;
    UIActivityIndicatorView *spinner;
    long totalCount;
    int currentCount;
    NSString *urlString;
    PreitAppDelegate *delegate;
    NSString *sortString;
    NSMutableArray *mainArray;
    UILabel *listCountLabel;
    
    int currentSelectedTextboxIndex;
    IBOutlet UIButton *pickerBttn;
    UITextField *maximunPriceLabel;
    UITextField *minmumPriceLabel;


    UISegmentedControl *tabNavigation;
    
//    NSString *searchString;
    int page;
    
    NSString *searchString;
}

@property (nonatomic,retain) NSString* passedSearchString;

-(void)makeRequestForString:(NSString*)productStr;
-(void)loadMore;
-(void)moreRequestFinished:(NSData*)responseData;
-(void)moreRequestFailed:(NSError*)error;
-(void)prevRequestFinished:(NSData*)responseData;
-(void)prevRequestFailed:(NSError*)error;
-(void)showProductDetail:(NSNumber*)productIndex;
-(void)sort;
-(void)hidePicker;
-(void)loadPrevious;

-(void)addMaxMinTextField;
@end
