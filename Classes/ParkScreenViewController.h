//
//  ParkScreenViewController.h
//  Preit
//
//  Created by kuldeep on 5/29/14.
//
//

#import <UIKit/UIKit.h>
#import "AudioRecorder.h"
@interface ParkScreenViewController : BaseViewController<AudioRecorderDelegete,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate>
{
    __weak IBOutlet UITextView *noteTextField;
    
    __weak IBOutlet UIButton *recordBttn;
    __weak IBOutlet UIButton *playBttn;
    __weak IBOutlet UIButton *deleteBttn;
    __weak IBOutlet UIButton *captureImageButton;
    __weak IBOutlet UIButton *captureImageButton2;
    __weak IBOutlet UIButton *captureMapButton;
    
    __weak IBOutlet UILabel *lblNote;
    
    __weak IBOutlet UILabel *lblTitle;
    
    __weak IBOutlet UILabel *lblRecording;
    __weak IBOutlet UILabel *lblPlayPause;
    
    __weak IBOutlet UILabel *lblMap;
    __weak IBOutlet UILabel *lblPhoto;
    __weak IBOutlet UIImageView *parkingImageView;
    __weak IBOutlet UIImageView *mapImageView;
    
    AudioRecorder *audioRecorder;
    NSString *filePath;
    NSString *fileSavedMessage;
    
    UIImage *imageCaptured;
}
-(IBAction)recordTapped:(id)sender;
-(IBAction)playTapped:(id)sender;
-(IBAction)deleteTapped:(id)sender;
-(IBAction)loctionTapped:(id)sender;
-(IBAction)takePhotoTapped:(id)sender;
@end
