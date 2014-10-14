//
//  WebViewController.m
//  MeetUp
//
//  Created by Taylor Wright-Sanson on 10/13/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadWebView];
    self.navigationItem.title = self.meetUp.name;
    self.backButton.enabled = NO;
    self.forwardButton.enabled = NO;
}

- (void)loadWebView
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.meetUp.url];
    [self.webView loadRequest:urlRequest];
}

#pragma mark - WebView Delegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self checkIfWebViewCanGoForwardsOrBackwards];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - WebView Helper

- (IBAction)onBackButtonPressed:(id)sender
{
    [self.webView goBack];
}

- (IBAction)onForwardButtonPressed:(id)sender
{
    [self.webView goForward];
}

- (void) checkIfWebViewCanGoForwardsOrBackwards
{
    // Enable or disable the forward and backbuttons depending on the actions available

    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;

    // The below is the same as the above two lines! 
    /*
    if (self.webView.canGoBack)
    {
        self.backButton.enabled = YES;
    }
    else
    {
        self.backButton.enabled = NO;
    }

    if (self.webView.canGoForward)
    {
        self.forwardButton.enabled = YES;
    }
    else
    {
        self.forwardButton.enabled = NO;
    }
     */
}

@end
