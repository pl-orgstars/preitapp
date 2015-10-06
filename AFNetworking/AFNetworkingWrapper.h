//
//  AFNetworkingWrapper.h
//  Longtails
//
//  Created by Jawad Ahmed on 7/8/14.
//  Copyright (c) 2014 PureLogics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@protocol AFNetworkingWrapperDelegate <NSObject>

- (void) didRecieveAFNetworkResponse:(NSDictionary *) response;
- (void) didRecieveAFNetworkError:(NSError *) error;

@end

@interface AFNetworkingWrapper : NSObject

@property (assign, nonatomic) id <AFNetworkingWrapperDelegate> delegate;
@property (retain, nonatomic) AFHTTPRequestOperationManager *manager;

- (void)sendGetRequest;
- (void)sendPostRequestTo:(NSString *)URL WithParameters:(NSDictionary *)params;
- (void)sendSpecialPostRequestTo:(NSString *)URL WithParameters:(NSDictionary *)params;
- (void)uploadPhoto:(NSString*)URL withImageName:(UIImageView*)imageView andParameters:(NSMutableDictionary*)params;
- (void)uploadProfilePhoto:(NSString*)URL withImageName:(UIImageView*)imageView andParameters:(NSMutableDictionary*)params;
- (void)uploadVideoTo:(NSString *)URL withVideoURL:(NSString*)videoURL andParameters:(NSMutableDictionary *)params;

+ (void)post:(NSString *)URL
  parameters:(NSDictionary *)params
          on:(UIView *)view
  completion:(void(^)(NSDictionary *response, NSError *error))completion;

+ (void)uploadPhoto:(NSString *)URL
          withImage:(UIImage *)image
               name:(NSString *)name
         parameters:(NSDictionary *)params
                 on:(UIView *)view
         completion:(void(^)(NSDictionary *response, NSError *error))completion;

+ (void)postInBackground:(NSString *)URL parameters:(NSDictionary *)params;

@end
