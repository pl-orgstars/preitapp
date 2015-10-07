//
//  ProductListView.h
//  Preit
//
//  Created by sameer on 29/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "ImageLoader.h"

@interface ProductListView : UIView <UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,ImageLoaderDelegate>

@property (nonatomic,retain) NSMutableArray *productsArray;
@property (nonatomic, retain) UITableView *productListTable;
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic) BOOL isShoppingList;
@property (nonatomic, retain) NSString *nextLink;
@property (nonatomic, retain) id showProductDetailDelegate;
@property (nonatomic, retain) id loadMoreDelegate;
@property (nonatomic) SEL loadMoreSelector;
@property (nonatomic) SEL loadPreviousSelector;
@property (nonatomic) SEL showProductDetailSelector;
@property (nonatomic) SEL removeFromShListSelector;
@property (nonatomic) BOOL hasMoreProducts;
@property (nonatomic) BOOL hasPreviousProducts;
@property (nonatomic) int currentCount;
@property (nonatomic) int totalCount;
@property (nonatomic) int editFlag;
@property (nonatomic) BOOL isEditing;

-(void)refreshNow;
-(void)loadMore;
-(void)loadPrevious;
-(void)showProductDetail:(int)n;
-(void)createCell:(UITableViewCell*)cell withProduct:(Product*)product;

@end
