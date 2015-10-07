//
//  ProductListView.m
//  Preit
//
//  Created by sameer on 29/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define imageTag 1
#define titleTag 2
#define priceTag 3
#define storeTag 4
#define showTag 5
#define arrowTag 6
#define nextArrowTag 7

#define editCellLength 40

#import "ProductListView.h"
#import "AsyncImageView.h"
#import "ProductSearchCC.h"

@implementation ProductListView

@synthesize isEditing;
@synthesize editFlag;
@synthesize removeFromShListSelector;
@synthesize currentCount;
@synthesize totalCount;
@synthesize loadPreviousSelector;
@synthesize hasPreviousProducts;
@synthesize productsArray;
@synthesize productListTable;
@synthesize isShoppingList;
@synthesize nextLink;
@synthesize loadMoreDelegate;
@synthesize loadMoreSelector;
@synthesize hasMoreProducts;
@synthesize showProductDetailDelegate;
@synthesize showProductDetailSelector;
@synthesize collectionView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    frame.origin.y = 0;
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(160  , 200.0);
    layout.minimumInteritemSpacing = 0.0;
    layout.minimumLineSpacing = 5.0;
//    collectionView.collectionViewLayout = layout;

    
     collectionView= [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:layout];
    
    [collectionView setBackgroundColor:[UIColor yellowColor]];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self addSubview:collectionView];

    [collectionView registerNib:[UINib nibWithNibName:@"ProductSearchCC" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ProductSearchCC"];

    
    [collectionView reloadData];
    
    
    
//    productListTable = [[UITableView alloc]initWithFrame:frame];
//    
//    [productListTable setBackgroundColor:[UIColor clearColor]];
//    productListTable.delegate = self;
//    productListTable.dataSource = self;
//    productListTable.backgroundColor = [UIColor clearColor];
//	productListTable.separatorColor=[UIColor whiteColor];
//    [self addSubview:productListTable];
    
//    productListTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    editFlag = 0;
    return self;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (productsArray.count > 0)
    {
            if (self.hasMoreProducts) {
                return productsArray.count + 1;
            }else{
                return productsArray.count;
            }
            
    }
    
    return 0;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] ;
        } else {
            [[cell viewWithTag:imageTag]removeFromSuperview];
            [[cell viewWithTag:titleTag]removeFromSuperview];
            [[cell viewWithTag:priceTag]removeFromSuperview];
            [[cell viewWithTag:storeTag]removeFromSuperview];
            [[cell viewWithTag:showTag]removeFromSuperview];//
            [[cell viewWithTag:arrowTag]removeFromSuperview];//
            [[cell viewWithTag:nextArrowTag]removeFromSuperview];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
    }


        
        if(indexPath.row==productsArray.count){
            
            [self createLoadMoreResultsCell:cell];
            
        }else{
            
            Product *product;
            
            product = [productsArray objectAtIndex:indexPath.row];
            
            [self createCell:cell withProduct:product];
            
            
            if (editFlag==1) {
                for (UIView *view in cell.subviews) {
                    
                    if (view.tag==imageTag||view.tag==titleTag||view.tag==priceTag||view.tag==storeTag||view.tag==showTag||view.tag==arrowTag||view.tag==nextArrowTag) {
                        CGRect frame = view.frame;
                        frame.origin.x+=editCellLength;
                        [view setFrame:frame];
                    }
                }
            }
            
        }
        
    
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    [cell setAlpha:.8];
    
    
    
    return cell;
}



-(void)createLoadMoreResultsCell:(UITableViewCell*)cell{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 17)] ;//autorelease];
    
    [titleLabel setCenter:cell.contentView.center];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setTag:titleTag];
    [titleLabel setText:@"Load more 10 results"];
    [cell addSubview:titleLabel];

    UIImage *arr = [UIImage imageNamed:@"next_arrow.png"];
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x-15, titleLabel.frame.origin.y, 17, 17)];
    [arrow setImage:arr];
    
    arrow.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    [arrow setContentMode:UIViewContentModeScaleAspectFit];
    [arrow setTag:nextArrowTag];
    [cell addSubview:arrow];
    
    cell.accessoryView = nil;

}


