//
//  DBManager.m
//  RSSReader
//
//  Created by Nguyen Ta Minh Trung on 5/31/19.
//  Copyright © 2019 trungntmnguyen. All rights reserved.
//

#import "DBManager.h"
static DBManager *sharedInstance = nil;
static sqlite3 *database = Nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

+ (DBManager*) getSharedInstance {
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone: NULL] init];
        [sharedInstance createDb];
    }
    
    return sharedInstance;
}

- (BOOL) createDb {
    NSString *documentsDir;
    NSArray *dirPaths;
    
    // get documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = dirPaths[0];
    
    // build the path to the database file
    databasePath = [[NSString alloc] initWithString:[documentsDir stringByAppendingPathComponent:@"RSSReader.db"]];
    
    BOOL isSuccess = true;
    NSFileManager *fileMng = [NSFileManager defaultManager];
    
    if ([fileMng fileExistsAtPath:databasePath] == NO) {
        const char *dbPath = [databasePath UTF8String];
        
        if (sqlite3_open(dbPath, &database) == SQLITE_OK) {
            char* errMessage;
            const char *sql_stmt = "create table if not exists RssReader (id integer primary key autoincrement, title text, link text, image text, pubDate text)";
            
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMessage) != SQLITE_OK) {
                isSuccess = NO;
                NSLog(@"Fail to create database!");
            }
            
            sqlite3_close(database);
            return isSuccess;
            
        } else {
            isSuccess = NO;
            NSLog(@"Fail to create/open database!");
        }
    }
    
    return isSuccess;
}

- (BOOL) save:(NSMutableString *)title link:(NSMutableString *)link image:(NSMutableString *)image pubDate:(NSMutableString *)pubDate {
    const char *dbPath = [databasePath UTF8String];
    
    if (sqlite3_open(dbPath, &database) == SQLITE_OK) {
        NSString *insertQuery = [NSString stringWithFormat:@"insert into RssReader (title, link, image, pubDate) values (\"%@\",\"%@\",\"%@\",\"%@\")", title, link, image, pubDate];
        
        const char *insertStatement = [insertQuery UTF8String];
        sqlite3_prepare_v2(database, insertStatement, -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return NO;
}

- (NSMutableArray*) findAll {
    NSMutableArray *dbResults = [[NSMutableArray array] init];
    
    const char *dbPath = [databasePath UTF8String];
    
    if (sqlite3_open(dbPath, &database) == SQLITE_OK) {
        NSString *query = [NSString stringWithFormat:@"select title, link, image, pubdate from RssReader"];
        
        const char *queryStatement = [query UTF8String];
        NSMutableArray *dataRow = [[NSMutableArray alloc] init];
        
        if (sqlite3_prepare_v2(database, queryStatement, -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                dataRow = [[NSMutableArray alloc] init];
                
                NSMutableString *title = [[NSMutableString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                [dataRow addObject:title];
                
                NSMutableString *link = [[NSMutableString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];
                [dataRow addObject:link];
                
                // Set data for image, maybe needs, but now is NO
                /*
                NSMutableString *image = [[NSMutableString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                [dataRow addObject:image];*/
                
                NSMutableString *pubDate = [[NSMutableString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 3)];
                [dataRow addObject:pubDate];
                
                if (dataRow.count > 0) {
                    [dbResults addObject:dataRow];
                }
            }
        }
    }
    
    return dbResults;
}

@end
