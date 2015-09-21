//
//  SuperViewController.m
//  Preit
//
//  Created by charan on 5/7/13.
//
//

#import "SuperViewController.h"


@interface SuperViewController ()
@end

@implementation SuperViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    if ([[UIScreen mainScreen] bounds].size.height > 560)
    {
        nibNameOrNil = [nibNameOrNil stringByAppendingFormat:@" copy"];
    }
    
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidUnload{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
