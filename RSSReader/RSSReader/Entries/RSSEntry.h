//
//  RSSEntry.h
//  RSSReader
//
//  Created by Nguyen Ta Minh Trung on 5/30/19.
//  Copyright © 2019 trungntmnguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RSSEntry : NSObject {
    int *_id;
    NSMutableString *_title;
    NSMutableString *_link;
    NSMutableString *_image;
    NSDate *_pubDate;
}

@property (assign) int *id;
@property (copy) NSMutableString *title;
@property (copy) NSMutableString *link;
@property (copy) NSMutableString *image;
@property (copy) NSDate *pubDate;

- (id)initWithId:(int*)id title:(NSMutableString*)title link:(NSMutableString*)link image:(NSMutableString*)image pubDate:(NSDate*)pubDate;

- (id)initWithTitle:(NSMutableString*)title link:(NSMutableString*)link image:(NSMutableString*)image pubdate:(NSDate*)pubDate;

@end

NS_ASSUME_NONNULL_END
