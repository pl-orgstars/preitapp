//
//  ProductDetailViewController.m
//  Preit
//
//  Created by sameer on 05/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProductDetailViewController.h"
#import <Twitter/Twitter.h>
#import "PinterestWebViewController.h"


@implementation ProductDetailViewController

#define tagImageView 111

#define xAxis 20

#define font1 [UIFont systemFontOfSize:14]

@synthesize productIndex;
@synthesize productsArray;
@synthesize isShoppingList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated {
//    NSLog(@"url string :::::: %@",self.urlString);
//    [self.navigationItem setTitle:@"Product Detail"];
    [self setNavigationTitle:@"Product Detail" withBackButton:YES];
    
    [listCountLabel setText:[NSString stringWithFormat:@"%d",[dbAgent getCount]]];
    
    if (productIndex == 0) {
        [btnPrev setEnabled:NO];
    } 
    if (productIndex == productsArray.count-1) {
        [btnNext setEnabled:NO];
    }
    
     [self createScrollView:[productsArray objectAtIndex:productIndex]];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setHidesWhenStopped:YES];
    [spinner setCenter:self.view.center];
    [self.view addSubview:spinner];
    [spinner stopAnimating];
    
    delegate = (PreitAppDelegate*)[[UIApplication sharedApplication]delegate];    
    
    dbAgent = [Database sharedDatabase];
    if (!isShoppingList) {
        UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        [barView setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *barImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"date"]];
        CGRect frame = barView.frame;
        frame.origin = CGPointZero;
        [barImageView setFrame:frame];
        [barView addSubview:barImageView];
        listCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(5.5, 0, 20, 20)];
        [listCountLabel setBackgroundColor:[UIColor clearColor]];
        [listCountLabel setTextColor:[UIColor whiteColor]];
        [listCountLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [listCountLabel setTextAlignment:UITextAlignmentCenter];
//        [listCountLabel sizeToFit];
        [barView addSubview:listCountLabel];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                             action:@selector(showShoppingList)];
        [barView addGestureRecognizer:tap];
//        [tap release];
        
        UIBarButtonItem *shoppingListView = [[UIBarButtonItem alloc]initWithCustomView:barView];
        [self.navigationItem setRightBarButtonItem:shoppingListView];
//        [shoppingListView release];
//        [barView release];
    }
    
    imagesArray = [[NSMutableArray alloc]initWithCapacity:productsArray.count];
    for (Product*p in productsArray) {
        UIImageView *imgv = (UIImageView*)[p.imageView viewWithTag:100];
        if (imgv.image==nil) {
            [imagesArray addObject:@"noImage"];
        } else {
            [imagesArray addObject:imgv.image];
        }
    }
        
    
    [productImageView setFrame:CGRectMake(0, 0, 320, 460)];
//    NSLog(@"imagesarr %@",imagesArray);
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - share methods
-(BOOL)checkForEmptyString:(NSString*)checkString {
    for (int i=0; i<checkString.length; i++) {
        if ([checkString characterAtIndex:i]!=' ') {
            return NO;
        }
    }
    return YES;
}

