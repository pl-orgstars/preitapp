//
//  Product.m
//  Preit
//
//  Created by sameer on 29/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Product.h"

@implementation Product

@synthesize price;
@synthesize title;
@synthesize store;
@synthesize imageUrl;
@synthesize productId;
@synthesize accountId;
@synthesize desc;
@synthesize availability;
@synthesize imageView;
@synthesize retailerName;
@synthesize storeID;
@synthesize imgMain;

//-(id)initWithValues:(NSDictionary *)dict {
//    self = [super init];
//    if (self) {
////        NSLog(@"proddict %@",dict);
//        productId = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"googleId"]];
//        title = [[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"title"]];
//        desc = [[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"description"]];
//        price = [[[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"price"] ] floatValue]; 
//        imageUrl = [[NSString alloc] initWithFormat:@"%@",[[dict objectForKey:@"images"] objectAtIndex:0]];
//        store = [[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"accountName"]];
//        accountId = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"accountId"]];
//    }
//    return self;
//}
/*
productId = SearchResult->product->id
 title = SearchResult->product->name
 desc = SearchResult->product->descriptionLong
 imageUrl = SearchResult->product->images
 store = SearchResult->product->images[0]->ImageInfo->link
 price = price
 store = SearchResult->location->name
accountId = SearchResult->location->id
 storeID =location->retailer->id
 */
-(id)initWithValues:(NSDictionary *)dict {
    self = [super init];
    if (self) {
       NSLog(@"proddict %@",dict);
        
        NSDictionary *dict2 = [[dict objectForKey:@"location"] objectForKey:@"retailer"];
        
        productId = [[NSString alloc] initWithFormat:@"%@",[[dict objectForKey:@"product"]objectForKey:@"id"]];
        title = [[NSString alloc] initWithFormat:@"%@",[[dict objectForKey:@"product"]objectForKey:@"name"]];
        desc = [[NSString alloc] initWithFormat:@"%@",[[dict objectForKey:@"product"]objectForKey:@"descriptionLong"]];
        price = [[[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"price"] ] floatValue];

        store = [[NSString alloc] initWithFormat:@"%@",[[dict objectForKey:@"location"] objectForKey:@"name"]];
        
            imageUrl = [[NSString alloc] initWithFormat:@"%@",[[[[[dict objectForKey:@"product"]objectForKey:@"images"] objectAtIndex:0] objectForKey:@"ImageInfo"] objectForKey:@"link"]]; //objectAtIndex:0]];
        
        retailerName = [[NSString alloc] initWithFormat:@"%@",[dict2 objectForKey:@"name"]];
        
        accountId = [[NSString alloc]initWithFormat:@"%@",[[dict objectForKey:@"location"] objectForKey:@"id"]];
        
        storeID = [[NSString alloc]initWithFormat:@"%@",[[[dict objectForKey:@"location"] objectForKey:@"retailer"] objectForKey:@"id"]];
    }
    return self;
}

-(NSComparisonResult)compareForPrice:(Product *)otherProduct {
    return price>otherProduct.price;
}

-(NSComparisonResult)compareForPriceDesc:(Product *)otherProduct {
    return price<otherProduct.price;
}

@end
