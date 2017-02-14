//
//  LoginViewController.m
//  Integrations
//
//  Created by Tarun Sharma on 18/01/17.
//  Copyright © 2017 Chetaru Web LInk Private Limited. All rights reserved.
//

#import "LoginViewController.h"
#import "PopMenu.h"
#import "AppDelegate.h"
#import <linkedin-sdk/LISDK.h>
#import <TwitterKit/TwitterKit.h>
#import "LinkedInHelper.h"
#import "InstagramLoginViewController.h"
#import "FKAuthViewController.h"
@interface LoginViewController ()
@property (nonatomic, strong) PopMenu *popMenu;
@property (nonatomic,strong) NSUserDefaults * userDefaults;
@property (nonatomic, retain) FKFlickrNetworkOperation *todaysInterestingOp;
@property (nonatomic, retain) FKFlickrNetworkOperation *myPhotostreamOp;
@property (nonatomic, retain) FKDUNetworkOperation *completeAuthOp;
@property (nonatomic, retain) FKDUNetworkOperation *checkAuthOp;
@property (nonatomic, retain) FKImageUploadNetworkOperation *uploadOp;
@property (nonatomic, retain) NSString *userID;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _userDefaults=[NSUserDefaults standardUserDefaults];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startLocating:) name:@"ForceUpdateLocation" object:nil]; // don't forget the ":"
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAuthenticateCallback:) name:@"UserAuthCallbackNotification" object:nil];
    
    // Check if there is a stored token
    // You should do this once on app launch
    

    [GIDSignIn sharedInstance].uiDelegate = self;