-(void)pinterestShare{
    
    Product *prod = [productsArray objectAtIndex:productIndex];
    NSString *website_url = [delegate.mallData objectForKey:@"website_url"];
    NSString *removeSlash = [[website_url componentsSeparatedByString:@"//"] objectAtIndex:1];
    NSString *pName = [[removeSlash componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString *urlStr = [NSString stringWithFormat:@"http://%@.%@?search=%@",pName, NSLocalizedString(@"MOREINFOAPI", @""),prod.title];
    

    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
//
//    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"-" withString:@"%20"];
//    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"|" withString:@"%20"];
//    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"\"" withString:@"%20"];
    
    
//    urlStr = [self urlEncodeForEscapesForString:urlStr];

//    urlStr = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    NSString *ss = [self tinyUrl:urlStr];
//    if (![self checkForEmptyString:ss]) {
//        urlStr = ss;
////        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"http://" withString:@""];
//    }else{
//        NSLog(@"yyyyyyy");
//    }

    NSLog(@"urlllll %@",urlStr);
    
    PinterestWebViewController *viewCntroller = [[PinterestWebViewController alloc]initWithNibName:@"PinterestWebViewController" bundle:nil];
//    Product *prod = [productsArray objectAtIndex:productIndex];
    [viewCntroller setImageUrl:prod.imageUrl];
    viewCntroller.searchUrl = urlStr;
    viewCntroller.description =  [NSString stringWithFormat:@"%@ from %@", prod.title,[delegate.mallData objectForKey:@"name"]];
    NSLog(@"description %@",[delegate.mallData objectForKey:@"name"]);
    [self.navigationController pushViewController:viewCntroller animated:YES];

}

//-(void)twitterShare{
//
//    Product *prod = [productsArray objectAtIndex:productIndex];
//    NSLog(@"dec:: %@,,%@",prod.desc,prod.title);
//    
//    NSString *website_url = [delegate.mallData objectForKey:@"website_url"];
//    NSString *removeSlash = [[website_url componentsSeparatedByString:@"//"] objectAtIndex:1];
//    NSString *pName = [[removeSlash componentsSeparatedByString:@"."] objectAtIndex:0];
//    NSString *urlStr = [NSString stringWithFormat:@"http://%@.%@",pName, NSLocalizedString(@"MOREINFOAPI", @"")];
//    
//    NSLog(@"urlstring %@",urlStr);
//    NSURL *url = [NSURL URLWithString:urlStr];
//    
//    
//    
//    
//    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:prod.imageUrl]]];
////    NSURL *img = [NSURL URLWithString:prod.imageUrl];
//    //        NSString *message = prod.title;
//    //        NSURL *url = [NSURL URLWithString:@"http://cherryhillmall.red5demo.com/product_search/"];
//    
//    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
//        
//        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
//        
//        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
//            if (result == SLComposeViewControllerResultCancelled) {
//                
//                NSLog(@"Cancelled");
//                
//            } else
//                
//            {
//                NSLog(@"Done");
//            }
//            
//            [controller dismissViewControllerAnimated:YES completion:Nil];
//        };
//        
//
//        
//        
//        
//        
//        
//        controller.completionHandler =myBlock;
//        
//        //Adding the Text to the facebook post value from iOS
////        [controller setInitialText:@"Test Post from mobile.safilsunny.com"];
//        
//        //Adding the URL to the facebook post value from iOS
//        
////        [controller addURL:[NSURL URLWithString:@"http://www.mobile.safilsunny.com"]];
//        
//        //Adding the Image to the facebook post value from iOS
//        
////        [controller addImage:[UIImage imageNamed:@"fb.png"]];
//        
//        
//        [controller setInitialText:[NSString stringWithFormat:@"%@ from %@", prod.title,pName]];
//        
//        NSLog(@"image::%@,url %@",prod.imageUrl,url);
//        
//        
//        
//        [controller addURL:url];
////        [controller addURL:img];
//        [controller addImage:img];
//        
//        //                [twc addURL:[NSURL URLWithString:@""]];
//        //
////        [self presentModalViewController:controller animated:YES];
//
//        
//        
//        
//        
//        
//        [self presentViewController:controller animated:YES completion:Nil];
//        
//    }
//    else{
//        NSLog(@"UnAvailable");
//    }
//}
-(void)twitterShareDemo{
    int length = 0;
    
    Product *prod = [productsArray objectAtIndex:productIndex];
    NSString *message = prod.title;
    
    NSString *website_url = [delegate.mallData objectForKey:@"website_url"];
    NSString *removeSlash = [[website_url componentsSeparatedByString:@"//"] objectAtIndex:1];
    NSString *pName = [[removeSlash componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString *urlStr = [NSString stringWithFormat:@"http://%@.%@?search=%@",pName, NSLocalizedString(@"MOREINFOAPI", @""),prod.title];
    urlStr = [self urlEncodeForEscapesForString:urlStr];
    
    NSString *ss = [self tinyUrl:urlStr];
    if (![self checkForEmptyString:ss]) {
        urlStr = ss;
    }else{
        NSLog(@"yyyyyyy");
    }

    length += (int)urlStr.length;
    
    NSLog(@"urlstring %@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString *imgeUrll = prod.imageUrl;//= [self tinyUrl:prod.imageUrl];
//    if ([self checkForEmptyString:imgeUrll]) {
//
//        imgeUrll = prod.imageUrl;
//    }
    length += (int)imgeUrll.length;

    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgeUrll]];
//    UIImage *image = [UIImage imageWithData:];
    
    //    NSURL *url = [NSURL URLWithString:@"http://cherryhillmall.red5demo.com/product_search/"];
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultCancelled) {
            
            NSLog(@"Cancelled");
            
        } else
            
        {
            NSLog(@"Done");
        }
        
        [controller dismissViewControllerAnimated:YES completion:Nil];
    };
    controller.completionHandler =myBlock;
    
    //Adding the Text to the facebook post value from iOS
    //    NSString *text = [shareDict objectForKey:@"shareText"];//@"Merchant Name\nMerhcant Address\nCoupon title on the mobi724 mobile app\nMobi724\nCoupon description\n";
    
    //Adding the URL to the facebook post value from iOS
    
    // [controller addURL:[NSURL URLWithString:@"http://www.facebook.com/pages/Watchcompanionevontest-Community/633595583323114"]];
    //    [controller setEditing:NO];
    
    //    NSString *text = @"hi ";
    
    //Adding the Image to the facebook post value from iOS
    
    //[controller addImage:[UIImage imageNamed:@"fb.png"]];
    
    NSLog(@"length :::::%d",length);

    length = ((NSString*)[delegate.mallData objectForKey:@"name"]).length;
    NSLog(@"length :::::%d",length);
    NSLog(@"length %@",[delegate.mallData objectForKey:@"name"]);
    if (length>0 && length<61) {
        if ((int)message.length < (58-length+9)) {
            //        [controller setInitialText:[NSString stringWithFormat:@"%@ from %@", message,pName]];
        }else{
            NSLog(@"short the message::");
            message = [message substringToIndex:(59-length+9)];
            message = [NSString stringWithFormat:@"%@-",message];
        }

    }
    
    
    [controller addURL:url];
    [controller addImage:[UIImage imageWithData:data]];
    
    [controller setInitialText:[NSString stringWithFormat:@"%@ from %@", message,[delegate.mallData objectForKey:@"name"]]];
    NSLog(@"from %@",[delegate.mallData objectForKey:@"name"]);
    [self presentViewController:controller animated:YES completion:Nil];
}
//-(void)twitterShare2{
//    
//    
//    Class twClass = NSClassFromString(@"TWTweetComposeViewController");
//    if (!twClass){ // Framework not available, older iOS
//    }
//    else
//    {
//        //                if ([TWTweetComposeViewController canSendTweet]) // Check if twitter is setup and reachable
//        
//        //                {
//        
//        NSString *website_url = [delegate.mallData objectForKey:@"website_url"];
//        NSString *removeSlash = [[website_url componentsSeparatedByString:@"//"] objectAtIndex:1];
//        NSString *pName = [[removeSlash componentsSeparatedByString:@"."] objectAtIndex:0];
//        NSString *urlStr = [NSString stringWithFormat:@"http://%@.%@",pName, NSLocalizedString(@"MOREINFOAPI", @"")];
//        NSLog(@"urlstring %@",urlStr);
//        NSURL *url = [NSURL URLWithString:urlStr];
//        
//        Product *prod = [productsArray objectAtIndex:productIndex];
//        NSLog(@"dec:: %@,,%@",prod.desc,prod.title);
//        NSString *message = prod.title;
////        NSURL *url = [NSURL URLWithString:@"http://cherryhillmall.red5demo.com/product_search/"];
//        TWTweetComposeViewController *twc = [[TWTweetComposeViewController alloc] init];
//        [twc setInitialText:[NSString stringWithFormat:@"%@ from %@", prod.title,pName]];
//
//        NSLog(@"image::%@,url %@",prod.imageUrl,url);
//        
//        
//        
//        [twc addURL:url];
//        [twc addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:prod.imageUrl]]]];
//        
//        //                [twc addURL:[NSURL URLWithString:@""]];
//        //
//        [self presentModalViewController:twc animated:YES];
//        
//        
//    }
//}

-(NSString *)urlEncodeForEscapesForString:(NSString *)urlString{
    //    NSLog(@"urlStringurlString===========%@",urlString);
    
    NSString *trimmedString = [urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
	return [trimmedString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    //            AddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(void)faceBookShare{
    

    NSLog(@"mall data %@",delegate.mallData);
    
    //    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:self.message,@"shareText", nil];
    //    [ShareAgent shareOnFB:self shareDict:dict];
    //    ShareAgent *share = [[ShareAgent alloc]init];
    //    share.viewController = self;
    //    [share getFriendListToshareWithFaceBook:self];
    Product *prod = [productsArray objectAtIndex:productIndex];
    NSString *message = prod.title;
    
//    NSURL* url = [NSURL URLWithString:[strURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *website_url = [delegate.mallData objectForKey:@"website_url"];
    NSString *removeSlash = [[website_url componentsSeparatedByString:@"//"] objectAtIndex:1];
    NSString *pName = [[removeSlash componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString *urlStr = [NSString stringWithFormat:@"http://%@.%@?search=%@",pName, NSLocalizedString(@"MOREINFOAPI", @""),prod.title];
    urlStr = [self urlEncodeForEscapesForString:urlStr];
    
//    NSLog(@"ttttttt %@",t);

    NSString *ss = [self tinyUrl:urlStr];
    if (![self checkForEmptyString:ss]) {
        urlStr = ss;
    }else{
        NSLog(@"yyyyyyy");
    }
    

    NSLog(@"dfnjkdsf %@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];

    
    
//    NSURL *url = [NSURL URLWithString:@"http://cherryhillmall.red5demo.com/product_search/"];
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];

    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultCancelled) {
            
            NSLog(@"Cancelled");
            
        } else
            
        {
            NSLog(@"Done");
        }
        
        [controller dismissViewControllerAnimated:YES completion:Nil];
    };
    controller.completionHandler =myBlock;

    //Adding the Text to the facebook post value from iOS
    //    NSString *text = [shareDict objectForKey:@"shareText"];//@"Merchant Name\nMerhcant Address\nCoupon title on the mobi724 mobile app\nMobi724\nCoupon description\n";
    
    //Adding the URL to the facebook post value from iOS
    
    // [controller addURL:[NSURL URLWithString:@"http://www.facebook.com/pages/Watchcompanionevontest-Community/633595583323114"]];
    //    [controller setEditing:NO];
    
    //    NSString *text = @"hi ";
    
    //Adding the Image to the facebook post value from iOS
    
    //[controller addImage:[UIImage imageNamed:@"fb.png"]];
    
    
    [controller setInitialText:[NSString stringWithFormat:@"%@ from %@", message,[delegate.mallData objectForKey:@"name"]]];
     NSLog(@"addURL %@",[delegate.mallData objectForKey:@"name"]);
    [controller addURL:url];
    [controller addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:prod.imageUrl]]]];
    [self presentViewController:controller animated:YES completion:Nil];
}
-(NSString *)tinyUrl:(NSString *)origUrl{
    NSLog(@"origna %@",origUrl);

    origUrl = [origUrl stringByReplacingOccurrencesOfString:@"-" withString:@"%20"];
    origUrl = [origUrl stringByReplacingOccurrencesOfString:@"|" withString:@"%20"];
    origUrl = [origUrl stringByReplacingOccurrencesOfString:@"\"" withString:@"%20"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", origUrl]];
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tinyurl.com/api-create.php?url=%@", origUrl]];
    
    NSURLRequest *request = [ NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestReloadIgnoringCacheData
                                          timeoutInterval:10.0 ];
    NSError *error;
    NSURLResponse *response;
    NSData *myUrlData = [ NSURLConnection sendSynchronousRequest:request
                                               returningResponse:&response
                                                           error:&error];
    NSString *myTinyUrl = [[NSString alloc] initWithData:myUrlData encoding:NSUTF8StringEncoding];
    NSLog(@"tiitititiitit %@",myTinyUrl);
    return myTinyUrl;
    
    
    
    //////
//    NSString *urlstr = origUrl ;///here put your URL in string
////    [urlstr retain];
//    NSString *apiEndpoint = [NSString stringWithFormat:@"http://ggl-shortener.appspot.com/?url=%@",urlstr];
////    [apiEndpoint retain];
//    
//    NSLog(@"\n\n APIEndPoint : %@",apiEndpoint);
//    NSString *shortURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiEndpoint]
//                                                  encoding:NSASCIIStringEncoding
//                                                     error:nil];
//    shortURL = [shortURL stringByReplacingOccurrencesOfString:@"{\"short_url\":\"" withString:@""];
//    shortURL = [shortURL stringByReplacingOccurrencesOfString:@"\",\"added_to_history\":false}" withString:@""];
////    [shortURL retain];
//    NSLog(@"Long: %@ - Short: %@",urlstr,shortURL);
//    return shortURL;
    
    
//    NSString *urlstr =[origUrl stringByReplacingOccurrencesOfString:@" " withString:@""];///your url string
//    urlstr = [urlstr stringByReplacingOccurrencesOfString:@"-" withString:@"%20"];
//    urlstr = [urlstr stringByReplacingOccurrencesOfString:@"|" withString:@"%20"];
////    [urlstr retain];
//    NSString *apiEndpoint = [NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@",urlstr];
////    [apiEndpoint retain];
//    
//    NSLog(@"\n\n APIEndPoint : %@",apiEndpoint);
//    NSString *shortURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiEndpoint]
//                                                  encoding:NSASCIIStringEncoding
//                                                     error:nil];
////    [shortURL retain];
//    NSLog(@"Long: %@ - Short: %@",urlstr,shortURL);
//    return shortURL;
}

#pragma mark - button metthod
-(void)pinterestBttnTapped:(id)sender{
    [self pinterestShare];
}

-(void)facebookBttnTapped:(id)sender{
    [self faceBookShare];
}
-(void)twiterBttnTapped:(id)sender{
//    [self twitterShare];
    [self twitterShareDemo];
}
#pragma mark - create scroll view

-(void)createScrollView:(Product *) objectToBeUsed
{
    
    for (UIView *view in [scrollProductDetail subviews]) {
        [view removeFromSuperview];
    }
    
    //name
    
    UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(xAxis,57,253,20)];
    [name setText:objectToBeUsed.title];
    name.tag=1000;
    [name setTextColor:[UIColor grayColor]];
    name.lineBreakMode = UILineBreakModeWordWrap;
    name.numberOfLines = 0;
    name.font = [UIFont boldSystemFontOfSize:15];
    [name setBackgroundColor:[UIColor clearColor]];
    CGSize maximumLabelSize1 = CGSizeMake(253,300);
    CGSize expectedLabelSize1 = [name.text sizeWithFont:name.font constrainedToSize:maximumLabelSize1 lineBreakMode:UILineBreakModeWordWrap];
    CGRect make1=name.frame;
    make1.size.height=expectedLabelSize1.height;
    name.frame=make1;
    [name sizeToFit];
    [scrollProductDetail addSubview:name];
    float y=name.frame.size.height+name.frame.origin.y;
    
    // store
    UILabel *store=[[UILabel alloc]initWithFrame:CGRectMake(180 , y + 10, 170, 21)];

    
//    UIButton *storeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [storeBtn setBackgroundColor:[UIColor redColor]];
//    [storeBtn setFrame:store.frame];
//    [storeBtn addTarget:self action:@selector(showStore) forControlEvents:UIControlEventTouchUpInside];

    [store setBackgroundColor:[UIColor clearColor]];
    store.textAlignment = UITextAlignmentLeft;
    [store setFont:[UIFont boldSystemFontOfSize:15]];
    [store setTextColor:[UIColor blackColor]];
    
    if (self.isShoppingList) {
        
        NSArray *stringArray = [objectToBeUsed.store componentsSeparatedByString:@"-"];
        
        NSString *retailerNameString = [[stringArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [store setText:retailerNameString];
        
    }else{
        
        [store setText:objectToBeUsed.retailerName];
    }
//    [store setText:@"Very long store name that may not be adjusted in the label"];
    store.tag=1001;
    store.lineBreakMode = UILineBreakModeWordWrap;
    store.numberOfLines = 0;
    CGSize maximumLabelSize2 = CGSizeMake(170,50);
    CGSize expectedLabelSize2 = [store.text sizeWithFont:store.font constrainedToSize:maximumLabelSize2 lineBreakMode:UILineBreakModeWordWrap];
    
    CGRect make2=store.frame;
    make2.size.height=expectedLabelSize2.height;
    store.frame=make2;
    [store sizeToFit];
//    store.backgroundColor=[UIColor clearColor];
        
//    [scrollProductDetail addSubview:storeBtn];
//    [storeBtn release];
    
    // Disclosure Button
    UIButton *disclosureBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    CGRect btnFrame= disclosureBtn.frame;
    
    disclosureBtn.tag=1002;
    
    btnFrame.origin.x= 275;
    btnFrame.origin.y=y+4;
    disclosureBtn.frame=btnFrame;
    [disclosureBtn addTarget:self action:@selector(showStore) forControlEvents:UIControlEventTouchUpInside];
    [scrollProductDetail addSubview:disclosureBtn];
    
    make2 = store.frame;
    make2.origin.x = btnFrame.origin.x - store.frame.size.width - 5;
    store.frame = make2;
    
    UITapGestureRecognizer *storeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showStoreTap:)];
    [storeTap setCancelsTouchesInView:NO];
    [store addGestureRecognizer:storeTap];
    [store setBackgroundColor:[UIColor clearColor]];
    [store setUserInteractionEnabled:YES];
//    [storeTap release];
    
    [scrollProductDetail addSubview:store];
    //price
    UILabel *price=[[UILabel alloc]initWithFrame:CGRectMake(name.frame.origin.x , store.frame.origin.y, 71, 21)];
    NSString *priceString = [NSString stringWithFormat:@"$%.2f", objectToBeUsed.price];
    price.textAlignment = UITextAlignmentCenter;
    [price setText:priceString];
    price.tag=1003;
    [price setTextColor:[UIColor blackColor]];
    price.font = [UIFont boldSystemFontOfSize:15];
    CGSize maximumLabelSize3 = CGSizeMake(50,100);
    CGSize expectedLabelSize3 = [price.text sizeWithFont:price.font constrainedToSize:maximumLabelSize3 lineBreakMode:UILineBreakModeWordWrap];
    CGRect make3=price.frame;
    make3.size.height=expectedLabelSize3.height;
    price.frame=make3;
    price.backgroundColor=[UIColor clearColor];
//    [price setText:@"203470237402"];
    [price sizeToFit];
    [scrollProductDetail addSubview:price];
    float y1=price.frame.size.height;
 
    //ImageView
    
//    UIImageView *imgv = (UIImageView*)[objectToBeUsed.imageView viewWithTag:100];
    UIImage *img = [imagesArray objectAtIndex:productIndex];
    CGRect imageFrame;
    imageFrame = CGRectMake(56 , y+y1+30, 185, 185);
    
//    UIView *imageBckView = [[UIView alloc]initWithFrame:imageFrame];
//    [imageBckView setBackgroundColor:[UIColor lightGrayColor]];
//    [scrollProductDetail addSubview:imageBckView];
//    [imageBckView release];
//    
//    imageFrame.origin = CGPointZero;
    
    float y2;
    
    
    NSLog(@"imageurl %@",objectToBeUsed.imageUrl);
    
    if ([img isKindOfClass:[UIImage class]]) {
        UIImageView *imageDetail=[[UIImageView alloc]initWithImage:img];
        
//        imageFrame = [self getFrameForImageWithSize:img.size compareSize:imageFrame.size];
        
        imageDetail.frame = imageFrame;
        y2=imageDetail.frame.size.height;
        imageDetail.backgroundColor=[UIColor clearColor];
        [scrollProductDetail addSubview:imageDetail];
//        [imageBckView addSubview:imageDetail];
        [imageDetail setContentMode:UIViewContentModeScaleAspectFit];
        [imageDetail setBackgroundColor:[UIColor clearColor]];
//        [imageDetail release];
    }
    else {
        DetailAsyncImageVIew *imageDetail=[[DetailAsyncImageVIew alloc]init];
        [imageDetail setProductIndex:productIndex];
        [imageDetail setTag:tagImageView];
        [imageDetail loadImageFromURL:[NSURL URLWithString:objectToBeUsed.imageUrl] delegate:self requestSelector:@selector(imageDownloaded:)];
        imageDetail.frame = imageFrame;
        y2=imageDetail.frame.size.height;
        imageDetail.backgroundColor=[UIColor clearColor];
        [scrollProductDetail addSubview:imageDetail];
//        [imageBckView addSubview:imageDetail];
        [imageDetail setBackgroundColor:[UIColor clearColor]];
//        [imageDetail release];
    }
    
//    imageFrame = imageBckView.frame;
        
    // show button
     //removed zoom button
//    UIButton *showButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnFrame = CGRectZero;
//    btnFrame.origin.y = imageFrame.origin.y + imageFrame.size.height/2; 
//    btnFrame.origin.x = imageFrame.origin.x + imageFrame.size.width + 35;
//    [showButton setFrame:btnFrame];
//    [showButton setTitle:@"showImage" forState:UIControlStateNormal];
    
   
//    UIImage *zoomImage = [UIImage imageNamed:@"zoom.png"];
//    [showButton setBackgroundImage:zoomImage forState:UIControlStateNormal];
//    btnFrame.size = zoomImage.size;
//    [showButton setFrame:btnFrame];
//    [showButton addTarget:self action:@selector(showImage) forControlEvents:UIControlEventTouchUpInside];
//    [scrollProductDetail addSubview:showButton];
    
    //description
    UILabel *desc=[[UILabel alloc]initWithFrame:CGRectMake(xAxis , imageFrame.origin.y + imageFrame.size.height + 20,253,20)];
    desc.textAlignment = UITextAlignmentLeft;
    [desc setText:objectToBeUsed.desc];
    [desc setTextColor:[UIColor grayColor]];
    desc.lineBreakMode = UILineBreakModeWordWrap;
    desc.numberOfLines = 0;
    desc.font = [UIFont systemFontOfSize:13];
    CGSize maximumLabelSize = CGSizeMake(253,1000);
    CGSize expectedLabelSize = [desc.text sizeWithFont:desc.font constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    [desc sizeToFit];
    CGRect make=desc.frame;
    make.size.height=expectedLabelSize.height;
    desc.frame=make;
    desc.backgroundColor=[UIColor clearColor];
//    float descHeight=desc.frame.size.height+y+y1+250;
    [scrollProductDetail addSubview:desc];
    
    UIButton *shoppingList = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect btnFrame2= shoppingList.frame;
    
    UIImage *removeImage = [UIImage imageNamed:@"remove-from-list.png"];
    UIImage *addImage = [UIImage imageNamed:@"add-to-Slist.png"];
    UIImage *searchImage = [UIImage imageNamed:@"Search_only-this-store.png"];
    
    if (isShoppingList) {
        btnFrame2.origin.y=desc.frame.origin.y + desc.frame.size.height + 30;
//        [shoppingList setTitle:@"Remove from Shopping list" forState:UIControlStateNormal];
        [shoppingList setBackgroundImage:removeImage forState:UIControlStateNormal];
        [shoppingList addTarget:self action:@selector(removeFromList:) forControlEvents:UIControlEventTouchUpInside];
    } else {
            // Button For search only this store
        UIButton *searchStore = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect btnFrame1= searchStore.frame;
        btnFrame1.origin.x= 15 ;
        btnFrame1.origin.y=desc.frame.origin.y + desc.frame.size.height + 30;
//        btnFrame1.size.width= 253;
//        btnFrame1.size.height= 30;
        btnFrame1.size = searchImage.size;
        searchStore.frame=btnFrame1;
//        [searchStore setTitle:@"Search this store" forState:UIControlStateNormal];
        [searchStore setBackgroundImage:searchImage forState:UIControlStateNormal];
        
        [searchStore addTarget:self action:@selector(searchStore) forControlEvents:UIControlEventTouchUpInside];
        
        [scrollProductDetail addSubview:searchStore];
        
        if ([dbAgent productIsPresent:objectToBeUsed.productId]) {
//            [shoppingList setTitle:@"Remove from shopping list" forState:UIControlStateNormal];
            [shoppingList setBackgroundImage:removeImage forState:UIControlStateNormal];
            [shoppingList addTarget:self action:@selector(removeFromList:) forControlEvents:UIControlEventTouchUpInside];
        } else {
//            [shoppingList setTitle:@"Add to shopping list" forState:UIControlStateNormal];
            [shoppingList setBackgroundImage:addImage forState:UIControlStateNormal];
            [shoppingList addTarget:self action:@selector(addToList:) forControlEvents:UIControlEventTouchUpInside];
        }
        btnFrame2.origin.y= searchStore.frame.size.height + searchStore.frame.origin.y + 10;        
    }
        
    // Button for shopping list.
    
    btnFrame2.origin.x= 15 ;
//    btnFrame2.size.width= 253;
//    btnFrame2.size.height= 30;
    btnFrame2.size = removeImage.size;
    shoppingList.frame=btnFrame2;
    
    [scrollProductDetail addSubview:shoppingList];
    
    // Google Logo
//    UIImageView *googleImage=[[UIImageView alloc]init];
    //    UIImage *googleimg= [googleImage image];
//    CGRect googleFrame=googleImage.frame;
//    googleFrame = CGRectMake(80 , shoppingList.frame.origin.y + shoppingList.frame.size.height + 20, 130, 35);
//    UIImage *gImage = [UIImage imageNamed:@"powered_by_google.png"];
//    googleFrame.size = gImage.size;
//    googleImage.frame = googleFrame;
//    [googleImage setImage:gImage];
    
    UIButton *twitterbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [twitterbutton setImage:[UIImage imageNamed:@"sharingbutton_twitter.png"] forState:UIControlStateNormal];
    [twitterbutton addTarget:self
                       action:@selector(twiterBttnTapped:)
             forControlEvents:UIControlEventTouchDown];
    [twitterbutton setTitle:@"twitter" forState:UIControlStateNormal];
    twitterbutton.frame = CGRectMake(68+99, shoppingList.frame.origin.y + shoppingList.frame.size.height+20, 42, 43);
    [scrollProductDetail addSubview:twitterbutton];
    
    
    UIButton *facebookbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebookbutton setImage:[UIImage imageNamed:@"sharingbutton_facebook.png"] forState:UIControlStateNormal];
    [facebookbutton addTarget:self
               action:@selector(facebookBttnTapped:)
     forControlEvents:UIControlEventTouchDown];
    [facebookbutton setTitle:@"facebook" forState:UIControlStateNormal];
    facebookbutton.frame = CGRectMake(68+33, shoppingList.frame.origin.y + shoppingList.frame.size.height+20, 42, 43);
    [scrollProductDetail addSubview:facebookbutton];
    
    
//    UIButton *pinterest = [UIButton buttonWithType:UIButtonTypeCustom];
//    [pinterest setImage:[UIImage imageNamed:@"sharingbutton_pinterest.png"] forState:UIControlStateNormal];
//    [pinterest addTarget:self
//                      action:@selector(pinterestBttnTapped:)
//            forControlEvents:UIControlEventTouchDown];
//    [pinterest setTitle:@"pinterest" forState:UIControlStateNormal];
//    pinterest.frame = CGRectMake(68, shoppingList.frame.origin.y + shoppingList.frame.size.height+20, 42, 43);
//    [scrollProductDetail addSubview:pinterest];
    
    
    float googleHeight =twitterbutton.frame.origin.y+twitterbutton.frame.size.height;
//    googleImage.backgroundColor=[UIColor clearColor];
//    [scrollProductDetail addSubview:googleImage];
    
    // Note Label

    
    
    UILabel *note=[[UILabel alloc]initWithFrame:CGRectMake(xAxis + 5, googleHeight+15, 35, 20)];
    note.textAlignment = UITextAlignmentCenter;
    [note setText:@"NOTE:"];
    [note setTextColor:[UIColor grayColor]];
    //note.lineBreakMode = UILineBreakModeWordWrap;
    note.numberOfLines = 0;
    note.font = [UIFont boldSystemFontOfSize:10];
    
    [note sizeToFit];
    note.backgroundColor=[UIColor clearColor];
    
    [scrollProductDetail addSubview:note];
    
    // Note Description.
    UILabel *noteDesc=[[UILabel alloc]initWithFrame:CGRectMake(note.frame.size.width + note.frame.origin.x + 5, note.frame.origin.y,240, 20)];
    noteDesc.textAlignment = UITextAlignmentLeft;
    [noteDesc setText:@"Item shown may not be available at your local store. To check availability please call your local store."];
    [noteDesc setTextColor:[UIColor grayColor]];
    noteDesc.lineBreakMode = UILineBreakModeWordWrap;
    noteDesc.numberOfLines = 0;
    noteDesc.font = [UIFont systemFontOfSize:10];
    CGSize maximumLabelSize5 = CGSizeMake(240,100);
    CGSize expectedLabelSize5 = [noteDesc.text sizeWithFont:noteDesc.font constrainedToSize:maximumLabelSize5 lineBreakMode:UILineBreakModeWordWrap];
    CGRect make5=noteDesc.frame;
    make5.size.height=expectedLabelSize5.height;
    noteDesc.frame=make5;
    noteDesc.backgroundColor=[UIColor clearColor];
    [scrollProductDetail addSubview:noteDesc];
    [noteDesc sizeToFit];
    float scrollHeight=noteDesc.frame.origin.y+noteDesc.frame.size.height + 10;
    
    CGSize size = [scrollProductDetail contentSize];
    size.height = scrollHeight;
    [scrollProductDetail setContentSize:size];
    
    [scrollProductDetail setContentOffset:CGPointZero];
    
    [lblResultsCount setText:[NSString stringWithFormat:@"%d of %d result%@",productIndex+1,productsArray.count,productsArray.count==1?@"":@"s"]];

//    [name release];
//    [store release];
//    [price release];
//    [desc release];
//    [googleImage release];
//    [note release];
//    [noteDesc release];
//    [facebookbutton release];
//    [twitterbutton release];
}

