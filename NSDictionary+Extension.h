//
//  NSDictionary+Extension.h
//  Qwerkii
//
//  Created by kuldeep on 7/15/14.
//  Copyright (c) 2014 Evontech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extension)
-(id)objectForKeyWithNullCheck:(id)aKey;
-(id)valueForKeyWithNullCheck:(NSString *)akey;
@end
