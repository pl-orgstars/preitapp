//
//  RequestAgent.h
//  Preit
//
//  Created by Aniket on 9/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RequestAgent : NSObject {

	NSMutableData		*receivedData;
	NSMutableURLRequest	*theRequest;
	NSURLConnection		*theConnection;
	id					delegate;
	SEL					callback;
	SEL					errorCallback;
	
	BOOL				isPost;
	NSString			*requestBody;
	
}

@property(nonatomic, retain) NSMutableData *receivedData;
@property(nonatomic, retain) id			    delegate;
@property(nonatomic) SEL					callback;
@property(nonatomic) SEL					errorCallback;

@property(nonatomic,strong) NSString *requestBody;
@property(nonatomic)BOOL isPost;

-(void)requestToServer:(id)requestDelegate callBackSelector:(SEL)callbackSelector errorSelector:(SEL)errorSelector Url:(NSString*)URL;
-(void)request:(NSURL *) url;

-(NSString *)stringFromDictionary:(NSDictionary *)dict;

-(void)postEmailList:(id)requestDelegate callBackSelector:(SEL)callbackSelector errorSelector:(SEL)errorSelector Url:(NSString*)URL postDict:(NSDictionary*)postDict;

@end
