//
//  PreitNavigationViewController.m
//  Preit
//
//  Created by Jawad Ahmed on 10/19/15.
//
//

#import "PreitNavigationViewController.h"

@interface PreitNavigationViewController ()

@end

@implementation PreitNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
    gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/************************************************************************************************************************************************/
#pragma mark - Navigation Controller Delegates

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (![viewController isKindOfClass:NSClassFromString(@"ProductSearchHome")] && ![viewController.view.gestureRecognizers containsObject:gesture]) {
            [viewController.view addGestureRecognizer:gesture];
    }
}

- (void)panGestureHandler:(UIPanGestureRecognizer *)recognizer {
    CGPoint vel = [recognizer velocityInView:self.view];
    UIViewController *controller = (UIViewController *)recognizer.view.nextResponder;
    
    if (vel.x > 0) {
        // swipe left
//        controller.view.gestureRecognizers = nil;
        [self popViewControllerAnimated:YES];
    } else {
        // swipe right
        controller.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;
    }
}

@end
