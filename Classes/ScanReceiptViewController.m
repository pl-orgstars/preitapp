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
    
    PreitAppDelegate* delegate = (PreitAppDelegate*)[UIApplication sharedApplication].delegate;
    
    
    [mainLabel setText:[NSString stringWithFormat:mainLabel.text,[delegate.mallData objectForKey:@"name"]]];
    
    
    [cancelBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [cancelBtn.layer setBorderWidth:1.0];
    
    

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
        [self addRetakeButtonToImageView:receiptImgView withTag:200];
        [self receiptSizeChanged];
        
        [originalImgArray setObject:image forKey:@"receipt"];
        
        if (![originalImgArray objectForKeyWithNullCheck:@"section2"] && ![originalImgArray objectForKey:@"section1"]) {
            
            [section2MainView setFrame:sectionMainView.frame];
        }
        else{
            CGRect frame = section2MainView.frame;
            frame.origin.y = sectionMainView.frame.origin.y + sectionMainView.frame.size.height +16;
            
            [section2MainView setFrame:frame];
        }
        
    }
    
    else{
        
        if (gettingSection1) {
            CGRect sectionImgFrame = sectionImgView.frame;
            sectionImgFrame.size.height = scaledImage.size.height;
            [sectionImgView setFrame:sectionImgFrame];
            [sectionImgView setImage:scaledImage];
            [sectionImgView setHidden:NO];
            
            CGRect mainFrame = sectionMainView.frame;
            mainFrame.size.height = sectionImgView.frame.size.height;
            [sectionMainView setFrame:mainFrame];
            [self addRetakeButtonToImageView:sectionImgView withTag:201];
            
            [originalImgArray setObject:image forKey:@"section1"];
            
            [sectionBtn setHidden:YES];
            [longerLabel setHidden:YES];
            [sectionBtn setEnabled:NO];
            
            CGRect sec2Frame = section2MainView.frame;
            
            sec2Frame.origin.y = sectionMainView.frame.origin.y + sectionMainView.frame.size.height + 16;
            
            [section2MainView setFrame:sec2Frame];
            [section2MainView setHidden:NO];
            [section2MainView setUserInteractionEnabled:YES];
            
        }
        else{
            
            CGRect section2ImgFrame = section2ImgView.frame;
            section2ImgFrame.size.height = scaledImage.size.height;
            [section2ImgView setFrame:section2ImgFrame];
            [section2ImgView setImage:scaledImage];
            [section2ImgView setHidden:NO];
            
            CGRect section2MainFrame = section2MainView.frame;
            section2MainFrame.size.height = section2ImgView.frame.size.height;
            [section2MainView setFrame:section2MainFrame];
            [self addRetakeButtonToImageView:section2ImgView withTag:202];
            
            [originalImgArray setObject:image forKey:@"section2"];
            
            [section2Btn setHidden:YES];
            [section2Btn setEnabled:NO];
            [longerlabel2 setHidden:YES];
            
            
        }
        
   
      
        
        
        
        
        
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
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Choose Source" message:@"Please select the source" delegate:self cancelButtonTitle:@"Camera" otherButtonTitles:@"Photos", nil];
        [alertView show];
    }
    else{
        [self showImagePickerWithSource:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    
}

- (IBAction)getSectionBtnCall:(id)sender {
    gettingReciept = NO;
    gettingSection1 = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Choose Source" message:@"Please select the source" delegate:self cancelButtonTitle:@"Camera" otherButtonTitles:@"Photos", nil];
        [alertView show];
    }
    else{
        [self showImagePickerWithSource:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

-(IBAction)getSection2BtnCall:(UIButton*)sender {
    gettingReciept = NO;
    gettingSection1 = NO;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Choose Source" message:@"Please select the source" delegate:self cancelButtonTitle:@"Camera" otherButtonTitles:@"Photos", nil];
        [alertView show];
    }
    else{
        [self showImagePickerWithSource:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
}


-(IBAction)retakeImage:(UIButton*)sender{
    
    if (sender.tag == 200) {
        [self getReceiptBtnCall:nil];
    }
    else{
        
        if (sender.tag == 201) {
            [self getSectionBtnCall:nil];

        }
        else{
            [self getSection2BtnCall:nil];
        }
    }
    
    [sender removeFromSuperview];
    
}


- (IBAction)uploadBtnCall:(id)sender {
   
    
    if (![originalImgArray objectForKeyWithNullCheck:@"receipt"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Receipt missing" message:@"Please add a receipt" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        [self uploadImageToZiploop];
    }
    
    
}

-(void)uploadImageToZiploop{
    
    NSString* api_key = @"fD5du1vI6Wo";
    NSString* api_secret = @"NPmzuIvIziS";
    
    NSString* userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"votigoUserID"];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    
    [params setValue:api_key forKey:@"api_key"];
    [params setValue:api_secret forKey:@"api_secret"];
    [params setValue:userId forKey:@"customer_id"];
    [params setValue:@"123654" forKey:@"receipt_id"];
    [params setValue:[originalImgArray objectForKey:@"receipt"] forKey:@"file"];
    
    NSString* urlString = @"https://api.ziploop.com/partner/1/upload";
    
    
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self.view addSubview:indicator];
    [indicator startAnimating];
    [indicator setCenter:self.view.center];
    
    [self.view setUserInteractionEnabled:NO];
    
    
    UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@" Something went wrong please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSString* key in [originalImgArray allKeys]) {
            UIImage* image = [originalImgArray objectForKey:key];
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1.0) name:@"file" fileName:[NSString stringWithFormat:@"%@.jpg",key] mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        [indicator removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        if ([responseObject objectForKeyWithNullCheck:@"error"]) {
            [errorAlert show];
            
        }
        else{
//            [self.navigationController popViewControllerAnimated:NO];
            [self imageUploadSuccessful];
        }
        
        
        
        
        NSLog(@"Success:  %@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error : %@",[error localizedDescription]);
        
        [errorAlert show];
        [indicator removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        
    }];
    

    
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

-(void)addRetakeButtonToImageView:(UIImageView*) imageView withTag:(NSInteger)tag{
    
    CGSize btnSize = CGSizeMake(100, 40);
    CGRect frame = CGRectMake(imageView.frame.size.width - btnSize.width, imageView.frame.size.height - btnSize.height, btnSize.width, btnSize.height);
    UIButton* retakeBtn = [[UIButton alloc] initWithFrame:frame];
    [retakeBtn setTitle:@"Retake" forState:UIControlStateNormal];
    [retakeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [retakeBtn setBackgroundColor:[UIColor blackColor]];
    [retakeBtn setTag:tag];
    
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
    

    if ((section2MainView.frame.origin.y + section2MainView.frame.size.height) > scroll.frame.size.height) {
        CGSize contentSize = scroll.frame.size;
        float newHeight = section2MainView.frame.origin.y + section2MainView.frame.size.height + 8;
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


-(void)imageUploadSuccessful{
    
    [originalImgArray removeAllObjects];
    
    [combo setHidden:YES];
    [mainLabel setHidden:YES];
    
    [uploadedView setHidden:NO];
    
    
    [self setLowerView:(UIView*)divider1 upperView:(UIView*)uploadedView];
    
    [takeReceiptBtn setEnabled:YES];
    [takeReceiptBtn setHidden:NO];
    
    receiptImgView.image = nil;
    
    for (UIView* subview in receiptImgView.subviews) {
        [subview removeFromSuperview];
    }
    [receiptImgView setHidden:YES];
    
    CGRect frame = receiptImgView.frame;
    frame = receiptImgView.frame;
    frame.size.height = 171.0;
    [receiptImgView setFrame:frame];
    
    frame = receiptMainView.frame;
    frame.size.height = 171.0;
    [receiptMainView setFrame:frame];
    
    [self setLowerView:(UIView*)receiptMainView upperView:(UIView*)divider1];
    
    [self setLowerView:(UIView*)dividerLine2 upperView:(UIView*)receiptMainView];
    
    sectionImgView.image = nil;
    [sectionImgView setHidden:YES];
    
    for (UIView* subview in sectionImgView.subviews) {
        [subview removeFromSuperview];
    }
    
    [sectionBtn setHidden:NO];
    [sectionBtn setEnabled:YES];
    
    frame = sectionImgView.frame;
    frame.size.height = 171.0;
    [sectionImgView setFrame:frame];
    
    frame = sectionMainView.frame;
    frame.size.height = 171.0;
    [sectionMainView setFrame:frame];
    
    
    [self setLowerView:(UIView*)sectionMainView upperView:(UIView*)dividerLine2];
    
    section2ImgView.image = nil;
    [section2ImgView setHidden:YES];
    
    for (UIView* subview in section2ImgView.subviews) {
        [subview removeFromSuperview];
    }
    
    frame = section2ImgView.frame;
    frame.size.height = 171.0;
    [section2ImgView setFrame:frame];
    
    [section2MainView setHidden:YES];
    [section2MainView setFrame:sectionMainView.frame];
    [section2MainView setUserInteractionEnabled:NO];
    
    [section2Btn setHidden:NO];
    [section2Btn setEnabled:YES];
    
    [longerLabel setHidden:NO];
    
    
    [self updateScroll:mainScroll];

    
}

-(void)setLowerView:(UIView*)lower upperView:(UIView*)upper{
    CGRect frame = lower.frame;
    
    frame.origin.y = upper.frame.origin.y + upper.frame.size.height + 8.0;
    
    [lower setFrame:frame];
}

- (void)dealloc {
    [longerLabel release];
    [super dealloc];
}
@end
