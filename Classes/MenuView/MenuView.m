//
//  MenuView.m
//  Preit
//
//  Created by Taimoor Ali on 17/09/2015.
//
//

#import "MenuView.h"
#import "PreitAppDelegate.h"

@interface MenuView ()
{
    PreitAppDelegate *appDelegate;
}

@end

@implementation MenuView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    appDelegate = (PreitAppDelegate *)[[UIApplication sharedApplication] delegate];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
