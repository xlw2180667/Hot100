//
//  SongListDatabase.h
//  SongList
//
//  Created by 谢 砾威 on 12/04/16.
//  Copyright © 2016 谢 砾威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SongListDatabase : NSObject

@property (nonatomic, strong) NSMutableArray *arrayColumnNames;

@property (nonatomic) int affectedRows;

@property (nonatomic) long long lastInsertedRowID;

- (instancetype) initWithDatabasefileName:(NSString *) databasefilename;

- (NSArray *) loadingDataFromDatabase:(NSString *) query;

- (void) executeQuery:(NSString *) query;


@end
