//
//  ParkScreenViewController.m
//  Preit
//
//  Created by kuldeep on 5/29/14.
//
//

#import "ParkScreenViewController.h"
#import "MapKitDragAndDropViewController.h"
#import "CameraImageViewController.h"
#import "PreitAppDelegate.h"

//#define MAP_UN_SELECTED @"Save location on map"
#define MAP_IS_SELECTED(flag) flag?@"View location on map":@"Save location on map"

#define PHOTO_IS_SELECTED(flag) flag?@"View photo of location":@"Save photo of location"
//#define PHOTO_SELECTED


#define DEFAULT_NOTE_FOR_REMINDER @"Save a voice reminder"
@interface ParkScreenViewController ()
{
    PreitAppDelegate *appdelegate;
    CLLocationCoordinate2D mallLocation;
}
@end

@implementation ParkScreenViewController

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
    appdelegate = (PreitAppDelegate *)[[UIApplication sharedApplication]delegate];

    [self setNavigationTitle:@"Parking" withBackButton:NO];
    
    [noteTextField.layer setBorderWidth: 1.0];
    noteTextField.layer.cornerRadius = 5;
    [noteTextField.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backNavigation.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    noteTextField.delegate = self;
    [noteTextField setInputAccessoryView:[self getTextFieldAccessoryView]];
    
    noteTextField.text = isNoteStored?getNotesParking:@"";
    [lblNote setHidden:![Utils checkForEmptyString:noteTextField.text]];
    if (isAudioStored) {
        filePath = getAudioParking;
        fileSavedMessage = getAudioNoteParking;
        [self isRecoding:NO];
    }else{
        filePath = @"";
        [self isRecoding:YES];
    }
    
    mallLocation = isLocationStored?getLocationParking:CLLocationCoordinate2DMake([[appdelegate.mallData objectForKey:@"location_lat"]floatValue], [[appdelegate.mallData objectForKey:@"location_lng"]floatValue]);
    
    imageCaptured = isImageStored?getImageParking:nil;
    
    audioRecorder = [[AudioRecorder alloc]init];
    audioRecorder.delegate = self;

    [lblMap setText:MAP_IS_SELECTED(isLocationStored)];
    [lblPhoto setText:PHOTO_IS_SELECTED(isImageStored)];
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)recordTapped:(UIButton *)sender{
    if (sender.isSelected) {
        lblRecording.text = @"Record";
        
        [audioRecorder stopRecording];
        filePath = [audioRecorder saveFileWithOldName:@"sound.caf"];
        
        NSDate *ddate = [NSDate date];
        NSDateFormatter *formater = [[NSDateFormatter alloc]init];
        [formater setDateFormat:@"EEE,MMM dd"];
        NSString *d1 = [formater stringFromDate:ddate];
        [formater setDateFormat:@"hh:mma"];
        NSString *d2 = [formater stringFromDate:ddate];
        fileSavedMessage = [NSString stringWithFormat:@"Recording made:%@ at %@",d1,d2];
        
        [Parking storeParkingAudioLocation:filePath note:fileSavedMessage];
        [self isRecoding:NO];
    }else{
        lblRecording.text = @"Stop";
        [audioRecorder startRecording];
    }
    [sender setSelected:!sender.isSelected];
    
}
-(IBAction)playTapped:(UIButton *)sender{

    if (!audioRecorder.player.isPlaying) {
        lblPlayPause.text = @"Pause";
        sender.selected = YES;
        [audioRecorder playFile:filePath];

    }else{
        lblPlayPause.text = @"Play";
        sender.selected = NO;
        [audioRecorder.player stop];
    }

    
}
-(IBAction)deleteTapped:(id)sender{
    [playBttn setSelected:NO];
    [audioRecorder.player stop];
    
    [Parking deleteParkingAudioLocation];
    
    [audioRecorder deleteFile:filePath];
    [self isRecoding:YES];
    
}
-(IBAction)loctionTapped:(id)sender{
    MapKitDragAndDropViewController *viewCnt = [[MapKitDragAndDropViewController alloc]initWithNibName:@"MapKitDragAndDropViewController" bundle:nil];
    viewCnt.loc = mallLocation;
    viewCnt.isEdit = isLocationStored;
    [viewCnt setCallback:^(NSString *str, CLLocationCoordinate2D location,BOOL isSaved) {
        if (isSaved) {
            mallLocation = location;
            [Parking storeParkingLocation:location];
        }
            [lblMap setText:MAP_IS_SELECTED(isSaved)];
        
       
    }];
    [self.navigationController pushViewController:viewCnt animated:YES];
}
-(IBAction)takePhotoTapped:(id)sender{
    
    if (imageCaptured) {
        [self showPreCaptureImage];
    }else{
        [self showCamera];
    }
    
    
    
}
-(void)showPreCaptureImage{
    CameraImageViewController *viewCnt = [[CameraImageViewController alloc]initWithNibName:@"CameraImageViewController" bundle:nil];
    [viewCnt setCallback:^(BOOL isDoneTapped) {
        if (!isDoneTapped) {
            [self showCamera];
        }
        
        [lblPhoto setText:PHOTO_IS_SELECTED(isImageStored)];
    }];
    viewCnt.cameraImage = imageCaptured;
    
    [self.navigationController presentViewController:viewCnt animated:YES completion:^{
        
    }];
}