-(void)imageDownloaded:(NSDictionary*)imgDict {

    NSLog(@"crash here 1");
    if (imgDict!=nil) {
        if ([imgDict objectForKey:@"imgData"]) {        
            DetailAsyncImageVIew *asyn = (DetailAsyncImageVIew*)[imgDict objectForKey:@"imgView"] ;//retain];
            [imagesArray replaceObjectAtIndex:asyn.productIndex withObject:[UIImage imageWithData:[imgDict objectForKey:@"imgData"]]];
            [asyn performSelector:@selector(setImage2:) withObject:[imgDict objectForKey:@"imgData"]];
//            UIImage *img = [UIImage imageWithData:[imgDict objectForKey:@"imgData"]];
//            CGRect imageFrame;
//            imageFrame = [self getFrameForImageWithSize:img.size compareSize:imageFrame.size];
//            [asyn setFrame:imageFrame];

        }
    }
}

-(IBAction)nextClicked:(id)sender {
    
    if (productIndex<productsArray.count-1) 
    {
        productIndex++;
        Product *obj=[productsArray objectAtIndex:productIndex];
        [self createScrollView:obj];
        if (productIndex==productsArray.count-1) {
            [btnNext setEnabled:NO];
        }
        [btnPrev setEnabled:YES];
    }
}

