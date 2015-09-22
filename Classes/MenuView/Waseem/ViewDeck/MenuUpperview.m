//
//  MenuUpperview.m
//  Preit
//
//  Created by Taimoor Ali on 17/09/2015.
//
//

#import "MenuUpperview.h"
#import "PreitAppDelegate.h"

@interface MenuUpperview ()
{
    PreitAppDelegate *appDelegate;
}

@end

@implementation MenuUpperview

-(id)customInit
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MenuUpperview" owner:self options:0] objectAtIndex:0];
    
    return self;
}

-(IBAction)ButtonSelect:(UIButton *)btnsender
{
    switch (btnsender.tag) {
        case 101:
            
            break;
        
        case 102:
            
            break;
            
        case 103:
            
            
            break;
            
        case 104:
            
            break;
            
        case 105:
            
            break;
        default:
            break;
    }
}


-(IBAction)CloseMenu:(id)sender
{
    [appDelegate HideMenuViewOnTop];
}
@end
