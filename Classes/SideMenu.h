//
//  SideMenu.h
//  Preit
//
//  Created by Noman iqbal on 9/21/15.
//
//

#import <UIKit/UIKit.h>
@interface SideMenu : UIView <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView* sideTableView;
    
}
@property(nonatomic,retain) IBOutlet UILabel* nameLabel;


-(id)customInit;

@end
