//
//  MenuScreenViewController.h
//  Preit
//
//  Created by kuldeep on 5/29/14.
//
//

#import <UIKit/UIKit.h>
#import "ParkScreenViewController.h"

@interface MenuScreenViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSTimer *beaconmsgUpdate;
    IBOutlet UITableView *tableView_;
}

-(void)searchAction:(id)sender;
@property (retain, nonatomic) UINavigationController *navController;

@end
