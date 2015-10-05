//
//  JobsDetailViewController.m
//  Preit
//
//  Created by Noman iqbal on 10/2/15.
//
//

#import "JobsDetailViewController.h"

@interface JobsDetailViewController ()

@end

@implementation JobsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [storeNameLabel setText:[self.jobDetailDict objectForKey:@"tenant_name"]];
    [positionNameLabel setText:[self.jobDetailDict objectForKey:@"title"]];
    
    NSString * htmlString = [self.jobDetailDict objectForKey:@"description"];
    
    [descriptionView setValue:htmlString forKey:@"contentToHTMLString"];
    descriptionView.font = [UIFont fontWithName:@"ProximaNova-Regular" size:18.0];
    [descriptionView setTextColor:[UIColor whiteColor]];
    [descriptionView setEditable:NO];
    [descriptionView setScrollEnabled:NO];
    
   
    
    
    htmlString = [self.jobDetailDict objectForKey:@"contact"];
    
    [contactInfoView setValue:htmlString forKey:@"contentToHTMLString"];
    [contactInfoView setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:18.0]];
    [contactInfoView setTextColor:[UIColor whiteColor]];
    [contactInfoView setEditable:NO];
    [contactInfoView setScrollEnabled:NO];
    
    
    
    
    [self setFrameSizeOfTextView:descriptionView];
    
    CGRect dividerFrame = dividerLine.frame;
    dividerFrame.origin.y = descriptionView.frame.origin.y + descriptionView.frame.size.height + 8.0;
    [dividerLine setFrame:dividerFrame];
    
    [self setFrameSizeOfTextView:contactInfoView];
    
    CGRect contactFrame = contactInfoView.frame;
    
    contactFrame.origin.y = dividerLine.frame.origin.y + dividerLine.frame.size.height + 8.0;
    
    [contactInfoView setFrame:contactFrame];
    
    
    [self setContentSizeOfScrollView];
    
 
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
- (IBAction)menuBtnCall:(id)sender {
    
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;

}

- (IBAction)backBtnCall:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - set size and frames

-(void)setContentSizeOfScrollView
{
    if ((contactInfoView.frame.origin.y + contactInfoView.frame.size.height) > mainScroll.frame.size.height)  {
        
        CGSize scrollContentSize = mainScroll.frame.size;
        scrollContentSize.height = contactInfoView.frame.origin.y + contactInfoView.frame.size.height + 20;
        
        [mainScroll setContentSize:scrollContentSize];
        
    }
    
}

-(void)setFrameSizeOfTextView:(UITextView*) textView{
    
//    CGSize size = textView.contentSize;
    
    float height = ceilf([textView sizeThatFits:textView.frame.size].height);
    CGRect frame = textView.frame;
    
    frame.size.height = height;
    
    [textView setFrame:frame];
    
}



/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
