//
//  SelectMonthViewController.h
//  Preit
//
//  Created by Aniket on 10/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SelectMonthViewController : UIViewController {
	IBOutlet UITableView *tableMonth;
	NSArray *tableData;
	int selectedMonth;
}
@property(nonatomic)int selectedMonth;
@end