-(IBAction)prevClicked:(id)sender {

    if (productIndex>0)
    {
        // NSLog(@"prodindx %d",productIndex);
        productIndex--;
        Product *obj=[productsArray objectAtIndex:productIndex];
        [self createScrollView:obj];
        if (productIndex==0) {
            [btnPrev setEnabled:NO];
        }
        [btnNext setEnabled:YES];
    }    
}

-(CGRect)getFrameForImageWithSize:(CGSize)size compareSize:(CGSize)cSize {
    CGRect frame = CGRectZero;
    float h = cSize.height;
    float w = cSize.width;
    if (size.height<h || size.width<w) {
        frame.size = size;
        if (w>size.width) {
            frame.origin.x =  (w - size.width)/2;
        }
        if (h>size.height) {
            frame.origin.y =  (h - size.height)/2;
        }
    } else {
        frame.size = CGSizeMake(w, h);
    }
    
    return frame;
}

-(void)showImage {
    id img = [imagesArray objectAtIndex:productIndex];
    if ([img isKindOfClass:[UIImage class]]) {
        
//        [productImageView setFrame:[self getFrameForImageWithSize:[img size] compareSize:CGSizeMake(320, 460)]];
        [productImageView setImage:img];
        NSLog(@"imgview %@",productImageView);
    } else {
        NSLog(@"imagenotdownloaded");
        CGRect frame = productImageView.frame;
        frame.origin.y = 44;
        DetailAsyncImageVIew *detailImage = [[DetailAsyncImageVIew alloc]initWithFrame:frame];
        Product *p = [productsArray objectAtIndex:productIndex];
        [detailImage loadImageFromURL:[NSURL URLWithString:p.imageUrl] delegate:self requestSelector:@selector(detailImageDownloaded:)];
//        [detailImage release];
    }
    
    [delegate hideTabBar:NO];
    [self.navigationController setNavigationBarHidden:YES];
    
    [hideImage setHidden:NO];
    [showImageScrollView setHidden:NO];
}

