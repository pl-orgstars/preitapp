//
//  UIViewController+NavigationMethods.m
//  Preit
//
//  Created by kuldeep on 6/3/14.
//
//

#import "UIViewController+NavigationMethods.h"
#import "PreitAppDelegate.h"

@implementation UIViewController (NavigationMethods)

-(void)setUIForIOS7{
    if (is_iOS7) {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        {
            self.edgesForExtendedLayout=UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars=NO;
            self.automaticallyAdjustsScrollViewInsets=NO;
        }
    }
    
    
}

#pragma mark - navigation title
-(void)setNavigationTitle:(NSString *)string withBackButton:(BOOL)backBttn
{
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 25.0)];
	titleLabel.text= [string uppercaseString];

	titleLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:18.0];
	titleLabel.textColor=[UIColor whiteColor];
	titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
	self.navigationItem.titleView=titleLabel;
    
    if (backBttn) {
        [self setNavigationLeftBackButton];
    }
    

    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setBackgroundImage:[UIImage imageNamed:@"MenuNew.png"] forState:UIControlStateNormal];
    button2.frame = CGRectMake(253, 20, 50, 44);
    [button2 addTarget:self action:@selector(MenuOpen:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button2];
    self.navigationItem.rightBarButtonItem = rightItem;
    

	
    
}

-(void)MenuOpen:(UIButton *)btn
{
    PreitAppDelegate *appDelegate = (PreitAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate ShowMenuViewOnTop];
}
-(void)setNavigationMenuButton
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(navigationbackButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"MenuNew.png"] forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(253, 20, 50, 44)];
    UIBarButtonItem *backBtton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    backBtton.tag=101;
    
    self.navigationItem.rightBarButtonItem=backBtton;
}


-(void)setNavigationLeftBackButton
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(navigationbackButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0, 0, 30, 30)];
    UIBarButtonItem *backBtton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    backBtton.tag=101;

	self.navigationItem.leftBarButtonItem=backBtton;
}

-(void)navigationbackButtonTapped:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