//    if([_userDefaults objectForKey:@"linkedInLogin"] != nil) {
//        self.linkedInLogoutButtonInstance.enabled=YES;
//    }
//    else{
//        self.linkedInLogoutButtonInstance.enabled=NO;
//    }
    if([_userDefaults objectForKey:@"googlePlusLogin"] != nil) {
        self.googlePlusLogoutButtonInstance.enabled=YES;
    }
    else{
        self.googlePlusLogoutButtonInstance.enabled=NO;
    }

    if([_userDefaults objectForKey:@"twitterLogin"] != nil) {
        self.twitterLogoutButtonInstance.enabled=YES;
    }
    else{
        self.twitterLogoutButtonInstance.enabled=NO;
    }

    if([_userDefaults objectForKey:@"facebookLogin"] != nil) {
        self.facebookLogoutButtonInstance.enabled=YES;
    }
    else{
        self.facebookLogoutButtonInstance.enabled=NO;
    }
   

    
    

}
- (void) dealloc {
    [self.todaysInterestingOp cancel];
    [self.myPhotostreamOp cancel];
}
- (void) viewWillDisappear:(BOOL)animated {
    //Cancel any operations when you leave views
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [self.todaysInterestingOp cancel];
    [self.myPhotostreamOp cancel];
    [self.completeAuthOp cancel];
    [self.checkAuthOp cancel];
    [self.uploadOp cancel];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    LinkedInHelper *linkedIn = [LinkedInHelper sharedInstance];
    self.linkedInLogoutButtonInstance.hidden = !linkedIn.isValidToken;
    
    if([_userDefaults objectForKey:@"instagramLogin"] != nil) {
        self.instagramlogoutButtonInstance.enabled=YES;
    }
    else{
        self.instagramlogoutButtonInstance.enabled=NO;
    }
    if([_userDefaults objectForKey:@"flickerLogin"] != nil) {
        self.flickerLogoutButtonInstance.enabled=YES;
    }
    else{
        self.flickerLogoutButtonInstance.enabled=NO;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Auth

- (void) userAuthenticateCallback:(NSNotification *)notification {
    NSURL *callbackURL = notification.object;
    self.completeAuthOp = [[FlickrKit sharedFlickrKit] completeAuthWithURL:callbackURL completion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error) {
        NSLog(@"User id %@,User name %@",userId,userName);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [self userLoggedIn:userName userID:userId];
            } else {
                [self showingAlert:@"Error" :error.localizedDescription];
                
               
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }];
}

- (void) userLoggedIn:(NSString *)username userID:(NSString *)userID {
    self.userID = userID;
    [self showAlertForLoggedIn:username];
    [_userDefaults setObject:username forKey:@"flickerLogin"];
    [_userDefaults synchronize];
    self.flickerLogoutButtonInstance.enabled=YES;
   // [self.flickerLogoutButtonInstance setTitle:@"Logout" forState:UIControlStateNormal];
    //self.authLabel.text = [NSString stringWithFormat:@"You are logged in as %@", username];
}

- (void) userLoggedOut {
    //[self.flickerLogoutButtonInstance setTitle:@"Login" forState:UIControlStateNormal];
    //self.authLabel.text = @"Login to flickr";
    self.flickerLogoutButtonInstance.enabled=NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)startLocating:(NSNotification *)notification {
    
    NSDictionary *dict = [notification userInfo];
    NSLog(@"DIct values %@",dict);
    if ([[dict objectForKey:@"full_name"] isEqualToString:@""]) {
        self.googlePlusLogoutButtonInstance.enabled=NO;
            }
    else{
        [self showAlertForLoggedIn:[dict objectForKey:@"full_name"]];

    }
    
}


-(void)facebookLogin{
    
    __block  NSMutableDictionary *fbResultData;
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
             [[FBSDKLoginManager new] logOut];
         } else {
             NSLog(@"Logged in");
             
             if ([FBSDKAccessToken currentAccessToken])
             {
                 
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me?fields=id,name,age_range,birthday,devices,email,gender,last_name,family,friends,location,picture" parameters:nil]
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                      if (!error) {
                          
                          NSString * accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
                          NSLog(@"fetched user:%@ ,%@", result,accessToken);
                          
                          fbResultData =[[NSMutableDictionary alloc]init];
                          
                          if ([result objectForKey:@"email"]) {
                              [fbResultData setObject:[result objectForKey:@"email"] forKey:@"email"];
                          }
                          if ([result objectForKey:@"gender"]) {
                              [fbResultData setObject:[result objectForKey:@"gender"] forKey:@"gender"];
                          }
                          if ([result objectForKey:@"name"]) {
                              NSArray *arrName;
                              arrName=[[result objectForKey:@"name"] componentsSeparatedByString:@" "];
                              
                              [fbResultData setObject:[arrName objectAtIndex:0] forKey:@"name"];
                          }
                          if ([result objectForKey:@"last_name"]) {
                              [fbResultData setObject:[result objectForKey:@"last_name"] forKey:@"last_name"];
                          }
                          if ([result objectForKey:@"id"]) {
                              [fbResultData setObject:[result objectForKey:@"id"] forKey:@"id"];
                          }
                          
                          FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                                        initWithGraphPath:[NSString stringWithFormat:@"me/picture?type=large&redirect=false"]
                                                        parameters:nil
                                                        HTTPMethod:@"GET"];
                          [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                                id result,
                                                                NSError *error) {
                              if (!error){
                                  
                                  if ([[result objectForKey:@"data"] objectForKey:@"url"]) {
                                      [fbResultData setObject:[[result objectForKey:@"data"] objectForKey:@"url"] forKey:@"picture"];
                                  }
                                  
                                  //You get all detail here in fbResultData
                                  NSLog(@"Final data of FB login********%@",fbResultData);
                                  [_userDefaults setObject:[NSString stringWithFormat:@"%@ %@",[fbResultData objectForKey:@"name"],[fbResultData objectForKey:@"last_name"]] forKey:@"facebookLogin"];
                                  [_userDefaults synchronize];
                                  [self showAlertForLoggedIn:[NSString stringWithFormat:@"%@ %@",[fbResultData objectForKey:@"name"],[fbResultData objectForKey:@"last_name"]]];
                                  
                              } }];
                      }
                      else {
                          NSLog(@"result: %@",[error description]);
                          //                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error description] delegate:nil cancelButtonTitle:NSLocalizedString(@"DISMISS", nil) otherButtonTitle:nil];
                          // [alert showInView:self.view.window];
                          [self showAlertForLoggedIn:[error description]];
                      }
                  }];
             }
             else{
                 [[FBSDKLoginManager new] logOut];
                 //                     [_customFaceBookButton setImage:[UIImage imageNamed:@"fb_connected"] forState:UIControlStateNormal];
             }
         }
     }];
}