-(IBAction)hideImage:(UIButton*)sender {
    [delegate showTabBar:NO];
    [self.navigationController setNavigationBarHidden:NO];
    [showImageScrollView setHidden:YES];
    [showImageScrollView setZoomScale:1.0];
    [hideImage setHidden:YES];
    [productImageView setImage:nil];
    for (UIView *v in productImageView.subviews) {
        [v removeFromSuperview];
    }
}

-(void)detailImageDownloaded:(NSDictionary *)imgDict {
    NSLog(@"crash here 2");
    if (imgDict!=nil) {
        if ([imgDict objectForKey:@"imgData"]) {        
            DetailAsyncImageVIew *asyn = (DetailAsyncImageVIew*)[imgDict objectForKey:@"imgView"] ;//retain];
            UIImage *img = [UIImage imageWithData:[imgDict objectForKey:@"imgData"]];
            [imagesArray replaceObjectAtIndex:asyn.productIndex withObject:img];
//            [productImageView setFrame:[self getFrameForImageWithSize:[img size] compareSize:CGSizeMake(320, 460)]];
            [productImageView setImage:img];
        }
    }
}

#pragma mark - scrollviewdelegate

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return productBackView;
}

#pragma mark - shopping list

-(void)addToList:(UIButton*)sender {
    [dbAgent addProductToShoppingList:[productsArray objectAtIndex:productIndex]];
    [listCountLabel setText:[NSString stringWithFormat:@"%d",[dbAgent getCount]]];
    //    [sender setTitle:@"Remove from Shopping list" forState:UIControlStateNormal];
//    add-to-Slist.png
    [sender setBackgroundImage:[UIImage imageNamed:@"remove-from-list.png"] forState:UIControlStateNormal];
    [sender addTarget:self action:@selector(removeFromList:) forControlEvents:UIControlEventTouchUpInside];
    [listCountLabel setText:[NSString stringWithFormat:@"%d",[dbAgent getCount]]];
}