-(void)showCamera{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // Set source to the camera
    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
    // Delegate is self
    imagePicker.delegate = self;
    
    // Allow editing of image ?
    imagePicker.allowsImageEditing = NO;
    
    // Show image picker
    [self.navigationController presentViewController:imagePicker animated:YES completion:^{
        
    }];
}
#pragma mark - AudioRecorderDelegete
-(void)audioPlayerDidFinishRecording:(BOOL)finishRecording{
    if (finishRecording) {
        [self isRecoding:NO];
    }
}
-(void)audioPlayerDidFinishPlaying:(BOOL)finishRecording{
//    [playBttn setSelected:NO];
    lblPlayPause.text = @"Play";
    playBttn.selected = NO;
}

-(void)isRecoding:(BOOL)isRecoding{
    [deleteBttn setEnabled:!isRecoding];
    [recordBttn setEnabled:isRecoding];
    [playBttn setEnabled:!isRecoding];
    
    lblTitle.text = isRecoding?DEFAULT_NOTE_FOR_REMINDER:fileSavedMessage;
    
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Access the uncropped image from info dictionary
    imageCaptured = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [Parking storeParkingImage:imageCaptured];
        [lblPhoto setText:PHOTO_IS_SELECTED(isImageStored)];
        
    }];
    // Save image
//    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
//    [picker release];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    
    // Unable to save the image
    if (error){
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                           message:@"Unable to save image to Photo Album."
                                          delegate:self cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil];
        [alert show];
    }
    else // All is well
    {
        
        
    }
//    alert = [[UIAlertView alloc] initWithTitle:@"Success"
//                                           message:@"Image saved to Photo Album."
//                                          delegate:self cancelButtonTitle:@"Ok"
//                                 otherButtonTitles:nil];
    
//    [alert release];
}
-(void)touchView:(id)sender{
    [self.view endEditing:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [lblNote setHidden:YES];
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    [Parking storeParkingNote:textView.text];
    [lblNote setHidden:![Utils checkForEmptyString:textView.text]];
}

-(UIToolbar *)getTextFieldAccessoryView{
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    toolBar.barStyle = UIBarStyleBlack;
    toolBar.translucent = YES;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTapped:)];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(doneTapped:)];
    cancel.tag = 1;
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    [fixedSpace setWidth:100];
    fixedSpace.width = 200;
    
    
    [toolBar setItems:[NSArray arrayWithObjects:cancel,fixedSpace, doneButton, nil]];
    return toolBar;
}
-(void)doneTapped:(UIBarButtonItem *)sender{
    if (sender.tag == 1) {
        noteTextField.text = @"";
    }else
    [self.view endEditing:YES];
    
}


@end
