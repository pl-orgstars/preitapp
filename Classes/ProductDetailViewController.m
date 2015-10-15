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
#import "JSBridgeViewController.h"

@implementation ProductDetailViewController

#define tagImageView 111

#define xAxis 10

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
    [self setNavigationTitle:@"Product Detail" withBackButton:YES];
    
    [listCountLabel setText:[NSString stringWithFormat:@"%d",[dbAgent getCount]]];
    
    [self createScrollView:[productsArray objectAtIndex:productIndex]];
    [self CallForDBCount];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    imgviewCircle.hidden = TRUE;
    lblCount.hidden = TRUE;
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
        [listCountLabel setTextAlignment:NSTextAlignmentCenter];
        [barView addSubview:listCountLabel];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                             action:@selector(showShoppingList)];
        [barView addGestureRecognizer:tap];
        
        UIBarButtonItem *shoppingListView = [[UIBarButtonItem alloc]initWithCustomView:barView];
        [self.navigationItem setRightBarButtonItem:shoppingListView];
        
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
    
    NSLog(@"urlllll %@",urlStr);
    
    PinterestWebViewController *viewCntroller = [[PinterestWebViewController alloc]initWithNibName:@"PinterestWebViewController" bundle:nil];
    [viewCntroller setImageUrl:prod.imageUrl];
    viewCntroller.searchUrl = urlStr;
    viewCntroller.description =  [NSString stringWithFormat:@"%@ from %@", prod.title,[delegate.mallData objectForKey:@"name"]];
    NSLog(@"description %@",[delegate.mallData objectForKey:@"name"]);
    [self.navigationController pushViewController:viewCntroller animated:YES];
    
}

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
        
    }
    
    length += (int)urlStr.length;
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSString *imgeUrll = prod.imageUrl;//= [self tinyUrl:prod.imageUrl];
    length += (int)imgeUrll.length;
    
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgeUrll]];
    
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
    
    
    
    NSLog(@"length :::::%d",length);
    
    length = (int)((NSString*)[delegate.mallData objectForKey:@"name"]).length;
    if (length>0 && length<61) {
        if ((int)message.length < (58-length+9)) {
            
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
-(NSString *)urlEncodeForEscapesForString:(NSString *)urlString1{
    
    NSString *trimmedString = [urlString1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return [trimmedString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
}

-(void)faceBookShare{
    
    
    NSLog(@"mall data %@",delegate.mallData);
    
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
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
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
    
    
}

#pragma mark - button metthod
-(void)pinterestBttnTapped:(id)sender{
    [self pinterestShare];
}

-(void)facebookBttnTapped:(id)sender{
    [self faceBookShare];
}
-(void)twiterBttnTapped:(id)sender{
    [self twitterShareDemo];
}
#pragma mark - create scroll view

-(void)createScrollView:(Product *) objectToBeUsed
{
    
    
    for (UIView *viewInner in scrollProductDetail.subviews) {
        if(viewInner.tag < 0){
            
        }else {
            [viewInner removeFromSuperview];    
        }
            
        
    }

    lblName.text =objectToBeUsed.title;
    lblPrice.text =[NSString stringWithFormat:@"$%.2f", objectToBeUsed.price];
    
    if (self.isShoppingList) {
        
        NSArray *stringArray = [objectToBeUsed.store componentsSeparatedByString:@"-"];
        
        NSString *retailerNameString = [[stringArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [lblStoreName setText:retailerNameString];
        
    }else{
        
        [lblStoreName setText:objectToBeUsed.retailerName];
    }
    
    UIImage *img = [imagesArray objectAtIndex:productIndex];
    
    float y2;
    UITapGestureRecognizer *ImageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ShowImageView:)];
    [ImageTap setCancelsTouchesInView:NO];
    
    
    if ([img isKindOfClass:[UIImage class]])
    {
        UIImageView *imageDetail=[[UIImageView alloc]initWithImage:img];
        
        imageDetail.frame = imgViewMain.frame;
        y2=imageDetail.frame.size.height;
        imageDetail.backgroundColor=[UIColor clearColor];
        [scrollProductDetail addSubview:imageDetail];
        [imageDetail setContentMode:UIViewContentModeScaleAspectFit];
        [imageDetail setBackgroundColor:[UIColor clearColor]];
        [imageDetail addGestureRecognizer:ImageTap];
        [imageDetail setUserInteractionEnabled:YES];
        [self.view bringSubviewToFront:imgViewZoom];
        imgViewZoom.hidden = FALSE;
    }
    else
    {
        DetailAsyncImageVIew *imageDetail=[[DetailAsyncImageVIew alloc]init];
        [imageDetail setProductIndex:productIndex];
        [imageDetail setTag:tagImageView];
        imageDetail.backgroundColor=[UIColor clearColor];
        [imageDetail loadImageFromURL:[NSURL URLWithString:objectToBeUsed.imageUrl] delegate:self requestSelector:@selector(imageDownloaded:)];
        imageDetail.frame = imgViewMain.frame;
        y2=imageDetail.frame.size.height;
        imageDetail.backgroundColor=[UIColor clearColor];
        [scrollProductDetail addSubview:imageDetail];
        [imageDetail setBackgroundColor:[UIColor clearColor]];
        [imageDetail addGestureRecognizer:ImageTap];
        [imageDetail setUserInteractionEnabled:YES];
        [self.view bringSubviewToFront:imgViewZoom];
        
        
    }
    
    
    
    //// Add discription /////////
    
    UILabel *desc=[[UILabel alloc]initWithFrame:CGRectMake(xAxis , imgViewMain.frame.origin.y + imgViewMain.frame.size.height + 20,253,20)];
    desc.textAlignment = NSTextAlignmentLeft;
    [desc setText:objectToBeUsed.desc];
    [desc setTextColor:[UIColor whiteColor]];
    desc.lineBreakMode = NSLineBreakByWordWrapping;
    desc.numberOfLines = 0;
    desc.font = [UIFont systemFontOfSize:13];
    
    
    NSDictionary *fontAttributes = @{NSFontAttributeName : desc.font};
    CGSize expectedLabelSize = [objectToBeUsed.desc sizeWithAttributes:fontAttributes];
    
    
    
    [desc sizeToFit];
    CGRect make=desc.frame;
    make.size.height=expectedLabelSize.height;
    desc.frame=make;
    desc.backgroundColor=[UIColor clearColor];
    [scrollProductDetail addSubview:desc];

    
    
    
    
    ////// Add Buttons ///////
    
    
    UIButton *shoppingList = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect btnFrame2= shoppingList.frame;
    
    UIImage *removeImage = [UIImage imageNamed:@"NewREmoveBTn.png"];
    UIImage *addImage = [UIImage imageNamed:@"NewSavetoListBtn.png"];
    UIImage *searchImage = [UIImage imageNamed:@"NewSearchonStoreBTn.png"];
    CGRect btnFrame1;
    
    if (isShoppingList)
    {
        btnFrame2.origin.y=desc.frame.origin.y + desc.frame.size.height+ 15;
        [shoppingList setBackgroundImage:removeImage forState:UIControlStateNormal];
        [shoppingList addTarget:self action:@selector(removeFromList:) forControlEvents:UIControlEventTouchUpInside];
    } else
    {
        // Button For search only this store
        UIButton *searchStore = [UIButton buttonWithType:UIButtonTypeCustom];
        btnFrame1= searchStore.frame;
        btnFrame1.origin.x= 10 ;
        btnFrame1.origin.y=desc.frame.origin.y + desc.frame.size.height+ 65;
        btnFrame1.size = searchImage.size;
        searchStore.frame=btnFrame1;
        [searchStore setBackgroundImage:searchImage forState:UIControlStateNormal];
        
        [searchStore addTarget:self action:@selector(searchStore) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.isShoppingList)
        {
            
        }else
        {
          [scrollProductDetail addSubview:searchStore];
        }
        
        if ([dbAgent productIsPresent:objectToBeUsed.productId])
        {
            [shoppingList setBackgroundImage:removeImage forState:UIControlStateNormal];
            [shoppingList addTarget:self action:@selector(removeFromList:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [shoppingList setBackgroundImage:addImage forState:UIControlStateNormal];
            [shoppingList addTarget:self action:@selector(addToList:) forControlEvents:UIControlEventTouchUpInside];
        }
        btnFrame2.origin.y= desc.frame.origin.y + desc.frame.size.height+ 15;
    }
    
    // Button for shopping list.
    
    btnFrame2.origin.x= 10 ;
    btnFrame2.size = removeImage.size;
    shoppingList.frame=btnFrame2;
    
    [scrollProductDetail addSubview:shoppingList];
    
    
    ///// Add Share Btn
    
    if (self.isShoppingList)
    {
        lblShareVia.frame = CGRectMake(lblShareVia.frame.origin.x, btnFrame2.origin.y+ btnFrame2.size.height +15, lblShareVia.frame.size.width, lblShareVia.frame.size.height);

    }else
    {
        lblShareVia.frame = CGRectMake(lblShareVia.frame.origin.x, btnFrame1.origin.y+ btnFrame1.size.height +15, lblShareVia.frame.size.width, lblShareVia.frame.size.height);
    }
    
    
    UIButton *twitterbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [twitterbutton setImage:[UIImage imageNamed:@"NewTwitterBtn.png"] forState:UIControlStateNormal];
    [twitterbutton addTarget:self
                      action:@selector(twiterBttnTapped:)
            forControlEvents:UIControlEventTouchDown];
    [twitterbutton setTitle:@"twitter" forState:UIControlStateNormal];
    twitterbutton.frame = CGRectMake(68+99, lblShareVia.frame.origin.y + lblShareVia.frame.size.height + 20 , 42, 43);
    [scrollProductDetail addSubview:twitterbutton];
    
    
    UIButton *facebookbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebookbutton setImage:[UIImage imageNamed:@"NewfbBtn.png"] forState:UIControlStateNormal];
    [facebookbutton addTarget:self
                       action:@selector(facebookBttnTapped:)
             forControlEvents:UIControlEventTouchDown];
    [facebookbutton setTitle:@"facebook" forState:UIControlStateNormal];
    facebookbutton.frame = CGRectMake(68+33, lblShareVia.frame.origin.y + lblShareVia.frame.size.height + 20, 42, 43);
    [scrollProductDetail addSubview:facebookbutton];
//    float googleHeight = twitterbutton.frame.origin.y + twitterbutton.frame.size.height;
    
    UILabel *note=[[UILabel alloc]initWithFrame:CGRectMake(xAxis + 5, facebookbutton.frame.origin.y+facebookbutton.frame.size.height+15, 35, 20)];
    note.textAlignment = NSTextAlignmentCenter;
    [note setText:@"NOTE:"];
    [note setTextColor:[UIColor whiteColor]];
    note.numberOfLines = 0;
    note.font = [UIFont boldSystemFontOfSize:10];
    
    [note sizeToFit];
    note.backgroundColor=[UIColor clearColor];
    
    [scrollProductDetail addSubview:note];
    
    
    
    // Note Description.
    UILabel *noteDesc=[[UILabel alloc]initWithFrame:CGRectMake(xAxis + 5, note.frame.origin.y+note.frame.size.height+15,240, 20)];
    noteDesc.textAlignment = NSTextAlignmentLeft;
    [noteDesc setText:@"Item shown may not be available at your local store. To check availability please call your local store."];
    [noteDesc setTextColor:[UIColor whiteColor]];
    noteDesc.lineBreakMode = NSLineBreakByWordWrapping;
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
    
    
    
}

-(void)imageDownloaded:(NSDictionary*)imgDict {
    
    NSLog(@"crash here 1");
    if (imgDict!=nil) {
        if ([imgDict objectForKey:@"imgData"]) {
            DetailAsyncImageVIew *asyn = (DetailAsyncImageVIew*)[imgDict objectForKey:@"imgView"] ;//retain];
            [imagesArray replaceObjectAtIndex:asyn.productIndex withObject:[UIImage imageWithData:[imgDict objectForKey:@"imgData"]]];
            
            [scrollProductDetail bringSubviewToFront:imgViewZoom];
            
            
            UIImage *img = [UIImage imageWithData:[imgDict objectForKey:@"imgData"]];
            
            if ( img.size.height > 280)
            {
                imgViewMain.frame = CGRectMake(0, imgViewMain.frame.origin.y, 280, 280);

            }else {
                imgViewMain.frame = CGRectMake(0, imgViewMain.frame.origin.y, img.size.width, img.size.height);

            }
            imgViewMain.center = CGPointMake(self.view.center.x, imgViewMain.center.y);
            imgViewZoom.frame= CGRectMake(imgViewMain.frame.origin.x + imgViewMain.frame.size.width - imgViewZoom.frame.size.width, imgViewMain.frame.origin.y, imgViewZoom.frame.size.width, imgViewZoom.frame.size.height);
            
            [scrollProductDetail bringSubviewToFront:imgViewMain];
            imgViewZoom.hidden = FALSE;
            
            [asyn setImageNew:[imgDict objectForKey:@"imgData"] WithFrame:imgViewMain.frame.origin.x];
            
            
        }
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
        
        [productImageView setImage:img];
    } else {
        CGRect frame = productImageView.frame;
        frame.origin.y = 44;
        DetailAsyncImageVIew *detailImage = [[DetailAsyncImageVIew alloc]initWithFrame:frame];
        Product *p = [productsArray objectAtIndex:productIndex];
        [detailImage loadImageFromURL:[NSURL URLWithString:p.imageUrl] delegate:self requestSelector:@selector(detailImageDownloaded:)];
        
        
        
    }
    
    [delegate hideTabBar:NO];
    [self.navigationController setNavigationBarHidden:YES];
    
    [hideImage setHidden:NO];
    [showImageScrollView setHidden:NO];
}

-(IBAction)hideImage:(UIButton*)sender {
    [delegate showTabBar:NO];
    [showImageScrollView setHidden:YES];
    [showImageScrollView setZoomScale:1.0];
    [hideImage setHidden:YES];
    [productImageView setImage:nil];
    for (UIView *v in productImageView.subviews) {
        [v removeFromSuperview];
    }
}

-(void)detailImageDownloaded:(NSDictionary *)imgDict {
    if (imgDict!=nil) {
        if ([imgDict objectForKey:@"imgData"]) {
            DetailAsyncImageVIew *asyn = (DetailAsyncImageVIew*)[imgDict objectForKey:@"imgView"] ;//retain];
            UIImage *img = [UIImage imageWithData:[imgDict objectForKey:@"imgData"]];
            [imagesArray replaceObjectAtIndex:asyn.productIndex withObject:img];
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
    [sender setBackgroundImage:[UIImage imageNamed:@"NewREmoveBTn.png"] forState:UIControlStateNormal];
    [sender addTarget:self action:@selector(removeFromList:) forControlEvents:UIControlEventTouchUpInside];
    [listCountLabel setText:[NSString stringWithFormat:@"%d",[dbAgent getCount]]];
    
    [self CallForDBCount];
}

-(void)CallForDBCount{
    int count  = [dbAgent getCount];
    if (count > 0) {
        lblCount.text = [NSString stringWithFormat:@"%d",count];
        lblCount.hidden = FALSE;
        imgviewCircle.hidden = FALSE;
    }else {
        lblCount.hidden = TRUE;
        imgviewCircle.hidden = TRUE;
    }
    
}
-(IBAction)removeFromList:(UIButton*)sender {
    [dbAgent removeProductFromShoppingList:[[productsArray objectAtIndex:productIndex] productId]];
    [listCountLabel setText:[NSString stringWithFormat:@"%d",[dbAgent getCount]]];
//    if (isShoppingList) {
//        [imagesArray removeObjectAtIndex:productIndex];
//        [productsArray removeObjectAtIndex:productIndex];
//        [self refresh];
//    } else {
        [sender setBackgroundImage:[UIImage imageNamed:@"NewSavetoListBtn.png"] forState:UIControlStateNormal];
        [sender addTarget:self action:@selector(addToList:) forControlEvents:UIControlEventTouchUpInside];
        
//    }
    [self CallForDBCount];
}

-(void)refresh {
    if (productsArray.count==0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (productIndex==productsArray.count-1) {
        [self createScrollView:[productsArray objectAtIndex:productIndex]];
    } else if(productIndex<productsArray.count-1) {
        [self createScrollView:[productsArray objectAtIndex:productIndex]];
    } else if (productIndex>=productsArray.count) {
//        [self prevClicked:nil];
    }
    
}

-(IBAction)ShowShoppingListView:(id)sender
{
    [self showShoppingList];
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
    
}

#pragma mark - get tenant id

-(void)showStoreDetails{
    [self makeLoadingView];
    [self loadingView:YES];
    //
    NSString *str = NSLocalizedString(@"PRODUCT_SEARCH_IDS","");
    NSString *url= [NSString stringWithFormat:@"%@property_id=%ld", str,delegate.mallId];
    
    RequestAgent *req=[[RequestAgent alloc] init];// autorelease];
    [req requestToServer:self callBackSelector:@selector(responseSuccessForTenantID:) errorSelector:@selector(errorCallback:) Url:url];
    
    
}
-(void)responseSuccessForTenantID:(NSData *)receivedData
{
    NSLog(@"responseSuccessForTenantID");
    NSString *tanentID;
    if(receivedData!=nil)
    {
        NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];
        // test string
        Product *prod = [productsArray objectAtIndex:productIndex];
        
        NSLog(@"iiiiiiiiiddddddddd %@",prod.storeID);
        NSArray *tmpArray=[jsonString JSONValue];
        
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
    NSDictionary *tmpDict;
    BOOL breakFlag = NO;
    
    NSLog(@">>>>>>>>>list content === %@",listContent);
    
    for (NSArray *array in listContent)
    {
        for (NSDictionary *dict in array)
        {
            
            tmpDict =[dict objectForKey:@"tenant"];
            
            NSString *tempStr = [[tmpDict objectForKey:@"suite"]objectForKey:@"tenant_id"];
            NSLog(@"temp string === %@ .. %@",tempStr,tanentID);
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

-(IBAction)ShowStoreInfo:(id)sender
{
    [self settingsForGetdata];
    //        JSBridgeViewController *screenMap=[[JSBridgeViewController alloc]initWithNibName:@"JSBridgeViewController" bundle:nil];
    //				screenMap.mapUrl=[NSString stringWithFormat:@"%@/areas/getarea?suit_id=%d",[delegate.mallData objectForKey:@"resource_url"],suiteID];
    //				[self.navigationController pushViewController:screenMap animated:YES];
}

-(void)ShowImageView:(UITapGestureRecognizer*)tap {
    NSLog(@"showStoreTap");
    [self showImage];
}

-(void)showStore {
    NSLog(@"showstore");
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
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.text = @"Please wait loading stores...";
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
}

-(void)loadingView:(BOOL)flag
{
    if(flag){
        [[[UIApplication sharedApplication] keyWindow] addSubview:main_view];
        [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:main_view];
    }else
        [main_view removeFromSuperview];
}

-(void)getData {
    [self makeLoadingView];
    NSString *url=[NSString stringWithFormat:@"%@%@",[delegate.mallData objectForKey:@"resource_url"],NSLocalizedString(@"API1.1","")];
    
    RequestAgent *req=[[RequestAgent alloc] init];// autorelease];
    [req requestToServer:self callBackSelector:@selector(responseData:) errorSelector:@selector(errorCallback:) Url:url];
    [self loadingView:YES];
}

-(void)responseData:(NSData *)receivedData{
    [self loadingView:NO];
    
    if(receivedData!=nil){
        NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];
        // test string
        
        NSArray *tmpArray=[jsonString JSONValue];
        
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
                }
                else
                {
                    x=number;
                    if([[tempArray objectAtIndex:i] isEqualToString:@"Z"])
                    {
                        y=(int)[tmpArray count]-x;
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
                            y=(int)[tmpArray count] - x;
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
            
            
        }
        else{
            [delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Message" buttontitle:@"Ok"];
            
        }
    }
    else {
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
-(void)makeRequestForStringAndStoreId{
    
    [spinner setHidden:NO];
    [spinner startAnimating];
    
    int page =1;
    Product *obj=[productsArray objectAtIndex:productIndex];
    RequestAgent *req = [[RequestAgent alloc]init];
    ///change api...search
    
    
    urlString = [NSString stringWithFormat:@"%@&retailer_id=%@",delegate.searchURL,obj.storeID];
    NSLog(@"url new:::::: %@",urlString);
    NSString *url = [NSString stringWithFormat:@"%@&page=%d",urlString,page];
    [req requestToServer:self callBackSelector:@selector(requestForSearchFinishedSuccess:) errorSelector:@selector(requestError:) Url:url];
}

-(void)requestForSearchFinishedSuccess:(NSData*)responseData{
    //kuldeep edited
    NSString *jsonString = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];//autorelease];
    NSLog(@"jsong string==%@",jsonString);
    NSDictionary *dict = [jsonString JSONValue];
    NSLog(@"reply ===%@",dict);
    float totalCount = [[dict objectForKey:@"count"] longValue];
    NSArray *array = [dict objectForKey:@"results"];
    NSMutableArray *itemsArray = [[NSMutableArray alloc]initWithCapacity:array.count];
    
    for (int i=0; i<array.count; i++) {
        Product *prod = [[Product alloc]initWithValues:[[array objectAtIndex:i]objectForKey:@"SearchResult"]];
        [itemsArray addObject:prod];
        if (i==30) {
            break;
        }
    }
    
    int currentCount = (int)itemsArray.count;
    
    
    NSMutableArray *mainArray = [[NSMutableArray alloc]initWithArray:itemsArray];
    [spinner stopAnimating];
    
    if (itemsArray.count==0) {
        [delegate showAlert:@"No product matching your criteria found" title:@"No result found" buttontitle:@"Dismiss"];
    }
    
    SingleStoreSearchViewController *storeView = [[SingleStoreSearchViewController alloc]initWithNibName:@"SingleStoreSearchViewController" bundle:nil];
    NSString *storeName = [[productsArray objectAtIndex:productIndex] retailerName];
    storeView.titleString = storeName;
    
    [self.navigationItem setTitle:@"Back"];
    
    storeView.urlString = urlString;
    storeView.totalCount = totalCount;
    storeView.currentCount = currentCount;
    storeView.productsArray = [[NSMutableArray alloc]initWithArray:mainArray];
    [self.navigationController pushViewController:storeView animated:YES];
    
}

-(void)requestError:(NSError*)error {
    [delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Network error" buttontitle:@"Dismiss"];
    [spinner stopAnimating];
}

#pragma mark - nav

- (IBAction)menuBtnCall:(id)sender {
    
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;
}

- (IBAction)backBtnCall:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}

@end