-(void)fbLogin{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];// adding this single line fixed my issue
    [login logInWithReadPermissions: @[@"public_profile"] fromViewController:self  handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            NSLog(@"Process error");
        } else if (result.isCancelled) {
            NSLog(@"Cancelled");
            [login logOut];
            
        } else {
            NSLog(@"Logged in");
            [self GetData];
        }
    }]; // I called this logout function
}


- (void)GetData {
    if ([FBSDKAccessToken currentAccessToken]) {
       NSString * accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, first_name, picture.type(large) ,last_name"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user:%@", result);
                 //NSDictionary *Result = result;
                 [_userDefaults setObject:[result objectForKey:@"name"] forKey:@"facebookLogin"];
                 [_userDefaults synchronize];
                 self.facebookLogoutButtonInstance.enabled=YES;
                 [self showAlertForLoggedIn:[result objectForKey:@"name"]];
                 NSDictionary *params = [NSMutableDictionary dictionaryWithObject:accessToken forKey:@"access_token"];
                 NSLog(@"Params %@ ",params);
                 
             } else {
                 NSLog(@"Error %@",[error description]);
             }
         }];
    } }

-(void)TwitterLogin{
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
            [self showAlertForLoggedIn:[session userName]];
            [_userDefaults setObject:[session userName] forKey:@"twitterLogin"];
            [_userDefaults synchronize];
             self.twitterLogoutButtonInstance.enabled=YES;
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
}
-(void)linkedInLogin{

    LinkedInHelper *linkedIn = [LinkedInHelper sharedInstance];
    
    // If user has already connected via linkedin in and access token is still valid then
    // No need to fetch authorizationCode and then accessToken again!
    
    if (linkedIn.isValidToken) {
        
        linkedIn.customSubPermissions = [NSString stringWithFormat:@"%@,%@", first_name, last_name];
        
        // So Fetch member info by elderyly access token
        [linkedIn autoFetchUserInfoWithSuccess:^(NSDictionary *userInfo) {
            // Whole User Info
            
            NSString * desc = [NSString stringWithFormat:@"first name : %@\n last name : %@", userInfo[@"firstName"], userInfo[@"lastName"] ];
            [self showAlertForLoggedIn:desc];
            
            NSLog(@"user Info : %@", userInfo);
        } failUserInfo:^(NSError *error) {
            NSLog(@"error : %@", error.userInfo.description);
        }];
    } else {
        
        linkedIn.cancelButtonText = @"Close"; // Or any other language But Default is Close
        
        NSArray *permissions = @[@(BasicProfile),
                                 @(EmailAddress),
                                 @(Share),
                                 @(CompanyAdmin)];
        
        linkedIn.showActivityIndicator = YES;
        
  #warning - Your LinkedIn App ClientId - ClientSecret - RedirectUrl - And state
        
        [linkedIn requestMeWithSenderViewController:self
                                           clientId:@"8115cxe5zwk8ey"
                                       clientSecret:@"5E5usdpQsK82ElIA"
                                        redirectUrl:@"https://com.appcoda.linkedin.oauth/oauth"
                                        permissions:permissions
                                              state:@"linkedin\(Int(NSDate().timeIntervalSince1970))"
                                    successUserInfo:^(NSDictionary *userInfo) {
                                        
                                        self.linkedInLogoutButtonInstance.hidden = !linkedIn.isValidToken;
                                        
                                        NSString * desc = [NSString stringWithFormat:@"first name : %@\n last name : %@",
                                                           userInfo[@"firstName"], userInfo[@"lastName"] ];
                                        [self showAlertForLoggedIn:desc];
                                        
                                        // Whole User Info
                                        NSLog(@"user Info : %@", userInfo);
                                        // You can also fetch user's those informations like below
                                        NSLog(@"job title : %@",     [LinkedInHelper sharedInstance].title);
                                        NSLog(@"company Name : %@",  [LinkedInHelper sharedInstance].companyName);
                                        NSLog(@"email address : %@", [LinkedInHelper sharedInstance].emailAddress);
                                        NSLog(@"Photo Url : %@",     [LinkedInHelper sharedInstance].photo);
                                        NSLog(@"Industry : %@",      [LinkedInHelper sharedInstance].industry);
                                    }
                                  failUserInfoBlock:^(NSError *error) {
                                      NSLog(@"error : %@", error.userInfo.description);
                                      self.linkedInLogoutButtonInstance.hidden = !linkedIn.isValidToken;
                                  }
         ];
    }


}


