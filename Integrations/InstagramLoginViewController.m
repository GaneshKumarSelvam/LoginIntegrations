//
//  InstagramLoginViewController.m
//  Integrations
//
//  Created by Tarun Sharma on 19/01/17.
//  Copyright © 2017 Chetaru Web LInk Private Limited. All rights reserved.
//

#import "InstagramLoginViewController.h"

#import "LoginViewController.h"
#import "AppDelegate.h"
#define INSTAGRAM_AUTHURL                               @"https://api.instagram.com/oauth/authorize/"
#define INSTAGRAM_APIURl                                @"https://api.instagram.com/v1/users/"
#define INSTAGRAM_CLIENT_ID                             @"a2a436f3e8994d1eb2c9d9a6e04840de"
#define INSTAGRAM_CLIENTSERCRET                         @"3bde05ede21848bf8c692f1f56acc961"
#define INSTAGRAM_REDIRECT_URI                          @"https://www.chetaru.com/"
#define INSTAGRAM_ACCESS_TOKEN                          @"access_token"
#define INSTAGRAM_SCOPE                                 @"likes+comments+relationships"
@interface InstagramLoginViewController ()
@end

@implementation InstagramLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    UILabel* lblLoading = [[UILabel alloc]initWithFrame:CGRectMake(0, 48, 80, 30)];
//    lblLoading.text = @"Loading...";
//    lblLoading.textColor = [UIColor whiteColor];
//    lblLoading.font = [UIFont fontWithName:lblLoading.font.fontName size:15];
//    lblLoading.textAlignment = NSTextAlignmentCenter;
//    [loadingView addSubview:lblLoading];
    
    
    
   // [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    NSString* authURL = nil;
    
    if ([self.typeOfAuthentication isEqualToString:@"UNSIGNED"])
    {
        authURL = [NSString stringWithFormat: @"%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True",
                   INSTAGRAM_AUTHURL,
                   INSTAGRAM_CLIENT_ID,
                   INSTAGRAM_REDIRECT_URI,
                   INSTAGRAM_SCOPE];
        
    }
    else
    {
        authURL = [NSString stringWithFormat: @"%@?client_id=%@&redirect_uri=%@&response_type=code&scope=%@&DEBUG=True",
                   INSTAGRAM_AUTHURL,
                   INSTAGRAM_CLIENT_ID,
                   INSTAGRAM_REDIRECT_URI,
                   INSTAGRAM_SCOPE];
    }
    
    
    [self.loginWebView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: authURL]]];
    [self.loginWebView setDelegate:self];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    
    
}


#pragma mark -
#pragma mark delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    return [self checkRequestForCallbackURL: request];
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
     [self.loginIndicator setHidden:NO];
    [self.loginIndicator startAnimating];
   
    //self.loginLabel.hidden = YES;
    [self.loginWebView.layer removeAllAnimations];
    self.loginWebView.userInteractionEnabled = NO;
    [UIView animateWithDuration: 0.1 animations:^{
        //  loginWebView.alpha = 0.2;
    }];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [self.loginIndicator stopAnimating];
     [self.loginIndicator setHidden:YES];
    [self.loginWebView.layer removeAllAnimations];
    self.loginWebView.userInteractionEnabled = YES;
    [UIView animateWithDuration: 0.1 animations:^{
        //loginWebView.alpha = 1.0;
    }];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self webViewDidFinishLoad: webView];
}

#pragma mark -
#pragma mark auth logic


- (BOOL) checkRequestForCallbackURL: (NSURLRequest*) request
{
    NSString* urlString = [[request URL] absoluteString];
    
    if ([self.typeOfAuthentication isEqualToString:@"UNSIGNED"])
    {
        // check, if auth was succesfull (check for redirect URL)
        if([urlString hasPrefix: INSTAGRAM_REDIRECT_URI])
        {
            // extract and handle access token
            NSRange range = [urlString rangeOfString: @"#access_token="];
            [self handleAuth: [urlString substringFromIndex: range.location+range.length]];
            return NO;
        }
    }
    else
    {
        if([urlString hasPrefix: INSTAGRAM_REDIRECT_URI])
        {
            // extract and handle access token
            NSRange range = [urlString rangeOfString: @"code="];
            [self makePostRequest:[urlString substringFromIndex: range.location+range.length]];
            return NO;
        }
    }
    
    return YES;
}

-(void)makePostRequest:(NSString *)code
{
    //iga2a436f3e8994d1eb2c9d9a6e04840de://authorize
    NSString *post = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",INSTAGRAM_CLIENT_ID,INSTAGRAM_CLIENTSERCRET,INSTAGRAM_REDIRECT_URI,code];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:@"https://api.instagram.com/oauth/access_token"]];
    [requestData setHTTPMethod:@"POST"];
    [requestData setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [requestData setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [requestData setHTTPBody:postData];
    
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:requestData returningResponse:&response error:&requestError];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"USER DETAILS %@",dict);
    NSLog(@"successfully logged in with Tocken == %@",[dict valueForKey:@"access_token"]);
    NSLog(@"name %@",[[dict valueForKey:@"user"]valueForKey:@"full_name"]);
    //NSLog(@"Full Name %@",[[dict objectForKey:@"user"]objectAtIndex:1]);
//     [[NSNotificationCenter defaultCenter] postNotificationName:@"ForceUpdateLocation" object:self userInfo:[NSDictionary dictionaryWithObject:fullName?:@"" forKey:@"full_name"]];
    [self handleAuth:[[dict valueForKey:@"user"]valueForKey:@"full_name"]];
    
}

- (void) handleAuth: (NSString*)authToken
{
     NSLog(@"successfully logged in with Tocken == %@",authToken);
   UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Successfully Logged In" message:[NSString stringWithFormat:@"Hey %@",authToken] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSUserDefaults standardUserDefaults]setObject:authToken forKey:@"instagramLogin"];
            [[NSUserDefaults standardUserDefaults]synchronize
            ];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:action];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alert animated:YES completion:nil];
        });
        
        
   
    //[self.navigationController popViewControllerAnimated:YES];
   
    
}
@end
