//
//  AFNetworkingWrapper.m
//  Longtails
//
//  Created by Jawad Ahmed on 7/8/14.
//  Copyright (c) 2014 PureLogics. All rights reserved.
//

#import "AFNetworkingWrapper.h"

@implementation AFNetworkingWrapper

@synthesize delegate, manager;

- (id) init                         
{
    self = [super init];
    if (self){
        
        manager = [AFHTTPRequestOperationManager manager];
    }
    
    return self;
}

/**************************************************************************************************/
#pragma mark - Protocol

- (void) sendRespnseToDelegate:(NSDictionary *) response
{
    NSLog(@"%@", self.delegate);
    
    NSLog(@"delegate = %@ and response = %@", delegate, response);
    if (delegate && [delegate respondsToSelector:@selector(didRecieveAFNetworkResponse:)])
    {
       UIViewController *controller = (UIViewController *)delegate;
       [self hideActivityIndicatorFrom:controller];
        
        [delegate performSelector:@selector(didRecieveAFNetworkResponse:) withObject:response];
    }
}

- (void) sendErrorToDelegate:(NSError *) error
{
    NSLog(@"%@", error);
    
    if (delegate && [delegate respondsToSelector:@selector(didRecieveAFNetworkError:)])
    {        UIViewController *controller = (UIViewController *)delegate;
        [self hideActivityIndicatorFrom:controller];
        
        [delegate performSelector:@selector(didRecieveAFNetworkError:) withObject:error];
    }
}

/**************************************************************************************************/
#pragma mark - Private Methods

- (void) sendGetRequest
{
    UIViewController *controller = (UIViewController *)delegate;
    [self showActivityIndicatorOn:controller withLoadingTitle:@"Loading..."];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [self sendRespnseToDelegate:responseObject];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self sendErrorToDelegate:error];
    }];
}

- (void) sendPostRequestTo:(NSString *)URL WithParameters:(NSDictionary *)params
{
    UIViewController *controller = (UIViewController *)delegate;
    [self showActivityIndicatorOn:controller withLoadingTitle:@"Loading..."];
    
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", kServerURL, URL];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

        [manager POST:fullURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [self sendRespnseToDelegate:responseObject];
         
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
             NSLog(@"%@", operation.responseString);
             [self sendErrorToDelegate:error];
         }];
 

}

- (void) sendSpecialPostRequestTo:(NSString *)URL WithParameters:(NSDictionary *)params
{
    UIViewController *controller = (UIViewController *)delegate;
    [self showActivityIndicatorOn:controller withLoadingTitle:@"Finding Images..."];
    
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", kServerURL, URL];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:fullURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self sendRespnseToDelegate:responseObject];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         [self sendErrorToDelegate:error];
     }];
    
    
}

-(void)uploadPhoto:(NSString*)URL withImageName:(UIImageView*)imageView andParameters:(NSMutableDictionary*)params
{
    UIViewController *controller = (UIViewController *)delegate;
    [self showActivityIndicatorOn:controller withLoadingTitle:@"Loading..."];
    
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", @"https://api.ziploop.com/partner/1/upload", URL];
    
    NSData *imageData = UIImageJPEGRepresentation(imageView.image, 0.5);
    
    
    AFHTTPRequestOperation *op = [manager POST:fullURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                  {
                                      //do not put image inside parameters dictionary as I did, but append it!
                                      [formData appendPartWithFileData:imageData name:@"wave_photo" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
                                      
                                  }
                                       success:^(AFHTTPRequestOperation *operation, id responseObject)
                                  {
                                      [self sendRespnseToDelegate:responseObject];
                                      
                                  }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                  {
                                      [self sendErrorToDelegate:error];
                                  }];
    [op start];
}


-(void)uploadProfilePhoto:(NSString *)URL withImageName:(UIImageView *)imageView andParameters:(NSMutableDictionary *)params {
    UIViewController *controller = (UIViewController *)delegate;
    [self showActivityIndicatorOn:controller withLoadingTitle:@"Loading..."];
    
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", kServerURL, URL];
    
    NSData *imageData = UIImageJPEGRepresentation(imageView.image, 0.5);
    
    
    AFHTTPRequestOperation *op = [manager POST:fullURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                  {
                                      //do not put image inside parameters dictionary as I did, but append it!
                                      [formData appendPartWithFileData:imageData name:@"user_photo" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
                                      
                                  }
                                       success:^(AFHTTPRequestOperation *operation, id responseObject)
                                  {
                                      [self sendRespnseToDelegate:responseObject];
                                      
                                  }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                  {
                                      [self sendErrorToDelegate:error];
                                  }];
    [op start];
}

-(void)uploadVideoTo:(NSString *)URL withVideoURL:(NSString*)videoURL andParameters:(NSMutableDictionary *)params
{
//    [self showActivityIndicatorOn:controller withLoadingTitle:@"Uploading..."];
    
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", kServerURL, URL];
    NSData *videoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:videoURL]];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    AFHTTPRequestOperation *op = [manager POST:fullURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                  {
                                      [formData appendPartWithFileData:videoData name:@"wave_video" fileName:@"video.mov" mimeType:@"video/quicktime"];
                                  }
                                       success:^(AFHTTPRequestOperation *operation, id responseObject)
                                  {
                                      [CustomAlertView showAlertViewWithTitle:@"Success" andMessage:@"Your Video is Uploaded"];
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateHomeView" object:nil];
                                  }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                  {
                                      [self sendErrorToDelegate:error];
                                  }];
    
    [op setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite) {
        double percentage = ((double)totalBytesWritten/totalBytesExpectedToWrite) * 100;
//        [self showActivityIndicatorOn:controller withLoadingTitle:[NSString stringWithFormat:@"Uploading %.0f %%", percentage]];
        NSLog(@"Uploading %f %%", percentage);
    }];
    
    [op start];
}

