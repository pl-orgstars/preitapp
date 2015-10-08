//
//  ShoppingListViewController.h
//  Preit
//
//  Created by sameer on 29/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductListView.h"
#import "PreitAppDelegate.h"
#import "Database.h"
#import "ProductDetailViewController.h"
#import "EmailListViewController.h"
#import "BaseViewController.h"


@interface ShoppingListViewController : BaseViewController <UIAlertViewDelegate>
{
    IBOutlet UILabel *lblResultCount;
//    IBOutlet UIButton *editBtn;
    IBOutlet UIToolbar *toolBar;
    ProductListView *productListView;
    PreitAppDelegate *delegate;    
    UIBarButtonItem *done;
    UIBarButtonItem *cancel;
    
}

-(IBAction)editClicked:(id)sender;
-(void)showProductDetail:(NSNumber *)productIndex;

@end
