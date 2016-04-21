//
//  SongListDatabase.m
//  SongList
//
//  Created by 谢 砾威 on 12/04/16.
//  Copyright © 2016 谢 砾威. All rights reserved.
//

#import "SongListDatabase.h"

@interface SongListDatabase()

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;
@property (nonatomic, strong) NSMutableArray *arrayResults;

- (void) copyDatabaseIntoDocumentsDirectory;
- (void) runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

@end

@implementation SongListDatabase

- (instancetype) initWithDatabasefileName:(NSString *)databasefilename {
    self = [super init];
    if (self) {
        
    // Set the documents directory path to the documentsDirectory property.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        
        self.databaseFilename = databasefilename;
    //Copy the database into the documents direcrtory
        [self copyDatabaseIntoDocumentsDirectory];
        
    }
    return self;
}

- (void) copyDatabaseIntoDocumentsDirectory {
    //Check the database is exist or not
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        // Copy the database from the main bundle
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

- (void) runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable {
    // Create a sqlite3 database.
    sqlite3 *sqliteDatabase;
    
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    //Initialize the results array
    if (self.arrayResults != nil) {
        [self.arrayResults removeAllObjects];
        self.arrayResults = nil;
    }
    self.arrayResults = [[NSMutableArray alloc] init];
    //Initialize the column names array
    if (self.arrayColumnNames != nil) {
        [self.arrayColumnNames removeAllObjects];
        self.arrayColumnNames = nil;
    }
    self.arrayColumnNames = [[NSMutableArray alloc] init];
    
    //Open the database
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqliteDatabase);
    if(openDatabaseResult == SQLITE_OK) {
        //Sqlite3_stmt object stores the query
        sqlite3_stmt *compiledStatement;
        
        //Load the data from database to memory
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqliteDatabase, query, -1, &compiledStatement, NULL);
        
        if (prepareStatementResult == SQLITE_OK) {
            //Non-executable query
            if (!queryExecutable) {
                //This array keeps the data for each rows.
                NSMutableArray *arrayDataRow;
                //This loop adds the results to the results array row by row
                while (sqlite3_step(compiledStatement) == SQLITE_ROW){
                    //This array contains the data from the fetched row
                    arrayDataRow = [[NSMutableArray alloc] init];
                    //Get the total number of columns
                    int totalNumberofColumns = sqlite3_column_count(compiledStatement);
                    //Go through the columns and fetch the data
                    for (int i=0; i<totalNumberofColumns; i++) {
                        //Convert the column data to text
                        char *databaseDataAsChars = (char *) sqlite3_column_text(compiledStatement, i);
                        //If there are contents in the current column then add them to the array
                        if (databaseDataAsChars != NULL) {
                            [arrayDataRow addObject:[NSString stringWithUTF8String:databaseDataAsChars]];
                        }
                        //Keep the column name
                        if (self.arrayColumnNames.count != totalNumberofColumns) {
                            databaseDataAsChars = (char *) sqlite3_column_name(compiledStatement,i);
                            [self.arrayColumnNames addObject:[NSString stringWithUTF8String:databaseDataAsChars]];
                        }
                        
                    }
                    //If there is actually data, store the rows
                    if (arrayDataRow.count > 0) {
                        [self.arrayResults addObject:arrayDataRow];
                    }
                }
            }
            else {
                //Execute the query
                int executeQueryResults = sqlite3_step(compiledStatement);
                
                if (executeQueryResults == SQLITE_DONE) {
                    //Keep the affected rows
                    self.affectedRows = sqlite3_changes(sqliteDatabase);
                    //Keep the last inserted row ID
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqliteDatabase);
                }
                else {
                    //If could not execute the query, show the error message
                    NSLog(@"DB error: %s", sqlite3_errmsg(sqliteDatabase));
                }
            }
        }
        else {
            //If the database cannot be opened, show the error message
            NSLog(@"%s", sqlite3_errmsg(sqliteDatabase));
        }
        //Release the compiled statement from the memory
        sqlite3_finalize(compiledStatement);
    }
    //Close the database
    sqlite3_close(sqliteDatabase);
}

- (NSArray *) loadingDataFromDatabase:(NSString *)query {
    //Convert the query string to Char object. Run the query and this is non-executable
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    //Return the load results
    return (NSArray *) self.arrayResults;
}

- (void) executeQuery:(NSString *)query {
    //Run the query and this is executable
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}









@end
