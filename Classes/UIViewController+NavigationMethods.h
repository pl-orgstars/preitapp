//
//  UIViewController+NavigationMethods.h
//  Preit
//
//  Created by kuldeep on 6/3/14.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationMethods)

-(void)setNavigationTitle:(NSString *)string withBackButton:(BOOL)backBttn;
-(void)setNavigationLeftBackButton;
-(void)setUIForIOS7;
-(void)navigationbackButtonTapped:(id)sender;
-(void)setNavigationMenuButton;

@end
