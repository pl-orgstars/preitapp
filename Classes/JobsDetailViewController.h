//
//  JobsDetailViewController.h
//  Preit
//
//  Created by Noman iqbal on 10/2/15.
//
//

#import <UIKit/UIKit.h>

@interface JobsDetailViewController : UIViewController{
    
    IBOutlet UILabel* storeNameLabel;
    IBOutlet UILabel* positionNameLabel;
    
    IBOutlet UITextView* descriptionView;
    IBOutlet UITextView* contactInfoView;
    
    IBOutlet UIImageView* dividerLine;
    
    IBOutlet UIScrollView* mainScroll;
    
}

@property (nonatomic,retain) NSDictionary* jobDetailDict;

@end
