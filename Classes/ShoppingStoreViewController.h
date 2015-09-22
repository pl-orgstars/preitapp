//
//  StoreViewController.h
//  Preit
//
//  Created by Aniket on 10/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTable.h"

@interface ShoppingStoreViewController : CustomTable {
	NSString *titleString;

}
@property(nonatomic,retain) NSString *titleString;
@end
