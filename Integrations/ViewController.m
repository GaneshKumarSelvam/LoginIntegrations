//
//  ViewController.m
//  Integrations
//
//  Created by Tarun Sharma on 17/01/17.
//  Copyright © 2017 Chetaru Web LInk Private Limited. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    loginButton.center = self.view.center;
//    [self.view addSubview:loginButton];
//    loginButton.readPermissions =
//    @[@"public_profile", @"email", @"user_friends"];
        
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginViaButtonClick:(id)sender {
    LoginViewController * loginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    [self.navigationController pushViewController:loginVC animated:YES];
    
}

@end
