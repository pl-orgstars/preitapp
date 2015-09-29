//
//  BaseViewController.h
//  Preit
//
//  Created by kuldeep on 5/27/14.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface BaseViewController : UIViewController{
   
    MBProgressHUD *hud;
}
-(void)hideHud;
-(void)showHudWithMessage:(NSString *)message;
-(void)showHudWithMessage:(NSString *)message color:(UIColor *)color;

- (void)addBackGroundImage;



@end
