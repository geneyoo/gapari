//
//  ViewController.m
//  ;
//
//  Created by Gene Yoo on 10/10/15.
//  Copyright © 2015 gyst. All rights reserved.
//

#import "GapariViewController.h"
#import "TFHpple.h"

@interface GapariViewController ()

@property (nonatomic, retain) UIButton *bckButton;
@property (nonatomic, retain) UIButton *fwdButton;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UITextField *searchBar;

@end

@implementation GapariViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //UIWebView
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 50)];
    self.webView.delegate = self;
    NSString *urlString = @"https://google.com";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    [self.view addSubview:self.webView];    // Do any additional setup after loading the view, typically from a nib.
    
    //Back Button
    self.bckButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.bckButton setFrame:CGRectMake(10, 10, 50, 50)];
    [self.bckButton setTitle:@"←" forState:UIControlStateNormal];
    [self.bckButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    self.bckButton.titleLabel.font = [UIFont systemFontOfSize:30.0f];
    [self.view addSubview:self.bckButton];
    
    self.fwdButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.fwdButton setFrame:CGRectMake(60, 10, 50, 50)];
    [self.fwdButton setTitle:@"→" forState:UIControlStateNormal];
    [self.fwdButton addTarget:self action:@selector(goForward:) forControlEvents:UIControlEventTouchUpInside];
    self.fwdButton.titleLabel.font = [UIFont systemFontOfSize:30.0f];
    [self.view addSubview:self.fwdButton];
    [self updateButtons];
    
    self.searchBar = [[UITextField alloc] initWithFrame:CGRectMake(130, 10, [UIScreen mainScreen].bounds.size.width - 140, 50)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Insert web address here";
    [self.view addSubview:self.searchBar];
    
    NSString *showURL = @"http://series-cravings.me/tv-show-1";
    NSData *showListData = [NSData dataWithContentsOfURL:[NSURL URLWithString:showURL]];
    TFHpple *parser = [TFHpple hppleWithHTMLData:showListData];
    NSLog(@"%@", parser);
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    NSString *urlStr = textField.text;
    if (![urlStr hasPrefix:@"http"]) {
        urlStr = [NSString stringWithFormat:@"http://%@", urlStr];
    }
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];

//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:textField.text]];
    [self.webView loadRequest:urlRequest];
    return YES;
}

- (void)updateButtons {
    self.bckButton.enabled = self.webView.canGoBack;
    self.fwdButton.enabled = self.webView.canGoForward;
}

-(IBAction)goBack:(id)sender {
    if ([self.webView canGoBack]) [self.webView goBack];
}

-(IBAction)goForward:(id)sender {
    if ([self.webView canGoForward]) [self.webView goForward];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"page is loading");
    [self updateButtons];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"finished loading");
    [self updateButtons];
}

- (void)webView:(UIWebView * _Nonnull)webView didFailLoadWithError:(NSError * _Nullable)error {
    NSLog(@"%@", error);
}

@end
