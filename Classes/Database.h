//
//  Database.h
//  Preit
//
//  Created by sameer on 09/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Product.h"
#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "PreitAppDelegate.h"

@interface Database : NSObject {
    NSString *databaseName,*databasePath;
    sqlite3 *connection;
    int nextScanIdent;
    PreitAppDelegate *delegate;
}

@property sqlite3 *connection;

@property (nonatomic,retain) NSString *databaseName;
@property (nonatomic) int nextScanIdent;
@property (nonatomic,retain) NSString *databasePath;

+ (id)sharedDatabase;

- (void)addProductToShoppingList:(Product *)record;
- (void)removeProductFromShoppingList:(NSString *)pId;
- (void)emptyShoppingList;
- (NSArray *)getShoppingList;
- (BOOL)productIsPresent:(NSString*)pId;
- (int)getCount;

@end