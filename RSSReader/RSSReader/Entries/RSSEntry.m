//
//  RSSEntry.m
//  RSSReader
//
//  Created by Nguyen Ta Minh Trung on 5/30/19.
//  Copyright © 2019 trungntmnguyen. All rights reserved.
//

#import "RSSEntry.h"

@implementation RSSEntry

@synthesize id = _id;
@synthesize title = _title;
@synthesize link = _link;
@synthesize pubDate = _pubDate;
@synthesize image = _image;

- (id)initWithId:(int*)id title:(NSMutableString*)title link:(NSMutableString*)link image:(NSMutableString*)image pubDate:(NSDate*)pubDate {
    if ((self = [super init])) {
        _id = id;
        _title = [title copy];
        _link = [link copy];
        _image = [image copy];
        _pubDate = [pubDate copy];
    }
    
    return self;
}

- (id)initWithTitle:(NSMutableString*)title link:(NSMutableString*)link image:(NSMutableString*)image pubdate:(NSDate*)pubDate {
    
    if ((self = [super init])) {
        _title = [title copy];
        _link = [link copy];
        _image = [image copy];
        _pubDate = [pubDate copy];
    }
    
    return self;
    
}
@end
