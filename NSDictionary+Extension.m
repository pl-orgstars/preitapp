//
//  NSDictionary+Extension.m
//  Qwerkii
//
//  Created by kuldeep on 7/15/14.
//  Copyright (c) 2014 Evontech. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)
-(id)objectForKeyWithNullCheck:(id)aKey{
    id value = [self objectForKey:aKey];
    if (value == [NSNull null] || value == nil ||
        value == NULL ||
        value == Nil ||
        [value isKindOfClass:[NSNull class]]) {
        
        return nil;
        
        
    }else{
        return value;
        
    }
}
-(id)valueForKeyWithNullCheck:(NSString *)akey{
    id value = [self valueForKey:akey];
    if (value == [NSNull null] || value == nil ||
        value == NULL ||
        value == Nil ||
        [value isKindOfClass:[NSNull class]]) {
        
        return nil;
        
        
    }else{
        return [self valueForKey:akey];
        
    }
}
@end