-(IBAction)removeFromList:(UIButton*)sender {
    [dbAgent removeProductFromShoppingList:[[productsArray objectAtIndex:productIndex] productId]];
    [listCountLabel setText:[NSString stringWithFormat:@"%d",[dbAgent getCount]]];
    if (isShoppingList) {
        [imagesArray removeObjectAtIndex:productIndex];
        [productsArray removeObjectAtIndex:productIndex];
        [self refresh];
    } else {
//        [sender setTitle:@"Add to Shopping list" forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"add-to-Slist.png"] forState:UIControlStateNormal];
        [sender addTarget:self action:@selector(addToList:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

-(void)refresh {
//    [productsArray removeAllObjects];
//    [productsArray addObjectsFromArray:[dbAgent getShoppingList]];
    if (productsArray.count==0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (productIndex==productsArray.count-1) {
        [self createScrollView:[productsArray objectAtIndex:productIndex]];
    } else if(productIndex<productsArray.count-1) {
//        [self nextClicked:nil];
        [self createScrollView:[productsArray objectAtIndex:productIndex]];
    } else if (productIndex>=productsArray.count) {
        [self prevClicked:nil];
    } 
    
    if (productIndex == 0) {
        [btnPrev setEnabled:NO];
    } 
    if (productIndex == productsArray.count-1) {
        [btnNext setEnabled:NO];
    }
}

-(void)showShoppingList {
    
    if ([[Database sharedDatabase]getCount]) {
    
    ShoppingListViewController *shoppingList = [[ShoppingListViewController alloc]initWithNibName:@"ShoppingListViewController" bundle:nil];
    [self.navigationController pushViewController:shoppingList animated:YES];
    [self.navigationItem setTitle:@"Back"];
    }
}
//////kuldeep
-(void)searchStore {
    
    ////here
    [self makeRequestForStringAndStoreId];
//    SingleStoreSearchViewController *storeView = [[SingleStoreSearchViewController alloc]initWithNibName:@"SingleStoreSearchViewController" bundle:nil];
//    NSString *storeName = [[productsArray objectAtIndex:productIndex] store];
//    storeView.titleString = storeName;
//    [self.navigationItem setTitle:@"Back"];
//    
//    NSMutableArray *arr = [[NSMutableArray alloc]init];
//    for (Product *p in productsArray) {
//        if ([p.store isEqualToString:storeName]) {
//            [arr addObject:p];
//        }
//    }
//    
//    storeView.productsArray = [[NSMutableArray alloc]initWithArray:arr];
//    [self.navigationController pushViewController:storeView animated:YES];
    
//    [storeView release];
}

#pragma mark - get tenant id

-(void)showStoreDetails{
    [self makeLoadingView];
    [self loadingView:YES];
    //
    NSString *str = NSLocalizedString(@"PRODUCT_SEARCH_IDS","");
    NSString *url= [NSString stringWithFormat:@"%@property_id=%ld", str,delegate.mallId];
//    NSString *url= [NSString stringWithFormat:@"http://cherryhillmall.red5demo.com/api/product_search_ids?property_id=%ld",delegate.mallId];
    NSLog(@"uuuuuuuuurrrrrrrrllllll %@",url);
    
	RequestAgent *req=[[RequestAgent alloc] init];// autorelease];
	[req requestToServer:self callBackSelector:@selector(responseSuccessForTenantID:) errorSelector:@selector(errorCallback:) Url:url];


}
-(void)responseSuccessForTenantID:(NSData *)receivedData
{
    NSLog(@"responseSuccessForTenantID");
//	[self loadingView:NO];
    NSString *tanentID;
	if(receivedData!=nil)
    {
		NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];// autorelease];
		// test string
        Product *prod = [productsArray objectAtIndex:productIndex];
        
        NSLog(@"iiiiiiiiiddddddddd %@",prod.storeID);
		//NSLog(@"jsonString===%@",jsonString);
		NSArray *tmpArray=[jsonString JSONValue];
//        NSLog(@"kkkkkkkkkkkk %@",tmpArray);
//        [self showStoreDetails:tempArray];
//        [self showStoreDetails:tempArray];
        
        // change 1 july 2015
        for (NSDictionary *dict in tmpArray)
        {
            NSDictionary *dict2 = [dict objectForKey:@"tenant_retailigence_retailer"];
            NSLog(@":::: %@",dict2);
            if ([[[dict2 objectForKey:@"retailigence_retailer"] objectForKey:@"retailer_id"]isEqualToString:prod.storeID]) {
                
                tanentID = [dict2 valueForKey:@"tenant_id"];
                NSLog(@"tanent id === %@",tanentID);
                break;
            }
        }
        
        [self showStoreDetailsWithTanentid:tanentID];
    }else{
        
        [self loadingView:NO];
        [delegate showAlert:@"Sorry. This store is not in the selected mall." title:@"Message" buttontitle:@"Ok"];
    }
    
}

#pragma mark - get store detail

-(void)showStoreDetailsWithTanentid:(NSString *)tanentID {
    [self loadingView:NO];
//    Product *prod = [productsArray objectAtIndex:productIndex];
    // NSLog(@"store %@",prod.store);
    NSDictionary *tmpDict;
    BOOL breakFlag = NO;
    
    
    NSLog(@">>>>>>>>>list content === %@",listContent);
    
    for (NSArray *array in listContent)
	{
//        NSLog(@"########## listcontent %@",array);
        
		for (NSDictionary *dict in array)
		{
            
			tmpDict =[dict objectForKey:@"tenant"];
//			NSString *sTemp=[tmpDict objectForKey:@"name"];
            
            NSString *tempStr = [[tmpDict objectForKey:@"suite"]objectForKey:@"tenant_id"];
            NSLog(@"temp string === %@ .. %@",tempStr,tanentID);
			// NSLog(@"store in array %@",sTemp);
//			if([sTemp rangeOfString:prod.store options:NSDiacriticInsensitiveSearch|NSCaseInsensitiveSearch].location!= NSNotFound) {
            if (tempStr.intValue == tanentID.intValue){
                NSLog(@"matched");
                breakFlag = YES;
                break;
            }
        }
        if (breakFlag) {
            break;
        }
    }
    
    if (breakFlag) {
        if (tmpDict!=nil) {
            StoreDetailsViewController *screenStoreDetail=[[StoreDetailsViewController alloc]initWithNibName:@"CustomStoreDetailViewController" bundle:nil];
            screenStoreDetail.dictData = tmpDict;	
            [self.navigationController pushViewController:screenStoreDetail animated:YES];
//            [screenStoreDetail release];
        } else {
            [delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Message" buttontitle:@"Ok"];
        }
    } else {
        [delegate showAlert:@"Sorry. This store is not in the selected mall." title:@"Message" buttontitle:@"Ok"];
    }
}

-(void)showStoreTap:(UITapGestureRecognizer*)tap {
    NSLog(@"showStoreTap");
    [self settingsForGetdata];
}

-(void)showStore {
    NSLog(@"showstore");
    //    NSLog(@"storelist %@",delegate.storeListContent);
    [self settingsForGetdata];
}

-(void)settingsForGetdata {
    
    if([listContent count]==0)         
        listContent = [[NSMutableArray alloc] init];
	
    if([delegate.storeListContent count]>0) 
    {
        
        [listContent addObjectsFromArray:delegate.storeListContent];
        
        [self showStoreDetails];
        
    }
    else
    {
        NSString *path = [[[NSBundle mainBundle] bundlePath]stringByAppendingPathComponent:@"checkDict.plist"];
        checkDict = [[NSDictionary dictionaryWithContentsOfFile:path] mutableCopy];
        
        indexArray = [[NSMutableArray alloc] init];
        NSNumber *num=[NSNumber numberWithInt:-1];
        [indexArray addObject:num];
        [indexArray addObject:num];
        [indexArray addObject:num];
        [indexArray addObject:num];
        [indexArray addObject:num];
        [indexArray addObject:num];
        [indexArray addObject:num];
        [indexArray addObject:num];
        [indexArray addObject:num];
        [indexArray addObject:num];
        [indexArray addObject:num];
        [indexArray addObject:num];
        [indexArray addObject:num];
        [indexArray addObject:num];
        [indexArray addObject:num];
        [indexArray addObject:num];
        [indexArray addObject:num];
        [indexArray addObject:num];
        [indexArray addObject:num];
        [indexArray addObject:num];
        [indexArray addObject:num];
        [indexArray addObject:num];
        [indexArray addObject:num];
        [indexArray addObject:num];
        [indexArray addObject:num];
        [indexArray addObject:num];
        [indexArray addObject:num];
        
        tempArray = [[NSMutableArray alloc] init];
        [tempArray addObject:@"123"];
        [tempArray addObject:@"A"];
        [tempArray addObject:@"B"];
        [tempArray addObject:@"C"];
        [tempArray addObject:@"D"];
        [tempArray addObject:@"E"];
        [tempArray addObject:@"F"];
        [tempArray addObject:@"G"];
        [tempArray addObject:@"H"];
        [tempArray addObject:@"I"];
        [tempArray addObject:@"J"];
        [tempArray addObject:@"K"];
        [tempArray addObject:@"L"];
        [tempArray addObject:@"M"];
        [tempArray addObject:@"N"];
        [tempArray addObject:@"O"];
        [tempArray addObject:@"P"];
        [tempArray addObject:@"Q"];
        [tempArray addObject:@"R"];
        [tempArray addObject:@"S"];
        [tempArray addObject:@"T"];
        [tempArray addObject:@"U"];
        [tempArray addObject:@"V"];
        [tempArray addObject:@"W"];
        [tempArray addObject:@"X"];
        [tempArray addObject:@"Y"];
        [tempArray addObject:@"Z"];
        
        [self getData];

    }
    
}

-(void)makeLoadingView
{
	UIWindow* keywindow = [[UIApplication sharedApplication] keyWindow];
	CGRect keyFrame=[keywindow frame];
	CGRect frame=CGRectMake(keyFrame.origin.x, keyFrame.origin.y, keyFrame.size.width, keyFrame.size.height);
    
	main_view = [[UIView alloc] initWithFrame:frame];
	main_view.backgroundColor = [UIColor clearColor];
	main_view.alpha =1.0;
	
	UIActivityIndicatorView *wait = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	wait.hidesWhenStopped = NO;			
	
	frame=CGRectMake(56.0,180.0, 211.0, 121.0);
	UIView *loadingView=[[UIView alloc]initWithFrame:frame];
	loadingView.backgroundColor=[UIColor darkGrayColor];
    
	frame=CGRectMake(32.0,20.0, 159.0,60.0);
	UILabel *loadingLabel = [[UILabel alloc] initWithFrame:frame];
	loadingLabel.textColor = [UIColor whiteColor];
	loadingLabel.backgroundColor = [UIColor clearColor];
	loadingLabel.font=[UIFont boldSystemFontOfSize:18];
	loadingLabel.textAlignment = UITextAlignmentCenter;
	loadingLabel.text = @"Please wait loading stores...";
	//loadingLabel.lineBreakMode=UILineBreakModeWordWrap;		
	loadingLabel.numberOfLines=0;		
	[loadingView addSubview:loadingLabel];
	[loadingView addSubview:wait];
	
	frame=CGRectMake(86.0, 77.0, 37.0,37.0);
	wait.frame=frame;
	
	CALayer *l=[loadingView layer];
	[l setCornerRadius:10.0];
	[l setBorderWidth:3.0];
	[l setBorderColor:[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]CGColor]];
	
	[main_view addSubview:loadingView];
	[wait startAnimating];
//	[wait release];
//	[loadingLabel release];
//	[loadingView release];	
}

-(void)loadingView:(BOOL)flag
{
	//NSLog(@"flag ============%d",flag);
	if(flag){
		[[[UIApplication sharedApplication] keyWindow] addSubview:main_view];
		[[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:main_view];
	}else 
		[main_view removeFromSuperview];
}

-(void)getData {	
    [self makeLoadingView];
    //	isNoData=NO;
	NSString *url=[NSString stringWithFormat:@"%@%@",[delegate.mallData objectForKey:@"resource_url"],NSLocalizedString(@"API1.1","")];
    
	RequestAgent *req=[[RequestAgent alloc] init];// autorelease];
	[req requestToServer:self callBackSelector:@selector(responseData:) errorSelector:@selector(errorCallback:) Url:url];
	[self loadingView:YES];
}

-(void)responseData:(NSData *)receivedData{
	[self loadingView:NO];
    
	if(receivedData!=nil){
		NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];// autorelease];
		// test string
        
		//NSLog(@"jsonString===%@",jsonString);
		NSArray *tmpArray=[jsonString JSONValue];
        //		//NSLog(@"\n\n\n\ntmpArray===count==%d====%@",[tmpArray count],tmpArray);
        
		[listContent removeAllObjects];
		if([tmpArray count]!=0){
			
			for(int i=0;i<[tmpArray count];i++)
			{
				NSDictionary *tmpDict=[[tmpArray objectAtIndex:i]objectForKey:@"tenant"];
				[self checkIndex:[tmpDict objectForKey:@"name"] forindex:i];
			}
			
			for(int i=0;i<[indexArray count];i++)
			{
				int x,y;				
				int number=[[indexArray objectAtIndex:i] intValue];
                
				if(number==-1)
				{
					NSArray *emptyArray=[[NSArray alloc]init];
					[listContent addObject:emptyArray];
//					[emptyArray release];
				}
				else 
				{	
                    x=number;	
                    if([[tempArray objectAtIndex:i] isEqualToString:@"Z"])
                    {
                        y=[tmpArray count]-x;				
                    }
                    else 
                    {
                        int z=i+1;
                        int num=[[indexArray objectAtIndex:z] intValue];
                        
                        if([[tempArray objectAtIndex:z] isEqualToString:@"Z"] && num==-1)
							num=-2;
                        
                        while (num==-1) 
                        {
                            z++;
                            num=[[indexArray objectAtIndex:z] intValue];
                            if([[tempArray objectAtIndex:z] isEqualToString:@"Z"] && num==-1)
                                num=-2;
                        }
                        if(num==-2)
                        {
                            y=[tmpArray count]-x;
                        }
                        else
                            y=num-x;
                    }
					
                    // Starting at position x, get y characters
                    NSRange range={x,y};
                    NSIndexSet *indexes=[NSIndexSet indexSetWithIndexesInRange:range];
                    NSArray *objectArray=[tmpArray objectsAtIndexes:indexes];// retain];
                    
                    [listContent addObject:objectArray];
                }
			}
			
			delegate.storeListContent=listContent;
            [self showStoreDetails];
            
            // NSLog(@"delegate.storelistcontent %@",delegate.storeListContent);
            
		}
		else{
//			isNoData=YES;
            [delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Message" buttontitle:@"Ok"];
            
		}
	}
	else {
//		isNoData=YES;
        [delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Message" buttontitle:@"Ok"];
    }
	
}

-(void)errorCallback:(NSError *)error{
    [self loadingView:NO];
	[delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Message" buttontitle:@"Ok"];
}



-(void)checkIndex:(NSString*)name forindex:(int)i
{	
	NSRange range = {0,1};
	name = [name substringWithRange:range];
	name=[name uppercaseString];
	NSNumber *num=[NSNumber numberWithInt:i];
	if(![name caseInsensitiveCompare:@"A"])
	{	
		if([[checkDict valueForKey:@"A"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"A"];
		}		
	}
	else if(![name caseInsensitiveCompare:@"B"])
	{	
		if([[checkDict valueForKey:@"B"]intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"B"];
		}
	}
	else if(![name caseInsensitiveCompare:@"C"])
	{	
		if([[checkDict valueForKey:@"C"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"C"];
		}
	}
	else if(![name caseInsensitiveCompare:@"D"])
	{	
		if([[checkDict valueForKey:@"D"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"D"];
		}
	}
	else if(![name caseInsensitiveCompare:@"E"])
	{	
		if([[checkDict valueForKey:@"E"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"E"];
		}
	}
	else if(![name caseInsensitiveCompare:@"F"])
	{	
		if([[checkDict valueForKey:@"F"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"F"];
		}
	}
	else if(![name caseInsensitiveCompare:@"G"])
	{	
		if([[checkDict valueForKey:@"G"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"G"];
		}
	}
	else if(![name caseInsensitiveCompare:@"H"])
	{	
		if([[checkDict valueForKey:@"H"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"H"];
		}
	}
	else if(![name caseInsensitiveCompare:@"I"])
	{	
		if([[checkDict valueForKey:@"i"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"I"];
		}
	}
	else if(![name caseInsensitiveCompare:@"J"])
	{	
		if([[checkDict valueForKey:@"J"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"J"];
		}
	}
	else if(![name caseInsensitiveCompare:@"K"])
	{	
		if([[checkDict valueForKey:@"K"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"K"];
		}
	}
	else if(![name caseInsensitiveCompare:@"L"])
	{	
		if([[checkDict valueForKey:@"L"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"L"];
		}
	}
	else if(![name caseInsensitiveCompare:@"M"])
	{	
		if([[checkDict valueForKey:@"M"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"M"];
		}
	}
	else if(![name caseInsensitiveCompare:@"N"])
	{	
		if([[checkDict valueForKey:@"N"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"N"];
		}
	}
	else if(![name caseInsensitiveCompare:@"O"])
	{	
		if([[checkDict valueForKey:@"O"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"O"];
		}
	}
	else if(![name caseInsensitiveCompare:@"P"])
	{	
		if([[checkDict valueForKey:@"P"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"P"];
		}
	}
	else if(![name caseInsensitiveCompare:@"Q"])
	{	
		if([[checkDict valueForKey:@"Q"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"Q"];
		}
	}
	else if(![name caseInsensitiveCompare:@"R"])
	{	
		if([[checkDict valueForKey:@"R"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"R"];
		}
	}
	else if(![name caseInsensitiveCompare:@"S"])
	{	
		if([[checkDict valueForKey:@"S"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"S"];
		}
	}
	else if(![name caseInsensitiveCompare:@"T"])
	{	
		if([[checkDict valueForKey:@"T"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"T"];
		}
	}
	else if(![name caseInsensitiveCompare:@"U"])
	{	
		if([[checkDict valueForKey:@"U"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"U"];
		}
	}
	else if(![name caseInsensitiveCompare:@"V"])
	{	
		if([[checkDict valueForKey:@"V"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"V"];
		}
	}
	else if(![name caseInsensitiveCompare:@"W"])
	{	
		if([[checkDict valueForKey:@"W"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"W"];
		}
	}
	else if(![name caseInsensitiveCompare:@"X"])
	{	
		if([[checkDict valueForKey:@"X"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"X"];
		}
	}
	else if(![name caseInsensitiveCompare:@"Y"])
	{	
		if([[checkDict valueForKey:@"Y"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"Y"];
		}
	}
	else if(![name caseInsensitiveCompare:@"Z"])
	{	
		if([[checkDict valueForKey:@"Z"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:name]];
			[checkDict setValue:num forKey:@"Z"];
		}
	}	
	else
	{	
		if([[checkDict valueForKey:@"123"] intValue]==-1)
		{
			[indexArray insertObject:num atIndex:[tempArray indexOfObject:@"123"]];
			[checkDict setValue:num forKey:@"123"];
		}
	}	
}
#pragma mark - request
-(void)makeRequestForStringAndStoreId{//:(NSString*)storeid{
    
    [spinner setHidden:NO];
    [spinner startAnimating];
    
    int page =1;
    Product *obj=[productsArray objectAtIndex:productIndex];
    RequestAgent *req = [[RequestAgent alloc]init];
    
    
//    urlString = [[NSString alloc]initWithFormat:@"%@%@&property_id=%ld", NSLocalizedString(@"SEARCHAPI", @""), [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],delegate.mallId];
    
    ///change api...search
    
//    NSLog(@"store id to get %@",delegate.mallData);
    
    //    urlString = [[NSString alloc]initWithFormat:@"%@%@&stores[]=%@&property_id=%ld", NSLocalizedString(@"SEARCHAPI", @""), [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],storeid,delegate.mallId];
    urlString = [NSString stringWithFormat:@"%@&retailer_id=%@",delegate.searchURL,obj.storeID];
    NSLog(@"url new:::::: %@",urlString);
    NSString *url = [NSString stringWithFormat:@"%@&page=%d",urlString,page];
    //    [req requestToServer:self callBackSelector:@selector(requestFinished:) errorSelector:@selector(requestError:) Url:urlString];
    [req requestToServer:self callBackSelector:@selector(requestForSearchFinishedSuccess:) errorSelector:@selector(requestError:) Url:url];
}

-(void)requestForSearchFinishedSuccess:(NSData*)responseData{
//    [productListView.productsArray removeAllObjects];
//    [mainArray removeAllObjects];
//    productListView.hasMoreProducts = NO;
//    productListView.hasPreviousProducts = NO;
    //kuldeep edited
    NSString *jsonString = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];//autorelease];
    NSLog(@"jsong string==%@",jsonString);
    NSDictionary *dict = [jsonString JSONValue];
    NSLog(@"reply ===%@",dict);
//change 1 july
    float totalCount = [[dict objectForKey:@"count"] longValue];
//    [lblResultCount setText:[NSString stringWithFormat:@"%ld results",totalCount]];
    //    NSArray *array = [dict objectForKey:@"items"];
    NSArray *array = [dict objectForKey:@"results"];
    NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!%d",array.count);
    NSMutableArray *itemsArray = [[NSMutableArray alloc]initWithCapacity:array.count];
    
    for (int i=0; i<array.count; i++) {
        Product *prod = [[Product alloc]initWithValues:[[array objectAtIndex:i]objectForKey:@"SearchResult"]];
        [itemsArray addObject:prod];
        //        [prod release];
        if (i==30) {
            break;
        }
    }
    //    for (NSDictionary *d in array) {
    //        Product *prod = [[Product alloc]initWithValues:d];
    //        [itemsArray addObject:prod];
    //        [prod release];
    //    }
    NSLog(@"break at index,,,%d",itemsArray.count);
    int currentCount = itemsArray.count;
    
//    if (currentCount>=totalCount) {
//        productListView.hasMoreProducts = NO;
//    } else {
//        productListView.hasMoreProducts = YES;
//    }
//    [barView setHidden:NO];
//    [lblSort setText:[NSString stringWithFormat:@"Sort: %@",sortString]];
    NSMutableArray *mainArray = [[NSMutableArray alloc]initWithArray:itemsArray];
//    if (productListView.productsArray) {
//        //        [productListView.productsArray release];
//    }
//    productListView.productsArray = [[NSMutableArray alloc]initWithArray:itemsArray];
//    [productListView setHidden:NO];
    
//    [overView setHidden:YES];
    [spinner stopAnimating];
    
    if (itemsArray.count==0) {
        [delegate showAlert:@"No product matching your criteria found" title:@"No result found" buttontitle:@"Dismiss"];
    }
//    productListView.totalCount = totalCount;
//    productListView.currentCount = currentCount;
 
    //    sortString = @"Price: Low-High";

//    [productListView.productsArray removeAllObjects];
//    [productListView.productsArray addObjectsFromArray:mainArray];
//
//    [productListView.productListTable reloadData];

    
    SingleStoreSearchViewController *storeView = [[SingleStoreSearchViewController alloc]initWithNibName:@"SingleStoreSearchViewController" bundle:nil];
    NSString *storeName = [[productsArray objectAtIndex:productIndex] retailerName];
    storeView.titleString = storeName;
//    [storeView setProductsArray:productsArray];
    
    [self.navigationItem setTitle:@"Back"];
    
//    NSMutableArray *arr = [[NSMutableArray alloc]init];
//    for (Product *p in productsArray) {
//        if ([p.store isEqualToString:storeName]) {
//            [arr addObject:p];
//        }
//    }
    storeView.urlString = urlString;
    storeView.totalCount = totalCount;
    storeView.currentCount = currentCount;
    storeView.productsArray = [[NSMutableArray alloc]initWithArray:mainArray];
    [self.navigationController pushViewController:storeView animated:YES];

    //    [itemsArray release];
}

-(void)requestError:(NSError*)error {
    [delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Network error" buttontitle:@"Dismiss"];
    [spinner stopAnimating];
}

@end
