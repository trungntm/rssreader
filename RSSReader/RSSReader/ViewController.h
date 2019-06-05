//
//  ViewController.h
//  RSSReader
//
//  Created by Nguyen Ta Minh Trung on 5/30/19.
//  Copyright © 2019 trungntmnguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewController : UIViewController {
    IBOutlet UIActivityIndicatorView *actInd;
    NSTimer *timer;
}

@property (copy, nonatomic) NSString *url;
@property (strong, nonatomic) IBOutlet UIWebView *webview;

@end

NS_ASSUME_NONNULL_END
