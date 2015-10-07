//
//  Product.h
//  Preit
//
//  Created by sameer on 29/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *store;
@property (nonatomic, retain) NSString *retailerName;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSString *productId;
@property (nonatomic, retain) NSString *accountId;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSString *availability;
@property (nonatomic) float price;
@property (nonatomic, retain) id imageView;
@property (nonatomic, retain) UIImage *imgMain;

@property (nonatomic, retain) NSString *storeID;

-(id)initWithValues:(NSDictionary*)dict;
-(NSComparisonResult)compareForPriceDesc:(Product*)otherProduct;
-(NSComparisonResult)compareForPrice:(Product*)otherProduct;
@end