-(void)createCell:(UITableViewCell*)cell withProduct:(Product*)product {
    {
        
        if (product.imageView == nil) {
            AsyncImageView *imageView = [[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 60)];
            [imageView loadImageFromURL:[NSURL URLWithString:product.imageUrl] delegate:imageView requestSelector:@selector(setImage2:)];
            [imageView setBackgroundColor:[UIColor clearColor]];
            [imageView setTag:imageTag];
            [cell addSubview:imageView];    
            product.imageView = imageView;
            
        } else {
            [product.imageView setFrame:CGRectMake(0, 0, 50, 60)];
            [cell addSubview:product.imageView];
        }
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 220, 40)] ;//autorelease];
        [titleLabel setNumberOfLines:3];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:11.5]];
        [titleLabel setTextColor:LABEL_TEXT_COLOR];
        [titleLabel setTag:titleTag];
        [titleLabel setText:product.title];
        
        [cell addSubview:titleLabel];
        
        UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 40, 65, 15)] ;//autorelease];
        [priceLabel setBackgroundColor:[UIColor clearColor]];
        [priceLabel setFont:[UIFont boldSystemFontOfSize:11.5]];
        [priceLabel setTextColor:LABEL_TEXT_COLOR];
        [priceLabel setTag:priceTag];
        [priceLabel setText:[NSString stringWithFormat:@"$%.2f",product.price]];
        [priceLabel sizeToFit];
        [cell addSubview:priceLabel];
        
        UIImage *arr = [UIImage imageNamed:@"next_arrow.png"];
        UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(priceLabel.frame.origin.x+priceLabel.frame.size.width+4, priceLabel.frame.origin.y - 1, 10, 15)];
        [arrow setImage:arr];
        [arrow setTag:nextArrowTag];
        [cell addSubview:arrow];
        
        UILabel *storeLabel = [[UILabel alloc]initWithFrame:CGRectMake(arrow.frame.origin.x + 15, 40, 170, 15)];        [storeLabel setBackgroundColor:[UIColor clearColor]];
        [storeLabel setFont:[UIFont boldSystemFontOfSize:11.5]];
        [storeLabel setTextColor:LABEL_TEXT_COLOR];
        [storeLabel setTag:storeTag];
        if (self.isShoppingList) {
            
            NSArray *stringArray = [product.store componentsSeparatedByString:@"-"];
            
            NSString *retailerNameString = [[stringArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            [storeLabel setText:retailerNameString];
            [storeLabel setText:retailerNameString];
            
        }else{
            
            [storeLabel setText:product.retailerName];
        }
        [cell addSubview:storeLabel];
        
//        UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_icon1.png"]];
//        [view setTag:nextArrowTag];
//        [view setFrame:CGRectMake(0, 0, 8, 14)];
//        
//        cell.accessoryView = view;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.4;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"shplist %d",isShoppingList);    
    if (isShoppingList) {
        [self showProductDetail:indexPath.row];
    } else {
        if (hasPreviousProducts && indexPath.row == 0) {
            [self loadPrevious];
        } else if (indexPath.row==productsArray.count + hasPreviousProducts) {
            [self loadMore];
        } else {
            
            if (indexPath.row == productsArray.count) {
                
                [self loadMore];
                
            }else{
                
                [self showProductDetail:indexPath.row];
            }
            
        }
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
        [self showProductDetail:(int)indexPath.row];
}


-(void)showEditBtnOnCell:(UITableViewCell*)cell {
    for (UIView *view in cell.subviews) {
        
        if (view.tag==imageTag||view.tag==titleTag||view.tag==priceTag||view.tag==storeTag||view.tag==showTag||view.tag==arrowTag||view.tag==nextArrowTag) {
            CGRect frame = view.frame;
            frame.origin.x+=editCellLength;
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                [view setFrame:frame];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

-(void)hideEditBtnOnCell:(UITableViewCell*)cell {
    for (UIView *view in cell.subviews) {
        
        if (view.tag==imageTag||view.tag==titleTag||view.tag==priceTag||view.tag==storeTag||view.tag==showTag||view.tag==arrowTag||view.tag==nextArrowTag) { 
            CGRect frame = view.frame;
            frame.origin.x-=editCellLength;
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                [view  setFrame:frame];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!removeFromShListSelector) {
        return NO;
    }
        if (isEditing) {
            if (editFlag == 1) {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [self showEditBtnOnCell:cell];
            } else if (editFlag == 2) {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [self hideEditBtnOnCell:cell];
            }
        }
        return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"indexPath.row======%ld",(long)indexPath.row);
    
    [showProductDetailDelegate performSelector:removeFromShListSelector withObject:[NSNumber numberWithInt:(int)indexPath.row]];
}

-(void)loadMore {
    
    if ([loadMoreDelegate respondsToSelector:loadMoreSelector]) {
        [loadMoreDelegate performSelector:loadMoreSelector];
    }
}

-(void)showProductDetail:(int)n {
    if ([showProductDetailDelegate respondsToSelector:showProductDetailSelector]) {
        [showProductDetailDelegate performSelector:showProductDetailSelector withObject:[NSNumber numberWithInt:n]] ;
    }
}

-(void)loadPrevious {
    if ([loadMoreDelegate respondsToSelector:loadPreviousSelector]) {
        [loadMoreDelegate performSelector:loadPreviousSelector];
    }
}

-(void)refreshNow{
    
    [productListTable reloadData];
    
}


/// UIcollectationView
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return productsArray.count;
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView1 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductSearchCC *cellcustom = [collectionView1 dequeueReusableCellWithReuseIdentifier:@"ProductSearchCC" forIndexPath:indexPath];
    Product *product;
    
    product = [productsArray objectAtIndex:indexPath.row];
    NSLog(@"index %d==%@",(int)indexPath.row,product.imgMain);
    cellcustom.imageViewMain.image = nil;
    if (!product.imgMain)
    {
        ImageLoader *imgLoader = [[ImageLoader alloc] init];
        imgLoader.indexPath = indexPath;
        imgLoader.delegate = self;
        [imgLoader loadImage:product.imageUrl];

        
    } else
    {
        NSLog(@"index Inner %d==%@",(int)indexPath.row,product.imgMain);
        cellcustom.imageViewMain.image = product.imgMain;
    }



    UIButton *btn = cellcustom.btnAdd;
    [cellcustom.btnAdd removeFromSuperview];
    [cellcustom addSubview:btn];
    
    
    cellcustom.btnAdd.tag =indexPath.row;
    [cellcustom.btnAdd addTarget:self action:@selector(AddMe:) forControlEvents:UIControlEventTouchUpInside];
    
    cellcustom.lblName.text = product.title;
    cellcustom.lblDisc.text = product.retailerName;
    cellcustom.lblPrice.text = [NSString stringWithFormat:@"$%.2f",product.price];
   
    NSLog(@"");
    
    return cellcustom;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self showProductDetail:(int)indexPath.row];
}

-(IBAction)AddMe:(UIButton *)btnSender
{
    Product *product;
    
    product = [productsArray objectAtIndex:btnSender.tag];

    NSLog(@"%@ ",product.title);
}


-(void) imgLoader:(ImageLoader *)imgLoader processImage:(UIImage *)img indexPath:(NSIndexPath *)imgIndexPath
{
    if (img)
    {
        ProductSearchCC *cell = (ProductSearchCC*)[collectionView cellForItemAtIndexPath:imgIndexPath];
//        cell.activity.hidden=TRUE;
//        [cell.activity stopAnimating];
        UIImageView *mainInage;
        Product *product;
        product = [productsArray objectAtIndex:imgIndexPath.row];
        
        product.imgMain = img;
        
        mainInage= cell.imageViewMain;
        mainInage.image = img;
        product.imageView = mainInage;
        
    }
}


@end