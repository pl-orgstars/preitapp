//
//  MenuScreenViewController.h
//  Preit
//
//  Created by kuldeep on 5/29/14.
//
//

#import <UIKit/UIKit.h>

@interface MenuScreenViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSTimer *beaconmsgUpdate;
}
-(void)searchAction:(id)sender;
@end
