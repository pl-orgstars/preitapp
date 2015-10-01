//
//  PinterestWebViewController.m
//  Preit
//
//  Created by charan on 5/9/13.
//
//

#import "PinterestWebViewController.h"

@interface PinterestWebViewController ()

@end

@implementation PinterestWebViewController
@synthesize imageUrl;
@synthesize searchUrl;
@synthesize description;

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
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setHidesWhenStopped:YES];
    [spinner setCenter:self.view.center];
    [self.view addSubview:spinner];
    [spinner stopAnimating];
    
    [self postToPinterest];
    

}
//- (void)pinIt:(id)sender
//{
//    Pinterest *_pinterest = [[Pinterest alloc]init];
//    NSURL *url = [NSURL URLWithString:imageUrl];
//    NSURL *urll = [NSURL URLWithString:searchUrl];
//    [_pinterest createPinWithImageURL:url
//                            sourceURL:urll
//                          description:description];
//}
- (void)viewWillDisappear:(BOOL)animated{
    spinner = nil;
    [webViewToShareWithPinterest stopLoading];
    imageUrl = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) postToPinterest {
    
    NSString *htmlString = [self generatePinterestHTMLForSKU:self.imageUrl];
    
    NSLog(@"Generated HTML String:%@", htmlString);
    //    WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    [webViewToShareWithPinterest loadHTMLString:htmlString baseURL:nil] ;
//    [htmlString release];
    //    webViewController.showSpinner = YES;
    
    //    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentModalViewController:webViewController animated:YES];
}
- (NSString*) generatePinterestHTMLForSKU:(NSString*)sUrl {
//    NSString *description = @"Post your description here";
    
    // Generate urls for button and image
//    NSString *sUrl = @"http://img.thefind.com/images/YgB75HVt5zSGaQwSfxgZMlITc0oy4hPzUuKTUhNLSyoZMkpKCqz09VMyDfWKM_ILCjLz0vWS83P1M3MT01OL9Qsy9c2S9VOT9JPT9C0tjC2Mzc0MdU0NDCpMLC11DXQN9LIK0hkA";//[NSString stringWithFormat:@"http://d30t6wl9ttrlhf.cloudfront.net/media/catalog/product/Heros/%@-1.jpg", sku];
    NSLog(@"URL:%@", sUrl);
//    NSString *protectedUrl = ( NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,( CFStringRef)sUrl, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    NSString *protectedUrl = ( NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,( CFStringRef)sUrl, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    
    NSString *searchUrll = ( NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,( CFStringRef)self.searchUrl, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    
    NSLog(@"Protected URL:%@", protectedUrl);
    NSString *imageUrls = [NSString stringWithFormat:@"\"%@\"", sUrl];

    NSString *buttonUrl = [NSString stringWithFormat:@"\"http://pinterest.com/pin/create/button/?url=%@&media=%@&description=%@\"",searchUrll, protectedUrl, self.description];// ,self.searchUrl];
    

    
//    NSString *buttonUrl = [NSString stringWithFormat:@"\"http://pinterest.com/pin/create/button/?url=www.flor.com&media=%@&description=%@\"", protectedUrl, self.description];
//http://pinterest.com/pin/313000242822951647/

//    NSString *buttonUrl = [NSString stringWithFormat:@"\"http://pinterest.com/pin/create/button/?url=www.flor.com&media=%@&description=%@ \n%@\"", protectedUrl, self.description,self.searchUrl];
    
    NSMutableString *htmlString = [[NSMutableString alloc] initWithCapacity:1000];
    [htmlString appendFormat:@"<html> <body>"];
    [htmlString appendFormat:@"<p align=\"center\"><a href=%@ class=\"pin-it-button\" count-layout=\"horizontal\"><img border=\"0\" src=\"http://assets.pinterest.com/images/PinExt.png\" title=\"Pin It\" /></a></p>", buttonUrl];
    [htmlString appendFormat:@"<p align=\"center\"><img width=\"200px\" height = \"200px\" src=%@></img></p>", imageUrls];
    [htmlString appendFormat:@"<script type=\"text/javascript\" src=\"//assets.pinterest.com/js/pinit.js\"></script>"];
    [htmlString appendFormat:@"</body> </html>"];
//    [protectedUrl release];
//    [description release];
//    [imageUrls release];
//    [buttonUrl release];
    return htmlString;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
   
    if ( [webView isLoading]) {
        // If we want to show Spinner, we show it everyTime
        [spinner startAnimating];
//        [self.navigationController.navigationBar setUserInteractionEnabled:NO];

    }
    
//    if (!spinner.isAnimating) {
//        // If we want to show Spinner, we show it everyTime
//
//        [self.navigationController.navigationBar setUserInteractionEnabled:YES];
//        
//    }
    
    //    }
    //    else {
    //        // If we don't -> we show it only once (some sites annoy with it)
    //        if (!spinnerWasShown) {
    //            [UIHelper startShowingSpinner:self.webView];
    //            spinnerWasShown = YES;
    //        }
    //    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");

//    [spinner stopAnimating];
    if (![webView isLoading]) {
//
        [spinner stopAnimating];
//        [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    }

}
//-(void)dealloc{
//    [super dealloc];
//    [spinner release];
//    [webViewToShareWithPinterest release];
//    [imageUrl release];
//}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [spinner stopAnimating];
//    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
}
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
    NSLog(@"working");
    if (spinner.isAnimating) {
        return NO;
    }
    return YES;
}
@end
