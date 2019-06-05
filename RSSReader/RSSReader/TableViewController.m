//
//  TableViewController.m
//  RSSReader
//
//  Created by Nguyen Ta Minh Trung on 5/29/19.
//  Copyright © 2019 trungntmnguyen. All rights reserved.
//

#import "TableViewController.h"
#import "ViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController {

    NSXMLParser *parser;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSMutableString *image;
    NSMutableString *pubDate;
    NSString *element;
    
}

@synthesize feeds = _feeds;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.feeds = [NSMutableArray array];
    
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        // netword unavailable
        [self assignRawDataToFeeds];
        
        NSLog(@"Netword unavailable!");
    } else {
        // netword available
        NSURL *url = [NSURL URLWithString:@"https://vnexpress.net/rss/the-thao.rss"];
        parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        [parser setDelegate:self];
        [parser setShouldResolveExternalEntities:NO];
        [parser parse];
        
        NSLog(@"Network available!");
    }
    
}

// Return number section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Return number of total data in table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _feeds.count;
}

// Init cell and display data on cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (cell == Nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = [[_feeds objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.detailTextLabel.text = [[_feeds objectAtIndex:indexPath.row] objectForKey:@"pubDate"];
    
    return cell;
}

// Start of an element in XML document
- (void) parser: (NSXMLParser *) parser didStartElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(nonnull NSDictionary<NSString *,NSString *> *)attributeDict {

    element = elementName;
    
    // check element is equal with tag is "item". If equal, init variables prepare to set data
    if ([element isEqualToString:@"item"]) {
        item = [[NSMutableDictionary alloc] init];
        title = [[NSMutableString alloc] init];
        link = [[NSMutableString alloc] init];
        image = [[NSMutableString alloc] init];
        pubDate = [[NSMutableString alloc] init];
    }
}

// End of an element in XML document
- (void) parser: (NSXMLParser *) parser didEndElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName {

    if ([elementName isEqualToString:@"item"]) {
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        [item setObject:image forKey:@"image"];
        [item setObject:pubDate forKey:@"pubDate"];
        
        [_feeds addObject:[item copy]];
     
        // Save data into database to prepare you don't have network connection.
        BOOL isSuccess = [[DBManager getSharedInstance] save:title link:link image:image pubDate:pubDate];
        
        if (isSuccess == true) {
            NSLog(@"Write RSS records to db");
        } else {
            NSLog(@"Fail to write records");
        }
    }
}

// find charaters is equal with name of tags to set display data
- (void) parser: (NSXMLParser *) parser foundCharacters:(nonnull NSString *)string {
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([element isEqualToString:@"link"]) {
        [link appendString:string];
    } else if ([element isEqualToString:@"image"]) {
        [image appendString:string];
    } else if ([element isEqualToString:@"pubDate"]) {
        [pubDate appendString:string];
    }
}

// end of XML document
- (void) parserDidEndDocument:(NSXMLParser *)parser {
    [self.tableView reloadData];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *string = [_feeds[indexPath.row] objectForKey:@"link"];
        [[segue destinationViewController] setUrl:string];
    }
}

- (void) assignRawDataToFeeds {
    // retrieve all raw feeds in database
    NSMutableArray *rawData = [[DBManager getSharedInstance] findAll];
    
    // add each data of raw data to _feeds to display
    for (NSMutableArray *data in rawData) {
        item = [[NSMutableDictionary alloc] init];
        [item setObject:data[0] forKey:@"title"];
        [item setObject:data[1] forKey:@"link"];
        [item setObject:data[2] forKey:@"pubDate"];
        
        [_feeds addObject:[item copy]];
    }
}

@end
