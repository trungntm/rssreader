//
//  ViewController.m
//  RSSReader
//
//  Created by Nguyen Ta Minh Trung on 5/30/19.
//  Copyright © 2019 trungntmnguyen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *URL = [NSURL URLWithString:[self.url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [self.webview loadRequest:request];
    [self.webview addSubview:actInd];
    timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/2.0) target:self selector:@selector(loading) userInfo:nil repeats:YES];
}

- (void) loading {

    if (!self.webview.loading) {
        [actInd stopAnimating];
    } else {
        [actInd startAnimating];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
