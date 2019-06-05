//
//  DBManager.h
//  RSSReader
//
//  Created by Nguyen Ta Minh Trung on 5/31/19.
//  Copyright © 2019 trungntmnguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBManager : NSObject {
    NSString *databasePath;
}

+ (DBManager*) getSharedInstance;
- (BOOL) createDb;
- (BOOL) save:(NSMutableString *)title link:(NSMutableString *)link image:(NSMutableString *)image pubDate:(NSMutableString *)pubDate;
- (NSMutableArray*) findAll;

@end

NS_ASSUME_NONNULL_END
