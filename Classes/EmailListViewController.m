//
//  EmailListViewController.m
//  Preit
//
//  Created by sameer on 16/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EmailListViewController.h"
#import "RequestAgent.h"
#import "JSON.h"

#import "ASIFormDataRequest.h"
@implementation EmailListViewController
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.13;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
CGFloat animatedDistance;


@synthesize productsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        delegate=(PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
//        self.title = @"Email List";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - Check for validation

-(BOOL)checkForEmptyString:(NSString*)checkString {
    for (int i=0; i<checkString.length; i++) {
        if ([checkString characterAtIndex:i]!=' ') {
            return NO;
        }
    }
    return YES;
}

-(BOOL)validateEmail: (NSString *) candidate {
    
    NSString *emailRegex = @"(?:[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}" @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[A-Za-z0-9](?:[a-" @"z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\\[(?:(?:25[0-5" @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" @"9][0-9]?|[A-Za-z0-9-]*[A-Za-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    BOOL result = [emailTest evaluateWithObject:candidate];
    
    return result;
    
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addToolBar];
    
    [self setNavigationTitle:@"Email List" withBackButton:YES];
//    [cellPhoneNo setUserInteractionEnabled:isUpdate];
//    [self.tabBarController setHidesBottomBarWhenPushed:YES];
    // Do any additional setup after loading the view from its nib.
}
-(void)segmentedControlHandler:(UISegmentedControl *)segment{
    if ((int)[segment selectedSegmentIndex] == 0) {
        [name becomeFirstResponder];
    }else{
        [emailAddress becomeFirstResponder];
    }
}
-(void)userClickedDone:(id)sender{
    [name resignFirstResponder];
    [emailAddress resignFirstResponder];
}
-(void)addToolBar{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    
    
    NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
    
    
    tabNavigation = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Previous", @"Next", nil]];
    tabNavigation.segmentedControlStyle = UISegmentedControlStyleBar;
    [tabNavigation setEnabled:YES forSegmentAtIndex:0];
    [tabNavigation setEnabled:YES forSegmentAtIndex:1];
    tabNavigation.momentary = YES;
    [tabNavigation addTarget:self action:@selector(segmentedControlHandler:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *barSegment = [[UIBarButtonItem alloc] initWithCustomView:tabNavigation];
    
    [itemsArray addObject:barSegment];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [itemsArray addObject:flexButton];
    
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(userClickedDone:)];
    [itemsArray addObject:doneButton];
    
    toolbar.items = itemsArray;
    
    
    
    emailAddress.inputAccessoryView = toolbar;
    name.inputAccessoryView = toolbar;
}
-(void)loadWebView{
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@?list=",NSLocalizedString(@"EMAILLISTAPI", @"")];
    
    int i = 0;
    for (Product *p in productsArray) {
        if (i==0) {
            [urlString appendFormat:@"%@_%@",p.accountId,p.productId];
        } else {
            [urlString appendFormat:@",%@_%@",p.accountId,p.productId];
        }
        i++;
    }
    NSLog(@"urlstring %@",urlString);
    
    
    //    NSURLRequest *reqobj = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlString]];
    
    
    
    //kk brgins
    NSMutableString *urlStringss = [NSMutableString stringWithFormat:@"%@",NSLocalizedString(@"EMAILLISTAPI", @"")];
    NSMutableString *strr = [NSMutableString stringWithFormat:@"&list="];
    i = 0;
    for (Product *p in productsArray) {
        if (i==0) {
            [strr appendFormat:@"%@",p.productId];
        } else {
            [strr appendFormat:@",%@_%@",p.accountId,p.productId];
        }
        i++;
    }
    NSLog(@"reqbody %@\nurlstr %@",strr,urlStringss);
    
    NSURL *urls = [NSURL URLWithString:urlStringss];
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:urls];
    //
    //    // POST the username password
    
    //    [requestObj setHTTPMethod:@"POST"];
    [requestObj setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //    [requestObj setHTTPBody:@""];
    //    [requestObj setHTTPBody:[@"email=kuldeep_but@yahoo.com"  dataUsingEncoding: NSUTF8StringEncoding]];
    [requestObj setHTTPBody:[strr dataUsingEncoding: NSUTF8StringEncoding]];
    [requestObj setValue:[NSString stringWithFormat:@"%d",[strr length] ] forHTTPHeaderField:@"Content-Length"];
    
    
    
    
    [requestObj setHTTPMethod:@"POST"];
    
    NSData *data = [strr dataUsingEncoding: NSUTF8StringEncoding];
    [requestObj setHTTPBody:data];
    //
    // Load the request
    webview.delegate = self;
    
    NSLog(@":::::::%@ %@ %@",urlStringss,strr,requestObj);
    //    NSURL *url = [NSURL URLWithString:urlString];
    //    NSURLRequest *requests = [[NSURLRequest alloc] initWithURL:url];
    [webview loadRequest:requestObj];
    
    
    //    [webview loadRequest:reqobj];
    [spinner startAnimating];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [webview setDelegate:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



-(BOOL)chageButtnImage:(id)sender forFlag:(BOOL)flag{
    
    UIButton *bttn = (UIButton *)sender;
    if (flag) {
        [bttn setImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
        return NO;
    }else{
        [bttn setImage:[UIImage imageNamed:@"tic.png"] forState:UIControlStateNormal];
        return YES;
    }
    
}

#pragma mark - Button methods

-(IBAction)subscribeBttnTapped:(id)sender{
    
    isSubscribe = [self chageButtnImage:sender forFlag:isSubscribe];
}
-(IBAction)updateBttnTapped:(id)sender{
    isUpdate = [self chageButtnImage:sender forFlag:isUpdate];
//    [cellPhoneNo setUserInteractionEnabled:isUpdate];
}
-(IBAction)sendListBttnTaped:(id)sender{
    BOOL flag = NO;
    [name resignFirstResponder];
    [emailAddress resignFirstResponder];
    
    if ([self checkForEmptyString:name.text]||[self checkForEmptyString:emailAddress.text]) {
        flag = YES;
    }
//    if (isUpdate ){
//        if ([self checkForEmptyString:cellPhoneNo.text]) {
//            flag = YES;
//        }
//    }
    
    if (flag == YES) {
        [delegate showAlert:@"Please fill out all of the necessary information." title:@"Form is incomplete." buttontitle:@"Back"];
    }
    
    else{
//        [self demoRequest];
        if ([self validateEmail:emailAddress.text]) {
            [self requestEmailExtra];
        }
        else{
            [delegate showAlert:@"Enter Valid email id" title:@"Form is incomplete." buttontitle:@"Back"];
        }
        
//        [self request];
    }
    
    
    
    
}

#pragma mark - Request for Email

-(void)requestEmailExtra{
    
    alertView = [[UIAlertView alloc] initWithTitle:@"Sending..."
                                           message:@"\n"
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];
    UIActivityIndicatorView *spinnr = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinnr.center = CGPointMake(139.5, 75.5); // .5 so it doesn't blur
    [alertView addSubview:spinnr];
    [spinnr startAnimating];
    [alertView show];
    
    RequestAgent *req = [[RequestAgent alloc]init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
   
    [dict setValue:name.text forKey:@"name"];
    [dict setValue:emailAddress.text forKey:@"email"];
    [dict setValue:[NSString stringWithFormat:@"%ld",delegate.mallId] forKey:@"property_id"];
    if (isSubscribe) {
        [dict setValue:@"1" forKey:@"subscribe"];
    }
    
    if (isUpdate) {
        [dict setValue:@"1" forKey:@"yes_sms"];
//        [dict setValue:cellPhoneNo.text forKey:@"cell_number"];
    }

    NSMutableArray *arr = [NSMutableArray new];
    for (Product *p in productsArray) {
        NSString *price = [NSString stringWithFormat:@"%d",(int)p.price];
        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:p.title,@"name",p.desc,@"description",price,@"price",p.store,@"site_name",p.imageUrl,@"image_url", nil];
        [arr addObject:dict];
    }
    
    [dict setValue:arr forKey:@"list"];
    

    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@",NSLocalizedString(@"EMAILLISTAPI", @"")];
    
    NSLog(@"request body %@",[dict JSONRepresentation]);
    NSLog(@"url string == %@",urlString);
    
    [req postEmailList:self callBackSelector:@selector(requestSuccess:) errorSelector:@selector(requestError:) Url:urlString postDict:dict];


}

/*
-(void)request{
    RequestAgent *req = [[RequestAgent alloc]init];
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@?name=%@&email=%@&property_id=%ld",NSLocalizedString(@"EMAILLISTAPI", @""),name.text,emailAddress.text,delegate.mallId];
    
//    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@",NSLocalizedString(@"EMAILLISTAPI", @"")];
//    
//    NSMutableDictionary *dict = [NSMutableDictionary new];
//    [dict setObject:name.text forKey:@"name"];
//    [dict setObject:emailAddress.text forKey:@"email"];
//    [dict setObject:[NSString stringWithFormat:@"%ld", delegate.mallId] forKey:@"property_id"];
//    
//    if (isSubscribe) {
//        
//        [dict setObject:@"1" forKey:@"subscribe"];
//    }
//    if (isUpdate) {
//        //        [urlString appendFormat:@"&yes_sms=/'1/'&cell_number=%@",cellPhoneNo.text];
//        [dict setObject:@"1" forKey:@"yes_sms"];
//        [dict setObject:cellPhoneNo.text forKey:@"cell_number"];
//    }
//    
    
    
    
//    NSMutableString *listdata = [NSMutableString new];
//    
//    if (isSubscribe) {
//        
//        //        [dict setObject:@"1" forKey:@"subscribe"];
//        [listdata appendFormat:@"subscribe=1"];
//    }
//    if (isUpdate) {
//        [listdata appendFormat:@"&yes_sms=1&cell_number=%@",cellPhoneNo.text];
//        //        [dict setObject:@"1" forKey:@"yes_sms"];
//        //        [dict setObject:cellPhoneNo.text forKey:@"cell_number"];
//    }
//    
//    [listdata appendFormat:@"list=({"];
//    int i=0;
//    for (Product *p in productsArray) {
//        if (i==0) {
//            [listdata appendFormat:@"name=%@",p.title];
//            [listdata appendFormat:@"&description=%@",p.desc];
//            [listdata appendFormat:@"&price=%f}",p.price];
//            
//        } else {
//            [listdata appendFormat:@",{name=%@",p.title];
//            [listdata appendFormat:@"&description=%@",p.desc];
//            [listdata appendFormat:@"&price=%f}",p.price];
//        }
//        
//        i++;
//    }
//    
//    [listdata appendFormat:@");"];
////    NSLog(@"reqbody \nurlstr %@ list data %@",urlString,listdata);
//    
//    //    NSString *ll = @"shopping_list[][name]=\"Lawnmower\"&shopping_list[][description]=\"This is a nice lawnmower.\"&shopping_list[][price]=399.80&shopping_list[][name]=\"Coffee cup\"&Shopping_list[][description]=\"Drink out of me\"&shopping_list[][price]=5.99";
//    
//    
//    req.isPost = YES;
//    //    req.requestBody = [req stringFromDictionary:dict];
//    req.requestBody = [NSString stringWithFormat:@"name=%@&email=%@&property_id=%ld",name.text,emailAddress.text,delegate.mallId];
    
    NSLog(@"url new:::::: %@ %@",urlString,req.requestBody);
    [req requestToServer:self callBackSelector:@selector(requestSuccess:) errorSelector:@selector(requestError:) Url:urlString];
}
-(void)requestForEmail{
    
    alertView = [[UIAlertView alloc] initWithTitle:@"Sending..."
                                           message:@"\n"
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];
    
    
    UIActivityIndicatorView *spinnr = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinnr.center = CGPointMake(139.5, 75.5); // .5 so it doesn't blur
    [alertView addSubview:spinnr];
    [spinnr startAnimating];
    [alertView show];
    
    RequestAgent *req = [[RequestAgent alloc]init];

    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@",NSLocalizedString(@"EMAILLISTAPI", @"")];
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:name.text forKey:@"name"];
    [dict setObject:emailAddress.text forKey:@"email"];
    [dict setObject:[NSString stringWithFormat:@"%ld", delegate.mallId] forKey:@"property_id"];
    
    if (isSubscribe) {

        [dict setObject:@"1" forKey:@"subscribe"];
    }
    if (isUpdate) {
//        [urlString appendFormat:@"&yes_sms=/'1/'&cell_number=%@",cellPhoneNo.text];
        [dict setObject:@"1" forKey:@"yes_sms"];
//        [dict setObject:cellPhoneNo.text forKey:@"cell_number"];
    }

    

//    int i=0;
    NSMutableArray *arr = [NSMutableArray new];
    for (Product *p in productsArray) {
//        if (i==0) {
        NSString *price = [NSString stringWithFormat:@"%f",p.price];
            NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:p.title,@"name",p.desc,@"description",price,@"price", nil];
        [arr addObject:dict];
//            [listdata appendFormat:@"name=%@",p.title];
//            [listdata appendFormat:@"&description=%@",p.desc];
//            [listdata appendFormat:@"&price=%f}",p.price];

//        } else {
//            [listdata appendFormat:@",{name=%@",p.title];
//            [listdata appendFormat:@"&description=%@",p.desc];
//            [listdata appendFormat:@"&price=%f}",p.price];
//        }
//        
//        i++;
    }
//    NSMutableDictionary *dd = [NSMutableDictionary new];
//    [dd setObject:arr forKey:@"list"];
    
//    NSString *str = [arr JSONRepresentation];
    [dict setObject:arr forKey:@"list"];
//    [listdata appendFormat:@");"];
    NSLog(@"reqbody \nurlstr %@",dict);

//    NSString *ll = @"shopping_list[][name]=\"Lawnmower\"&shopping_list[][description]=\"This is a nice lawnmower.\"&shopping_list[][price]=399.80&shopping_list[][name]=\"Coffee cup\"&Shopping_list[][description]=\"Drink out of me\"&shopping_list[][price]=5.99";
    
    
//    req.isPost = YES;
//    req.requestBody = [req stringFromDictionary:dict];
    

//    req.requestBody = [NSString stringWithFormat:@"%@",dict];
    
    //[NSString stringWithFormat:@"name=%@&email=%@&property_id=%ld",name.text,emailAddress.text,delegate.mallId];
    
//    NSLog(@"url new:::::: %@",req.requestBody);
//    [req requestToServer:self callBackSelector:@selector(requestSuccess:) errorSelector:@selector(requestError:) Url:urlString];
    
//    NSDictionary *postDict;
    
    NSLog(@"dict to post %@",dict);
    NSString *postStr = [NSString stringWithFormat:@"name=kuldeep&email=kuldeep_but@yahoo.com&property_id=42&subscribe=1&yes_sms=1&cell_number=123456789&list=h"];
    
    req.isPost = YES;
    
    req.requestBody = postStr;
    
    [req requestToServer:self callBackSelector:@selector(requestSuccess:) errorSelector:@selector(requestError:) Url:urlString];

    
//    [req postEmailList:self callBackSelector:@selector(requestSuccess:) errorSelector:@selector(requestError:) Url:urlString postDict:dict];
    
}

*/
-(void)requestSuccess:(NSData*)responseData{

    
    
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    NSString *strings = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"responsestr  %@",strings);
    
    
    [delegate showAlert:@"Your shopping list was successfully send via email." title:@"Success" buttontitle:@"Continue"];
}
-(void)requestError:(NSError *)error
{
    
    
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    NSLog(@"requestError");
    [delegate showAlert:@"Somthing went wrong. Please try again later" title:@"Sorry" buttontitle:@"Continue"];
    
}

#pragma mark
#pragma mark Textfield-delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSLog(@"return %d",textField.tag);
    [textField resignFirstResponder];
    return YES;
}

//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//    [textField resignFirstResponder];
//    return YES;
//}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [scrollView setContentSize:CGSizeMake(320, 700)];
    
    NSLog(@"textFieldDidBeginEditing");
    if (textField == name) {
        [tabNavigation setEnabled:NO forSegmentAtIndex:0];
        [tabNavigation setEnabled:YES forSegmentAtIndex:1];
    }else{
        [tabNavigation setEnabled:YES forSegmentAtIndex:0];
        [tabNavigation setEnabled:NO forSegmentAtIndex:1];
        
    }

    
    
    
	CGRect textFieldRect =
	[self.view.window convertRect:textField.bounds fromView:textField];
	CGRect viewRect =
	[self.view.window convertRect:self.view.bounds fromView:self.view];
    
	CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
	CGFloat numerator =
	midline - viewRect.origin.y
	- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
	CGFloat denominator =
	(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
	* viewRect.size.height;
	CGFloat heightFraction = numerator / denominator;
	if (heightFraction < 0.0)
	{
		heightFraction = 0.0;
        
	}
	else if (heightFraction > 1.0)
	{
		heightFraction = 1.0;
        
	}
	UIInterfaceOrientation orientation =
	[[UIApplication sharedApplication] statusBarOrientation];
    
	if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
        
	}
	else
	{
		animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
	}
	CGRect viewFrame = self.view.frame;
	viewFrame.origin.y -= animatedDistance;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	[self.view setFrame:viewFrame];
	[UIView commitAnimations];
    
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [scrollView setContentSize:CGSizeMake(320, 0)];
	CGRect viewFrame = self.view.frame;
	viewFrame.origin.y += animatedDistance;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	[self.view setFrame:viewFrame];
	[UIView commitAnimations];
    
}

#pragma mark - webviewdelegate

-(void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"start load");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [spinner stopAnimating];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:@"Message" message:@"Some error occured. Please try later" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil]  show];
    [spinner stopAnimating];
}




/////////////////////extra

@end