+ (void)post:(NSString *)URL parameters:(NSDictionary *)params on:(UIView *)view completion:(void(^)(NSDictionary *response, NSError *error))completion {
    AFHTTPRequestOperationManager *manager_ = [AFHTTPRequestOperationManager manager];
    manager_.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", kServerURL, URL];
    [Utilities showActivityIndicatorOn:view withLoadingTitle:@"Loading..."];
    [manager_ POST:fullURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"API Response = %@", responseObject);
        [Utilities hideActivityIndicatorFrom:view];
        
        completion(responseObject, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"API Error = %@", error);
        [Utilities hideActivityIndicatorFrom:view];
        
        completion(nil, error);
    }];
}

+ (void)uploadPhoto:(NSString *)URL withImage:(UIImage *)image name:(NSString *)name parameters:(NSDictionary *)params on:(UIView *)view completion:(void(^)(NSDictionary *response, NSError *error))completion {
    AFHTTPRequestOperationManager *manager_ = [AFHTTPRequestOperationManager manager];
    manager_.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", kServerURL, URL];
    [Utilities showActivityIndicatorOn:view withLoadingTitle:@"Loading..."];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    AFHTTPRequestOperation *op = [manager_ POST:fullURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:imageData name:name fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    }
                                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            NSLog(@"API Response = %@", responseObject);
                                            [Utilities hideActivityIndicatorFrom:view];
                                            
                                            completion(responseObject, nil);
                                        }
                                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            NSLog(@"API Error = %@", error);
                                            [Utilities hideActivityIndicatorFrom:view];
                                            
                                            completion(nil, error);
                                        }];
    [op start];
}

+ (void)postInBackground:(NSString *)URL parameters:(NSDictionary *)params {
    AFHTTPRequestOperationManager *manager_ = [AFHTTPRequestOperationManager manager];
    manager_.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", kServerURL, URL];
    [manager_ POST:fullURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"API Response = %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"API Error = %@", error);
    }];
}

/**************************************************************************************************/
#pragma mark - Activity Indicator Methods

- (void) showActivityIndicatorOn:(UIViewController *)viewController withLoadingTitle:(NSString *) title
{
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
    {
        // Do Nothing
    }
    else
    {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    }
    
    UIView *screen = [viewController view];
    viewController.navigationItem.leftBarButtonItem.enabled = NO;
    
    UIView *activityIndicatorBg = nil;
    UIActivityIndicatorView *activityIndicator = nil;
    UILabel *activityLoadingText = nil;
    
    CGPoint point = CGPointMake(screen.frame.size.width/2, screen.frame.size.height/2);
    
    if (![screen viewWithTag:1001] && ![screen viewWithTag:1002] && ![screen viewWithTag:1003])
    {
        activityIndicatorBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewController.view.frame.size.width, [UIScreen mainScreen].bounds.size.height)];
        [activityIndicatorBg setBackgroundColor:[UIColor blackColor]];
        [activityIndicatorBg setAlpha:0.5];
        [activityIndicatorBg setTag:1001];
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicator setCenter:point];
        [activityIndicator setTag:1002];
        [activityIndicator startAnimating];
        
        activityLoadingText = [[UILabel alloc] initWithFrame:CGRectMake(117, 270, 320, 21)];
        [activityLoadingText setText:title];
        [activityLoadingText setTextColor:[UIColor whiteColor]];
        [activityLoadingText setTextAlignment:NSTextAlignmentCenter];
        [activityLoadingText setCenter:CGPointMake(point.x, point.y + 30)];
        [activityLoadingText setTag:1003];
        
        [activityIndicatorBg addSubview:activityIndicator];
        [activityIndicatorBg addSubview:activityLoadingText];
        
        [[viewController view] addSubview:activityIndicatorBg];
    }
    else
    {
        // Just change the label text
        activityLoadingText = (UILabel *)[screen viewWithTag:1003];
        activityLoadingText.text = title;
    }
}

- (void) hideActivityIndicatorFrom:(UIViewController *) viewController
{
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
    {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
    
    UIView *screen = [viewController view];
    viewController.navigationItem.leftBarButtonItem.enabled = YES;
    
    UIView *activityIndicatorBg = [screen viewWithTag:1001];
    UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[screen viewWithTag:1002];
    UILabel *activityLoadingText = (UILabel *)[screen viewWithTag:1003];
    
    [activityLoadingText removeFromSuperview];
    
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    
    [activityIndicatorBg removeFromSuperview];
}

@end
