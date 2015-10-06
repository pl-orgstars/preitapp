//
//  RequestAgent.m
//  Preit
//
//  Created by Aniket on 9/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "JSON.h"
#import "RequestAgent.h"

@implementation RequestAgent
@synthesize receivedData;
@synthesize delegate;
@synthesize callback;
@synthesize errorCallback;

@synthesize requestBody;
@synthesize isPost;

-(NSString *)stringFromDictionary:(NSDictionary *)dict
{
    NSMutableString *returnString = nil;
    for (NSString *key in [dict allKeys])
    {
        if(!returnString) {
            NSLog(@"initialize");
            returnString = [[NSMutableString alloc]initWithFormat:@"%@=%@",key,[dict valueForKey:key]];
        }
        else
        {
            NSLog(@"key and value %@ %@",key,[dict valueForKey:key]);
            [returnString appendFormat:@"&%@=%@",key,[dict valueForKey:key]];
            NSLog(@"returnstr %@",returnString);
        }
        
    }
    
    return returnString;
}
#pragma mark requestingFunction
-(void)requestToServer:(id)requestDelegate callBackSelector:(SEL)callbackSelector errorSelector:(SEL)errorSelector Url:(NSString*)URL{
	NSLog(@"URl = %@=======class==%@",URL,[requestDelegate class]);
	self.delegate = requestDelegate;
	self.callback = callbackSelector;
	self.errorCallback=errorSelector;

	NSURL *url = [NSURL URLWithString:URL];
	[self request:url];
}

#pragma mark actualRequestFunction
-(void)request:(NSURL *) url {
	theRequest   = [[NSMutableURLRequest alloc] initWithURL:url];

	if(isPost) {
        NSLog(@"post method");
		[theRequest setHTTPMethod:@"POST"];
		[theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
		[theRequest setHTTPBody:[requestBody dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
		[theRequest setValue:[NSString stringWithFormat:@"%d",[requestBody length] ] forHTTPHeaderField:@"Content-Length"];
	}
	[[NSURLCache sharedURLCache] setMemoryCapacity:0];
	[[NSURLCache sharedURLCache] setDiskCapacity:0];
	theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];

	if (theConnection) 
	{
		// Create the NSMutableData that will hold
		// the received data
		// receivedData is declared as a method instance elsewhere
		receivedData=[[NSMutableData data] retain];
	} else 
	{
		// inform the user that the download could not be made
	}
}

#pragma mark connectionDelegateMethods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	// append the new data to the receivedData
    // receivedData is declared as a method instance elsewhere

    [receivedData appendData:data];
	////NSLog(@"No response from delegate");
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
	
	[theRequest release];
	
    // inform the user
    //NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	
	NSLog(@"3.1-Error-%@",[error description]);

	if(errorCallback) {
		[delegate performSelector:errorCallback withObject:error];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
	////NSLog([[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]);
	//[delegate performSelector:self.callback withObject:receivedData];

//	NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];

//	NSLog(@"::::::::::::::::::::::::::::%@::::::::::::::::::::::::\n%@",[self.delegate class],jsonString);
	
	if(delegate && callback) {
		if([delegate respondsToSelector:self.callback]) {
			[delegate performSelector:self.callback withObject:receivedData];
		} else {
			//NSLog(@"No response from delegate");
		}
	} 
	
	// release the connection, and the data object
	[theConnection release];
    [receivedData release]; receivedData = nil;
	[theRequest release];
}

-(void) dealloc {
	[super dealloc];
}


-(void)postEmailList:(id)requestDelegate callBackSelector:(SEL)callbackSelector errorSelector:(SEL)errorSelector Url:(NSString*)URL postDict:(NSDictionary*)postDict {
    
    self.delegate = requestDelegate;
	self.callback = callbackSelector;
	self.errorCallback=errorSelector;
    
    theRequest   = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:240.0];
    

    [theRequest setHTTPMethod:@"POST"];
//		[theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [theRequest setValue:@"" forKeyPath:@""];
//		[theRequest setHTTPBody:[requestBody dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    
    NSData *postData = [NSMutableData dataWithData:[[postDict JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [theRequest setHTTPBody:postData];
    
    [theRequest setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[postData length] ] forHTTPHeaderField:@"Content-Length"];
    
	[[NSURLCache sharedURLCache] setMemoryCapacity:0];
	[[NSURLCache sharedURLCache] setDiskCapacity:0];
    
    

    
  
    
    
    NSString *requestPath = [[theRequest URL] absoluteString];
//    NSString* newStr = [[NSString alloc] initWithData:postData
//                                              encoding:NSUTF8StringEncoding];
    NSLog(@"request:::::::::::::::::::::::::::::::::::::::::::: %@ postdata \n %@",theRequest,requestPath);
    
    
    
	theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
	if (theConnection)
	{
		// Create the NSMutableData that will hold
		// the received data
		// receivedData is declared as a method instance elsewhere
		receivedData=[[NSMutableData data] retain];
	} else
	{
		// inform the user that the download could not be made
	}
}


@end
