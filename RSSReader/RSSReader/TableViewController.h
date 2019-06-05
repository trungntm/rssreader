//
//  TableViewController.h
//  RSSReader
//
//  Created by Nguyen Ta Minh Trung on 5/29/19.
//  Copyright © 2019 trungntmnguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entries/RSSEntry.h"
#import "DBHelper/DBManager.h"
#import "Reachability/Reachability.h"

NS_ASSUME_NONNULL_BEGIN

@interface TableViewController : UITableViewController <NSXMLParserDelegate> {
    NSMutableArray *_feeds;
}

@property (retain) NSMutableArray *feeds;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (void) assignRawDataToFeeds;

@end

NS_ASSUME_NONNULL_END
