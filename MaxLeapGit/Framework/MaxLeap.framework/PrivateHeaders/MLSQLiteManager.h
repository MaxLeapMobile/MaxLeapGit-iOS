//
//  MLSQLiteManager.h
//  MaxLeap
//
//  Created by 周和生 on 14/8/6.
//  Copyright (c) 2014年 iLegendsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MLSQLiteErrorCodes) {
	kDBNotExists,
	kDBFailAtOpen,
	kDBFailAtCreate,
	kDBErrorQuery,
	kDBFailAtClose
};

@interface MLSQLiteManager : NSObject

- (id)initWithDatabaseNamed:(NSString *)name;

// SQLite Operations
- (NSError *)openDatabase;
- (NSError *)closeDatabase;

- (NSError *)doUpdateQuery:(NSString *)sql withParams:(NSArray *)params;
- (NSArray *)getRowsForQuery:(NSString *)sql withParams:(NSArray *)params;

- (NSInteger)getLastInsertRowID;
- (NSString *)getDatabaseDump;

@end
