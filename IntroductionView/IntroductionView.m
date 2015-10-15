//
//  IntroductionView.m
//  Preit
//
//  Created by Taimoor Ali on 15/10/2015.
//
//

#import "IntroductionView.h"

@interface IntroductionView ()
{
    LocationViewController *loaction;
}
@end

@implementation IntroductionView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)Call:(id)sender
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"1" forKey:@"viewShow"];
    [user synchronize];
    
    loaction = [[LocationViewController alloc]initWithNibName:@"LocationViewController" bundle:nil];
    loaction.presentMainView = YES;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"mallData"] isKindOfClass:[NSData class]])
        loaction.shouldReload = NO;
    
    self.navigationController.viewControllers = [NSArray arrayWithObject:loaction];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    pageControl.currentPage = page; // you need to have a **iVar** with getter for pageControl
}
@end
