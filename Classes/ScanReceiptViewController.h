//
//  ScanReceiptViewController.h
//  Preit
//
//  Created by Noman iqbal on 10/2/15.
//
//

#import <UIKit/UIKit.h>
#import "PreitAppDelegate.h"
#import "RequestAgent.h"
#include "JSON.h"
#include "AFNetworking.h"


@interface ScanReceiptViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>{
    
//    UIImagePickerController* imagePicker;
    
    IBOutlet UIScrollView   *mainScroll;
    
    IBOutlet UILabel        *mainLabel;
    
    IBOutlet UIView         *receiptMainView;
    
    IBOutlet UIImageView    *receiptImgView;
    IBOutlet UIButton       *takeReceiptBtn;
    
    IBOutlet UIImageView    *dividerLine2;
    
    IBOutlet UIView         *sectionMainView;
    
    IBOutlet UIButton       *sectionBtn;
    IBOutlet UILabel        *longerLabel;
    IBOutlet UIImageView    *sectionImgView;
    
    IBOutlet UIView         *section2MainView;
    IBOutlet UIButton       *section2Btn;
    IBOutlet UILabel        *longerlabel2;
    IBOutlet UIImageView    *section2ImgView;
    
    IBOutlet UIButton       *cancelBtn;
    
    
    IBOutlet UIView*        uploadedView;
    IBOutlet UILabel        *processingLabel;
    
    IBOutlet UIImageView*   divider;
    IBOutlet UIImageView* divider1;
    
    IBOutlet UILabel* combo;
    
    
    
    NSMutableDictionary* originalImgArray;
    
    BOOL gettingReciept; // yes for reciept img, no for section img
    BOOL gettingSection1;   // yes for section 1 , no for section2;
}

@end
