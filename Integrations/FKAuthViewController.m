//
//  FKAuthViewController.m
//  Integrations
//
//  Created by Tarun Sharma on 19/01/17.
//  Copyright © 2017 Chetaru Web LInk Private Limited. All rights reserved.
//

#import "FKAuthViewController.h"
#import "FlickrKit.h"
@interface FKAuthViewController ()
@property (nonatomic, retain) FKDUNetworkOperation *authOp;
@end

@implementation FKAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *callbackURLString = @"integrations://auth";
    
    // Begin the authentication process
    self.authOp = [[FlickrKit sharedFlickrKit] beginAuthWithCallbackURL:[NSURL URLWithString:callbackURLString] permission:FKPermissionDelete completion:^(NSURL *flickrLoginPageURL, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:flickrLoginPageURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
                [self.webView loadRequest:urlRequest];
                [self.webView setDelegate:self];
                
            } else {
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@"Error"
                                             message:error.localizedDescription
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"Ok"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                //Handle your yes please button action here
                                            }];
                
                
                [alert addAction:yesButton];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self presentViewController:alert animated:YES completion:nil];
                });

               
            }
        });
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // This must be defined in your Info.plist
    // See FlickrKitDemo-Info.plist
    // Flickr will call this back. Ensure you configure your flickr app as a web app
}

- (void) viewWillDisappear:(BOOL)animated {
    [self.authOp cancel];
    [super viewWillDisappear:animated];
}

#pragma mark - Web View


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //If they click NO DONT AUTHORIZE, this is where it takes you by default... maybe take them to my own web site, or show something else
    
    NSURL *url = [request URL];
    
    // If it's the callback url, then lets trigger that
    if (![url.scheme isEqual:@"http"] && ![url.scheme isEqual:@"https"]) {
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:url options:@{} completionHandler:nil];
            //[[UIApplication sharedApplication]openURL:url];
            return NO;
        }
    }
    
    return YES;
    
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    
    //self.loginLabel.hidden = YES;
    [self.webView.layer removeAllAnimations];
    self.webView.userInteractionEnabled = NO;
    [UIView animateWithDuration: 0.1 animations:^{
        //  loginWebView.alpha = 0.2;
    }];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
    [self.activityIndicator setHidden:YES];
    [self.webView.layer removeAllAnimations];
    self.webView.userInteractionEnabled = YES;
    [UIView animateWithDuration: 0.1 animations:^{
        //loginWebView.alpha = 1.0;
    }];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self webViewDidFinishLoad: webView];
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
