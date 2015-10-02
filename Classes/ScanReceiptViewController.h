//
//  ScanReceiptViewController.h
//  Preit
//
//  Created by Noman iqbal on 10/2/15.
//
//

#import <UIKit/UIKit.h>

@interface ScanReceiptViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>{
    
//    UIImagePickerController* imagePicker;
    
    IBOutlet UIScrollView*  mainScroll;
    
    IBOutlet UIView* receiptMainView;
    
    IBOutlet UIImageView*   receiptImgView;
    IBOutlet UIButton*      takeReceiptBtn;
    
    IBOutlet UIImageView*   dividerLine2;
    
    IBOutlet UIView* sectionMainView;
    
    IBOutlet UIButton*      sectionBtn;
    IBOutlet UILabel *longerLabel;
    IBOutlet UIImageView*   sectionImgView;
    
    
    
    NSMutableDictionary* originalImgArray;
    
    BOOL gettingReciept; // yes for reciept img, no for section img
}

@end
