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
@interface SingleStoreSearchViewController : BaseViewController
{
    ProductListView *productListView;
    UILabel *listCountLabel;
    
//    NSString *urlString;

    int page;
    UIActivityIndicatorView *spinner;
    
    NSMutableArray *mainArray;
    PreitAppDelegate *delegate;
}

@property (nonatomic,retain) NSMutableArray *productsArray;
@property (nonatomic,retain) NSString *titleString;
@property (nonatomic,retain) NSString *urlString;
@property (nonatomic)long totalCount;
@property (nonatomic, readwrite)int currentCount;
@end
