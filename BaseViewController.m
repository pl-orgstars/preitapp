//
//  BaseViewController.m
//  Preit
//
//  Created by kuldeep on 5/27/14.
//
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!is_iOS7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    

    [self adjustUIForIOS7];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showHudWithMessage:(NSString *)message{
    [self showHudWithMessage:message color:[UIColor clearColor]];
}

-(void)showHudWithMessage:(NSString *)message color:(UIColor *)color {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (![Utils checkForEmptyString:message])
    {
        [hud setLabelText:message];
        [hud setLabelFont:[UIFont systemFontOfSize:17]];
        [hud setColor:color];
        //        [hud setL [UIColor blackColor]];
    }
    [hud setOpacity:0];
    [hud show:YES];
}

-(void)hideHud
{
    [hud hide:YES];
}


-(void)adjustUIForIOS7
{
    if (is_iOS7)
    {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        {
            self.edgesForExtendedLayout=UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars=NO;
            self.automaticallyAdjustsScrollViewInsets=NO;
        }
    }
}

- (void)addBackGroundImage
{
//    NSString *imageName = is_iPhone5?@"Launch_screen568h@2x.png":@"Launch_screen.png"; // assuming for ipad currently for ipad
    
    UIImageView *backgroundImageView = [[UIImageView alloc]init];
    backgroundImageView.backgroundColor = [UIColor blackColor];
    
    [backgroundImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [backgroundImageView setFrame:self.view.frame];
    
    [self.view insertSubview:backgroundImageView atIndex:0];
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

@end
