//
//  SideMenu.m
//  Preit
//
//  Created by Noman iqbal on 9/21/15.
//
//

#import "SideMenu.h"
#import "PreitAppDelegate.h"

@interface SideMenu ()
{
    PreitAppDelegate* delegate;
}
@end

@implementation SideMenu


-(id)customInit
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"SideMenu" owner:self options:0] objectAtIndex:0];
    delegate = (PreitAppDelegate*) [UIApplication sharedApplication].delegate;
    
    
    sideTableView.delegate = self;
    sideTableView.dataSource = self;
    [sideTableView reloadData];
    [sideTableView setBackgroundColor:[UIColor clearColor]];
    
//    [self.nameLabel setText:[delegate.mallData objectForKey:@"name"]];
    
    
    
    

    
    return self;
}
- (IBAction)closeBtnCall:(id)sender {
    
    [delegate HideMenuViewOnTop];
}
- (IBAction)parkBtnCall:(id)sender {
    
    
    [delegate.tabBarController.delegate tabBarController:delegate.tabBarController shouldSelectViewController:[[delegate.tabBarController viewControllers] objectAtIndex:4]];
    delegate.tabBarController.selectedViewController = [delegate.tabBarController.viewControllers objectAtIndex:4];
    
    [delegate HideMenuViewOnTop];
}

- (IBAction)dealsBtnCall:(id)sender {
    [delegate.tabBarController.delegate tabBarController:delegate.tabBarController shouldSelectViewController:[[delegate.tabBarController viewControllers] objectAtIndex:3]];
    delegate.tabBarController.selectedViewController = [delegate.tabBarController.viewControllers objectAtIndex:3];
    
    [delegate HideMenuViewOnTop];
}
- (IBAction)menuBtnCall:(id)sender {
    [delegate.tabBarController.delegate tabBarController:delegate.tabBarController shouldSelectViewController:[[delegate.tabBarController viewControllers] objectAtIndex:2]];
    delegate.tabBarController.selectedViewController = [delegate.tabBarController.viewControllers objectAtIndex:2];
    
    [delegate HideMenuViewOnTop];
}

- (IBAction)searchBtnCall:(id)sender {
    [delegate.tabBarController.delegate tabBarController:delegate.tabBarController shouldSelectViewController:[[delegate.tabBarController viewControllers] objectAtIndex:1]];
    delegate.tabBarController.selectedViewController = [delegate.tabBarController.viewControllers objectAtIndex:1];
    
    [delegate HideMenuViewOnTop];
}
- (IBAction)shoppingBtnCall:(id)sender {
    
    [delegate.tabBarController.delegate tabBarController:delegate.tabBarController shouldSelectViewController:[[delegate.tabBarController viewControllers] objectAtIndex:0]];
    delegate.tabBarController.selectedViewController = [delegate.tabBarController.viewControllers objectAtIndex:0];
    
    [delegate HideMenuViewOnTop];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"sideMenuCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sideMenuCell"];
        cell.backgroundColor = [UIColor clearColor];
        
    }
    
    
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"mainmenu-icon-home"];
        [cell.textLabel setText:@"Home"];
    }
    else if (indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"mainmenu-icon-gift"];
        [cell.textLabel setText:@"Shopping"];
    }
    else if (indexPath.row == 2){
        cell.imageView.image = [UIImage imageNamed:@"mainmenu-icon-productsearch"];
        [cell.textLabel setText:@"Search"];
    }
    else if (indexPath.row == 3){
        cell.imageView.image = [UIImage imageNamed:@"mainmenu-icon-deals"];
        [cell.textLabel setText:@"Deals"];
    }
    else if (indexPath.row == 4){
        cell.imageView.image = [UIImage imageNamed:@"mainmenu-icon-parking"];
        [cell.textLabel setText:@"Parking"];
    }
    
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [delegate.tabBarController.delegate tabBarController:delegate.tabBarController shouldSelectViewController:[[delegate.tabBarController viewControllers] objectAtIndex:2]];
        delegate.tabBarController.selectedViewController = [delegate.tabBarController.viewControllers objectAtIndex:2];
        
        [delegate HideMenuViewOnTop];
    }
    else if (indexPath.row == 1){
        [delegate.tabBarController.delegate tabBarController:delegate.tabBarController shouldSelectViewController:[[delegate.tabBarController viewControllers] objectAtIndex:0]];
        delegate.tabBarController.selectedViewController = [delegate.tabBarController.viewControllers objectAtIndex:0];
        
        [delegate HideMenuViewOnTop];
    }
    else if (indexPath.row == 2){
        [delegate.tabBarController.delegate tabBarController:delegate.tabBarController shouldSelectViewController:[[delegate.tabBarController viewControllers] objectAtIndex:1]];
        delegate.tabBarController.selectedViewController = [delegate.tabBarController.viewControllers objectAtIndex:1];
        
        [delegate HideMenuViewOnTop];
    }
    else if (indexPath.row == 3){
        [delegate.tabBarController.delegate tabBarController:delegate.tabBarController shouldSelectViewController:[[delegate.tabBarController viewControllers] objectAtIndex:3]];
        delegate.tabBarController.selectedViewController = [delegate.tabBarController.viewControllers objectAtIndex:3];
        
        [delegate HideMenuViewOnTop];
    }
    else if (indexPath.row == 4){
        [delegate.tabBarController.delegate tabBarController:delegate.tabBarController shouldSelectViewController:[[delegate.tabBarController viewControllers] objectAtIndex:4]];
        delegate.tabBarController.selectedViewController = [delegate.tabBarController.viewControllers objectAtIndex:4];
        
        [delegate HideMenuViewOnTop];
    }
    
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
