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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    frame.origin.y = 0;
    productListTable = [[UITableView alloc]initWithFrame:frame];
    
    [productListTable setBackgroundColor:[UIColor clearColor]];
    productListTable.delegate = self;
    productListTable.dataSource = self;
//    productListTable.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
    productListTable.backgroundColor = [UIColor clearColor];
	productListTable.separatorColor=[UIColor whiteColor];
    [self addSubview:productListTable];
    
    productListTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
//    [productListTable release];
    editFlag = 0;
    return self;
}

//-(void)dealloc {
//    [productsArray release];
//    [super dealloc];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"productsArray.count %d",productsArray.count);
    if (productsArray.count>0) {
//        if (hasMoreProducts && hasPreviousProducts) {
//            return productsArray.count + 3 ;
//        } else if (hasMoreProducts || hasPreviousProducts) {
//            return productsArray.count + 2 ;
//        } else if (isShoppingList){
//            return productsArray.count + 2;
//        } else {
            if (self.hasMoreProducts) {
                return productsArray.count + 1;
            }else{
                return productsArray.count;
            }
            
        }
//    }
    
    return 0;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] ;//autorelease];
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

//    if (isShoppingList && indexPath.row == 0){
//        // blank cell
//    }
//    else if (hasPreviousProducts && indexPath.row == 0) {
//        // load previous cell
//        
////        UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(70, 18, 14, 10)];// autorelease];
////        [arrowImage setImage:[UIImage imageNamed:@"arrow_up.png"]];
////        [arrowImage setBackgroundColor:[UIColor clearColor]];
////        [arrowImage setTag:arrowTag];
////        
////        [cell addSubview:arrowImage];
//        
//        UILabel *nextLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 17, 200, 20)];// autorelease];
//        [nextLabel setBackgroundColor:[UIColor clearColor]];
//        [nextLabel setTextColor:LABEL_TEXT_COLOR];
//        [nextLabel setFont:LABEL_TEXT_FONT];
//        [nextLabel setText:@"Show previous 30 results"];
//        [nextLabel setTag:showTag];
//        [cell addSubview:nextLabel];
//        
//    } 
//    else if (hasMoreProducts && indexPath.row == productsArray.count + hasPreviousProducts) {
//        // load more cell
//        
////        UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(70, 23, 14, 10)];// autorelease];
////        [arrowImage setImage:[UIImage imageNamed:@"arrow_down.png"]];
////        [arrowImage setBackgroundColor:[UIColor clearColor]];
////        [arrowImage setTag:arrowTag];
////        [cell addSubview:arrowImage];
//        
//        UILabel *nextLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 17, 200, 20)];// autorelease];
//        [nextLabel setBackgroundColor:[UIColor clearColor]];
//        [nextLabel setTextColor:LABEL_TEXT_COLOR];
//        [nextLabel setFont:LABEL_TEXT_FONT];
//        int diff = totalCount - currentCount;
//        [nextLabel setText:[NSString stringWithFormat:@"Show next %d results",diff>30?30:diff]];
//        [nextLabel setTag:showTag];
//        [cell addSubview:nextLabel];
//        
//    }
//    else {
        // normal cell
        
        if(indexPath.row==productsArray.count){
            
            [self createLoadMoreResultsCell:cell];
            
        }else{
            
            Product *product;
            
//            if (isShoppingList || hasPreviousProducts)
//                product = [productsArray objectAtIndex:indexPath.row - 1];
//            else
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
        
        
//    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    [cell setAlpha:.8];
    
    
    
    return cell;
}



-(void)createLoadMoreResultsCell:(UITableViewCell*)cell{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 17)] ;//autorelease];
    
    [titleLabel setCenter:cell.contentView.center];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
//    [titleLabel setNumberOfLines:3];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setTag:titleTag];
    [titleLabel setText:@"Load more 10 results"];
    [cell addSubview:titleLabel];
//    [titleLabel setBackgroundColor:[UIColor greenColor]];

    UIImage *arr = [UIImage imageNamed:@"next_arrow.png"];
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x-15, titleLabel.frame.origin.y, 17, 17)];
    [arrow setImage:arr];
    
    arrow.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    [arrow setContentMode:UIViewContentModeScaleAspectFit];
//    UIViewContentModeCenter
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
//            [imageView release];
            
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
        
        //        CGSize s = [priceLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:11.5]];
        //        float l = s.width;
        UILabel *storeLabel = [[UILabel alloc]initWithFrame:CGRectMake(arrow.frame.origin.x + 15, 40, 170, 15)];//[[[UILabel alloc]initWithFrame:CGRectMake(60 + l + 5, 40, 170, 15)] autorelease];
        [storeLabel setBackgroundColor:[UIColor clearColor]];
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
        
        UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_icon1.png"]];
        [view setTag:nextArrowTag];
        [view setFrame:CGRectMake(0, 0, 8, 14)];
        
        cell.accessoryView = view;
//        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
//        [arrow release];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (isShoppingList&&indexPath.row==0) {
//        return 47;
//    }
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
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.row==productsArray.count) {
//        [self loadMore];
//    } else {
    NSLog(@"shplist %d",indexPath.row);
//    if (indexPath.row==0) {
        [self showProductDetail:(int)indexPath.row];
//    } else {
//        [self showProductDetail:indexPath.row-1];
//    }
    
//    }
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
//    if (indexPath.row==0) {
//        return NO;
//    } else {
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
//    }
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


@end