//
//  ScanReceiptViewController.m
//  Preit
//
//  Created by Noman iqbal on 10/2/15.
//
//

#import "ScanReceiptViewController.h"

@interface ScanReceiptViewController ()

@end

@implementation ScanReceiptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.\
    
    
    originalImgArray = [[NSMutableDictionary alloc] init];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - image picker

-(void)showImagePickerWithSource:(UIImagePickerControllerSourceType)sourceType{
    
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
//    imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePicker.sourceType = sourceType;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage* image = [info valueForKey:UIImagePickerControllerOriginalImage];
    UIImage* scaledImage = [self imageWithImage:image scaledToWidth:receiptImgView.frame.size.width];

    if (gettingReciept) {
        CGRect receiptViewFrame = receiptImgView.frame;
        receiptViewFrame.size.height = scaledImage.size.height;
        [receiptImgView setFrame:receiptViewFrame];
        receiptImgView.image = scaledImage;
        [receiptImgView setHidden:NO];
        [takeReceiptBtn setHidden:YES];
        [takeReceiptBtn setEnabled:NO];
        
        CGRect mainFrame = receiptMainView.frame;
        mainFrame.size.height = receiptImgView.frame.size.height;
        
        [receiptMainView setFrame:mainFrame];
        [self addRetakeButtonToImageView:receiptImgView];
        [self receiptSizeChanged];
        
        [originalImgArray setObject:image forKey:@"receipt"];
        
    }
    
    else{

            CGRect sectionImgFrame = sectionImgView.frame;
            sectionImgFrame.size.height = scaledImage.size.height;
            [sectionImgView setFrame:sectionImgFrame];
            [sectionImgView setImage:scaledImage];
            [sectionImgView setHidden:NO];
            
            CGRect mainFrame = sectionMainView.frame;
            mainFrame.size.height = sectionImgView.frame.size.height;
            [sectionMainView setFrame:mainFrame];
            [self addRetakeButtonToImageView:sectionImgView];
            
            [originalImgArray setObject:image forKey:@"section1"];
        
        [sectionBtn setHidden:YES];
        [longerLabel setHidden:YES];
        [sectionBtn setEnabled:NO];
        
            
    
        
     
    }
    [self updateScroll:mainScroll];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Button Actions
- (IBAction)getReceiptBtnCall:(id)sender {
    gettingReciept = YES;
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Chose Source" message:@"Please select the source" delegate:self cancelButtonTitle:@"Camera" otherButtonTitles:@"Photos", nil];
        [alertView show];
    }
    else{
        [self showImagePickerWithSource:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    
}

- (IBAction)getSectionBtnCall:(id)sender {
    gettingReciept = NO;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Chose Source" message:@"Please select the source" delegate:self cancelButtonTitle:@"Camera" otherButtonTitles:@"Photos", nil];
        [alertView show];
    }
    else{
        [self showImagePickerWithSource:UIImagePickerControllerSourceTypePhotoLibrary];    }
}


-(IBAction)retakeImage:(UIButton*)sender{
    
    if (sender.superview.tag == 101) {
        [self getReceiptBtnCall:nil];
    }
    else{
        [self getSectionBtnCall:nil];
    }
    
}




#pragma mark - Alert View Delegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        [self showImagePickerWithSource:UIImagePickerControllerSourceTypeCamera];
    }
    else{
        [self showImagePickerWithSource:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}






#pragma mark - Navigation

- (IBAction)menuBtnCall:(id)sender {
    
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;
}
- (IBAction)backBtnCall:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - image methods

-(void)addRetakeButtonToImageView:(UIImageView*) imageView{
    
    CGSize btnSize = CGSizeMake(100, 40);
    CGRect frame = CGRectMake(imageView.frame.size.width - btnSize.width, imageView.frame.size.height - btnSize.height, btnSize.width, btnSize.height);
    UIButton* retakeBtn = [[UIButton alloc] initWithFrame:frame];
    [retakeBtn setTitle:@"Retake" forState:UIControlStateNormal];
    [retakeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [retakeBtn setBackgroundColor:[UIColor blackColor]];
    
    [retakeBtn addTarget:self action:@selector(retakeImage:) forControlEvents:UIControlEventTouchUpInside];
    
    [imageView addSubview:retakeBtn];
    
}
-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth:(float)newWidth
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = newWidth/oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void)updateScroll:(UIScrollView*)scroll{
    

    if ((sectionMainView.frame.origin.y + sectionMainView.frame.size.height) > scroll.frame.size.height) {
        CGSize contentSize = scroll.frame.size;
        float newHeight = sectionMainView.frame.origin.y + sectionMainView.frame.size.height + 8;
        contentSize.height = newHeight;
        [scroll setContentSize:contentSize];

    }
    
    
}

-(void)receiptSizeChanged{
    
    CGRect dividerFrame = dividerLine2.frame;
    
    dividerFrame.origin.y = receiptMainView.frame.origin.y + receiptMainView.frame.size.height+8.0;
    [dividerLine2 setFrame:dividerFrame];
    
    CGRect sectionFrame = sectionMainView.frame;
    
    sectionFrame.origin.y = dividerLine2.frame.size.height + dividerLine2.frame.origin.y + 8.0;
    
    [sectionMainView setFrame:sectionFrame];
    
}

-(void)sectionSizeChanged{
    
}

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [longerLabel release];
    [super dealloc];
}
@end
