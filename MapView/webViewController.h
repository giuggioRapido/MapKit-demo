//
//  webViewController.h
//  MapView
//
//  Created by Chris on 8/13/15.
//  Copyright (c) 2015 chuppy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface webViewController : UIViewController
@property (nonatomic, retain) WKWebView *webView;
@property (nonatomic, retain) NSURL *url;

@end