-(void)googlePlusLogin{
    [[GIDSignIn sharedInstance] signIn];
    self.googlePlusLogoutButtonInstance.enabled=YES;
}



-(void)showAlertForLoggedIn:(NSString *)dataToshow{
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Successfully Logged In" message:[NSString stringWithFormat:@"Hey %@",dataToshow] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
    
    
}
-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    NSLog(@"logout");
}

- (IBAction)loginButtonClick:(id)sender {
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:3];
    
    MenuItem *menuItem = [MenuItem itemWithTitle:@"LinkedIn" iconName:@"Linkedin"];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"Googleplus" iconName:@"GooglePlus" glowColor:[UIColor colorWithRed:0.840 green:0.264 blue:0.208 alpha:0.800]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"Instagram" iconName:@"Instagram" glowColor:[UIColor colorWithRed:0.232 green:0.442 blue:0.687 alpha:0.800]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"Twitter" iconName:@"Twitter" glowColor:[UIColor colorWithRed:0.000 green:0.509 blue:0.687 alpha:0.800]];
    [items addObject:menuItem];
    
    //    menuItem = [MenuItem itemWithTitle:@"Youtube" iconName:@"Youtube" glowColor:[UIColor colorWithRed:0.687 green:0.164 blue:0.246 alpha:0.800]];
    //    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"Facebook" iconName:@"Facebook" glowColor:[UIColor colorWithRed:0.258 green:0.245 blue:0.687 alpha:0.800]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"Flicker" iconName:@"Flicker" glowColor:[UIColor colorWithRed:0.258 green:0.245 blue:0.687 alpha:0.800]];
    [items addObject:menuItem];
    
    
    if (!_popMenu) {
        _popMenu = [[PopMenu alloc] initWithFrame:self.view.bounds items:items];
        _popMenu.menuAnimationType = kPopMenuAnimationTypeNetEase;
    }
    if (_popMenu.isShowed) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    _popMenu.didSelectedItemCompletion = ^(MenuItem *selectedItem) {
        NSLog(@"%@",selectedItem.title);
        if ([selectedItem.title isEqualToString:@"LinkedIn"]) {
            [weakSelf linkedInLogin];
        }
        else if ([selectedItem.title isEqualToString:@"Googleplus"])
        {
            
            [weakSelf googlePlusLogin];
        }
        else if ([selectedItem.title isEqualToString:@"Facebook"])
        {
            
            [weakSelf fbLogin];
        }
        else if ([selectedItem.title isEqualToString:@"Twitter"])
        {
            
            [weakSelf TwitterLogin];
        }
        else if ([selectedItem.title isEqualToString:@"Instagram"])
        {
            
            [weakSelf instagramLogin];
        }
        else if ([selectedItem.title isEqualToString:@"Flicker"])
        {
            
            [weakSelf flickerLogin];
        }
        
    };
    
    [_popMenu showMenuAtView:self.view];

}
-(void)flickerLogin{
    self.checkAuthOp = [[FlickrKit sharedFlickrKit] checkAuthorizationOnCompletion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [self userLoggedIn:userName userID:userId];
            } else {
                [self userLoggedOut];
                //FKAuthViewController *authView = [[FKAuthViewController alloc] init];
                FKAuthViewController * flickerVC=[self.storyboard instantiateViewControllerWithIdentifier:@"flickerLogin"];
                [self.navigationController pushViewController:flickerVC animated:YES];
            }
        });
    }];
    
  
}
-(void)instagramLogin{
    InstagramLoginViewController * instaVC=[self.storyboard instantiateViewControllerWithIdentifier:@"instagramlogin"];
    [self.navigationController pushViewController:instaVC animated:YES];
}
- (IBAction)linkedInLogOutButtonClick:(id)sender {
    NSLog(@"%s","clear pressed");
    LinkedInHelper *linkedIn = [LinkedInHelper sharedInstance];
    [linkedIn logout];
    self.linkedInLogoutButtonInstance.hidden= !linkedIn.isValidToken;
    
}

