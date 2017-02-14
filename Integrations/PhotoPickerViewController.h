//
//  PhotoPickerViewController.h
//  Integrations
//
//  Created by Tarun Sharma on 20/01/17.
//  Copyright © 2017 Chetaru Web LInk Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopMenu.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <SafariServices/SafariServices.h>
#import <linkedin-sdk/LISDKSessionManager.h>
#import <linkedin-sdk/LISDKSession.h>
#import <linkedin-sdk/LISDKAPIHelper.h>
#import <linkedin-sdk/LISDKAPIResponse.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "LinkedInHelper.h"
#import <Google/SignIn.h>
@interface PhotoPickerViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIDocumentInteractionControllerDelegate,SFSafariViewControllerDelegate>

@property (retain) UIDocumentInteractionController *documentInteractionController;

- (IBAction)pickImageButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageVIew;

@end
