//
//  Database.m
//  Preit
//
//  Created by sameer on 09/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Database.h"

@implementation Database

static sqlite3_stmt *maxIdStatement;
static sqlite3_stmt *selectAllStatement;
static sqlite3_stmt *insertStatement;
static sqlite3_stmt *deleteStatement;
static sqlite3_stmt *countStatement;
static sqlite3_stmt *searchStatement;
static sqlite3_stmt *emptyStatement;

@synthesize connection;
@synthesize databaseName;
@synthesize databasePath;
@synthesize nextScanIdent;

static Database *sharedDatabase = nil;


+ (id)sharedDatabase {
    if (!sharedDatabase) {
        sharedDatabase = [[self alloc] init];
        
        BOOL success;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"PreitDB.sqlite"];
        NSLog(@"pathDB==%@",writableDBPath);
        success = [fileManager fileExistsAtPath:writableDBPath];
        if (!success) {
            // The writable database does not exist, so copy the default to the appropriate location.
            NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"PreitDB.sqlite"];
            success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
            if (!success) {
                NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
            }
        }
        NSLog(@"sharedDatabase");
        sqlite3 *connection;
        sqlite3_open([writableDBPath UTF8String], &connection);
        sharedDatabase.connection = connection;
        
        static const char *search = "SELECT COUNT(*) FROM ShoppingList WHERE productId = ?";
        sqlite3_prepare_v2(connection, search, -1, &searchStatement, NULL);
        
        static const char *count = "SELECT COUNT(*) FROM ShoppingList";
        sqlite3_prepare_v2(connection, count, -1, &countStatement, NULL);
        
        static const char *maxIdSql = "SELECT MAX(id) FROM ShoppingList";
        sqlite3_prepare_v2(connection, maxIdSql, -1, &maxIdStatement, NULL);
        
        //
        static const char *selectAllSql = "SELECT id, productId, title ,store ,imageUrl,desc,propertyId,price,accountId,storeId FROM ShoppingList ORDER BY id";
        sqlite3_prepare_v2(connection, selectAllSql, -1, &selectAllStatement, NULL);
        
        //
        static const char *insertSql = 
        "INSERT INTO ShoppingList (id, productId, title ,store ,imageUrl,desc,propertyId,price,accountId,storeId) VALUES (?,?,?,?,?,?,?,?,?,?)";
        sqlite3_prepare_v2(connection, insertSql, -1, &insertStatement, NULL);
        
        static const char *deleteSql = "DELETE FROM ShoppingList WHERE productId = ?";
        sqlite3_prepare_v2(connection, deleteSql, -1, &deleteStatement, NULL);
        
        static const char *emptySql = "DELETE FROM ShoppingList";
        sqlite3_prepare_v2(connection, emptySql, -1, &emptyStatement, NULL);
        
        if (SQLITE_ROW == sqlite3_step(maxIdStatement)) {
            int maxId = sqlite3_column_int(maxIdStatement, 0);
            sharedDatabase.nextScanIdent = maxId + 1;
            sqlite3_reset(maxIdStatement);
        } else {
            NSLog(@"failed to read max ID from database\n");
        }
        
    }
    return sharedDatabase;
}


- (void)addProductToShoppingList:(Product *)product {
    delegate = (PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
    sqlite3_bind_int(insertStatement, 1, nextScanIdent++);
    sqlite3_bind_text(insertStatement, 2, [product.productId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertStatement, 3, [product.title UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertStatement, 4, [product.store UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertStatement, 5, [product.imageUrl UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertStatement, 6, [product.desc UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(insertStatement, 7, delegate.mallId);
    sqlite3_bind_double(insertStatement, 8, product.price);
    sqlite3_bind_text(insertStatement, 9, [product.accountId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 10, [product.storeID UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_step(insertStatement);
    sqlite3_reset(insertStatement);
    
    NSLog(@"product added");
}

- (void)removeProductFromShoppingList:(NSString *)pId {
    sqlite3_bind_text(deleteStatement, 1, [pId UTF8String], -1, SQLITE_TRANSIENT);
    int result = sqlite3_step(deleteStatement);
    NSLog(@"delete result %d",result);
    sqlite3_reset(deleteStatement);
}

-(void)emptyShoppingList {
    sqlite3_step(emptyStatement);
}

-(NSArray *)getShoppingList {
    NSMutableArray *records = [NSMutableArray array];
    while (SQLITE_ROW == sqlite3_step(selectAllStatement)) {
        
//        int _id = sqlite3_column_int(selectAllStatement, 0);
        NSString *productId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectAllStatement, 1)];
        NSString *store = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectAllStatement, 3)];
        NSString *title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectAllStatement, 2)];
        NSString *imgaeUrl = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectAllStatement, 4)];
        NSString *desc = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectAllStatement, 5)];
        float price = sqlite3_column_double(selectAllStatement, 7);
        NSString *accountId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectAllStatement, 8)];
        
        NSString *storeId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectAllStatement, 9)];
        
        Product *prod = [[Product alloc]init];        
        prod.title = title;
        prod.store = store;
        prod.productId = productId;
        prod.imageUrl = imgaeUrl;
        prod.desc = desc;
        prod.price = price;
        prod.accountId = accountId;
        
        prod.storeID = storeId;
        [records addObject:prod];
//        [prod release];
    }
    sqlite3_reset(selectAllStatement);
    return records;

}


-(int)getCount {
    sqlite3_step(countStatement);
    int count = sqlite3_column_int(countStatement, 0);
    sqlite3_reset(countStatement);
    return count;
}

-(BOOL)productIsPresent:(NSString*)pId {
    NSLog(@"productid %@",pId);
    sqlite3_bind_text(searchStatement, 1, [pId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_step(searchStatement);
    int prCount = sqlite3_column_int(searchStatement, 0);
    NSLog(@"presentcount %d",prCount);
    sqlite3_reset(searchStatement);
    return prCount>0?YES:NO;
}

@end
