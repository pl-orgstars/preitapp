//
//  CameraImageViewController.m
//  Preit
//
//  Created by kuldeep on 6/5/14.
//
//

#import "CameraImageViewController.h"

@interface CameraImageViewController ()

@end

@implementation CameraImageViewController

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
    [imageView setImage:_cameraImage];
    // Do any additional setup after loading the view from its nib.
    
    scrollView.scrollEnabled = YES;
    
    // For supporting zoom,
    scrollView.delegate = self;
    scrollView.minimumZoomScale = 1;
    scrollView.maximumZoomScale = 3.0;
    
}
// Implement a single scroll view delegate method
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)aScrollView {
    return imageView;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)doneTapped:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        _callback(YES);
    }];
}
-(IBAction)cameraTapped:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        _callback(NO);
    }];

}
@end
