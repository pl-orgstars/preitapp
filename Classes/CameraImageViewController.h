//
//  CameraImageViewController.h
//  Preit
//
//  Created by kuldeep on 6/5/14.
//
//

#import <UIKit/UIKit.h>

@interface CameraImageViewController : UIViewController<UIScrollViewDelegate>{
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UIScrollView *scrollView;
}
@property (nonatomic,weak) UIImage *cameraImage;
@property (nonatomic,copy) void(^callback)(BOOL isDoneTapped);
@end