- (IBAction)facebookLogoutButtonClick:(id)sender {
    [[FBSDKLoginManager new] logOut];
    self.facebookLogoutButtonInstance.enabled=NO;
    //[[[FBSDKLoginManager alloc]init] logOut];
    
    //[userDef setObject:@"" forKey:@"fbValue"];
    [_userDefaults removeObjectForKey:@"facebookLogin"];
    [_userDefaults synchronize];
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Successfully Logged Out" message:@"Hey User, you just logged out from a session, If you want to log out Permanently log out from Safari!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
    
}

- (IBAction)googlePlusLogoutButtonClick:(id)sender {
    [[GIDSignIn sharedInstance] signOut];
    //[[GPPSignIn sharedInstance] signOut];
    [[GIDSignIn sharedInstance] disconnect];
    self.googlePlusLogoutButtonInstance.enabled=NO;
    [_userDefaults removeObjectForKey:@"googlePlusLogin"];
    [_userDefaults synchronize];
}

- (IBAction)twitterLogoutButtonClick:(id)sender {
    TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
        NSString *userID = store.session.userID;
    
        [store logOutUserID:userID];
    
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"Twitter"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
    for (NSHTTPCookie *cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
//    TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
//    NSString *userID = store.session.userID;
//    
//    [store logOutUserID:userID];
    self.twitterLogoutButtonInstance.enabled=NO;
    [_userDefaults removeObjectForKey:@"twitterLogin"];
    [_userDefaults synchronize];
}




- (IBAction)instagramLogutButtonClick:(id)sender {
    NSHTTPCookie * cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        NSString *domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"instagram.com"];
        if(domainRange.length > 0) {
            [storage deleteCookie:cookie];
        }
    }
    self.instagramlogoutButtonInstance.enabled=NO;
    [_userDefaults removeObjectForKey:@"instagramLogin"];
    [_userDefaults synchronize];
}
- (IBAction)flickerLogoutButtonClikc:(id)sender {
    if ([FlickrKit sharedFlickrKit].isAuthorized) {
        [[FlickrKit sharedFlickrKit] logout];
        [_userDefaults removeObjectForKey:@"flickerLogin"];
        [_userDefaults synchronize];
        [self userLoggedOut];
    }
}
-(void)showingAlert:(NSString*)title :(NSString*)message{
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                }];
    
    //            UIAlertAction* noButton = [UIAlertAction
    //                                       actionWithTitle:@"No, thanks"
    //                                       style:UIAlertActionStyleDefault
    //                                       handler:^(UIAlertAction * action) {
    //                                           //Handle no, thanks button
    //                                       }];
    
    [alert addAction:yesButton];
    //[alert addAction:noButton];
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
    
}
@end
