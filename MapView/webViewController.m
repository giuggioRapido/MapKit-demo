//
//  webViewController.m
//  MapView
//
//  Created by Chris on 8/13/15.
//  Copyright (c) 2015 chuppy. All rights reserved.
//

#import "webViewController.h"

@interface webViewController ()

@end

@implementation webViewController
{
    NSURLRequest* urlReq;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration *theConfiguration =[[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
    urlReq =  [[NSURLRequest alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
   // Unhide the navbar so that user can navigate back to mapView
    self.navigationController.navigationBarHidden = NO;
    
    urlReq = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:urlReq];
    self.view = self.webView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
