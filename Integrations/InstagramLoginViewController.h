//
//  InstagramLoginViewController.h
//  Integrations
//
//  Created by Tarun Sharma on 19/01/17.
//  Copyright © 2017 Chetaru Web LInk Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstagramLoginViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *loginWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginIndicator;
@property(strong,nonatomic)NSString *typeOfAuthentication;

@end
