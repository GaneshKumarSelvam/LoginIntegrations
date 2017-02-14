//
//  LoginViewController.h
//  Integrations
//
//  Created by Tarun Sharma on 18/01/17.
//  Copyright © 2017 Chetaru Web LInk Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "FlickrKit.h"
@interface LoginViewController : UIViewController<GIDSignInUIDelegate>
- (IBAction)loginButtonClick:(id)sender;
- (IBAction)linkedInLogOutButtonClick:(id)sender;
- (IBAction)facebookLogoutButtonClick:(id)sender;
- (IBAction)googlePlusLogoutButtonClick:(id)sender;

- (IBAction)twitterLogoutButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *linkedInLogoutButtonInstance;
@property (weak, nonatomic) IBOutlet UIButton *facebookLogoutButtonInstance;
@property (weak, nonatomic) IBOutlet UIButton *googlePlusLogoutButtonInstance;
@property (weak, nonatomic) IBOutlet UIButton *twitterLogoutButtonInstance;
- (IBAction)instagramLogutButtonClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *instagramlogoutButtonInstance;
- (IBAction)flickerLogoutButtonClikc:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *flickerLogoutButtonInstance;

@end
