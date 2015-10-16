//
//  IntroductionView.h
//  Preit
//
//  Created by Taimoor Ali on 15/10/2015.
//
//

#import <UIKit/UIKit.h>
#import "LocationViewController.h"

@interface IntroductionView : UIViewController <UIScrollViewDelegate>
{
  IBOutlet UIPageControl *pageControl;
    
    IBOutlet UIButton *btnRightMove;
    IBOutlet UIButton *btnLeftMove;
    
    IBOutlet UIScrollView *scrollViewMain;
    
    int pagenumber;

}
@end
