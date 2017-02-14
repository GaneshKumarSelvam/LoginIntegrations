//
//  PhotoPickerViewController.m
//  Integrations
//
//  Created by Tarun Sharma on 20/01/17.
//  Copyright © 2017 Chetaru Web LInk Private Limited. All rights reserved.
//

#import "PhotoPickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Reachability.h"
#import <Social/Social.h>
@interface PhotoPickerViewController ()
{
    UIImage *choosenImage;
    NSURL * imageURLFromGallery;

}
@property (nonatomic, strong) PopMenu *popMenu;
@end

@implementation PhotoPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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




#pragma mark ImagePickerDelegate methods

- (IBAction)pickImageButtonClick:(id)sender {
    
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Integrations" message:@"Please select an option" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            
            [self performSelector:@selector(showcamera) withObject:nil afterDelay:0.0];
        }
        else
        {
            [self showingAlert:@"Camera Not Found" :@"The Device has No camera"];
            
            
        }
        // Distructive button tapped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Photos" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // OK button tapped.
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            
            UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
            photoPicker.delegate = self;
            photoPicker.allowsEditing = YES;
            photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:photoPicker animated:YES completion:NULL];
        }
        
//        [self dismissViewControllerAnimated:YES completion:^{
//        }];
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}


-(void)showcamera
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized)
    {
        [self popCamera];
    }
    else if(authStatus == AVAuthorizationStatusNotDetermined)
    {
        NSLog(@"%@", @"Camera access not determined. Ask for permission.");
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
         {
             if(granted)
             {
                 NSLog(@"Granted access to %@", AVMediaTypeVideo);
                 [self popCamera];
             }
             else
             {
                 NSLog(@"Not granted access to %@", AVMediaTypeVideo);
                 [self camDenied];
             }
         }];
    }
    else if (authStatus == AVAuthorizationStatusRestricted)
    {
        // My own Helper class is used here to pop a dialog in one simple line.
        //[Helper popAlertMessageWithTitle:@"Error" alertText:@"You've been restricted from using the camera on this device. Without camera access this feature won't work. Please contact the device owner so they can give you access."];
        [self showingAlert:@"Something Went Wrong!" :@"You've been restricted from using the camera on this device. Without camera access this feature won't work. Please contact the device owner so they can give you access."];
        
        
    }
    else
    {
        [self camDenied];
    }
    
}
-(void)popCamera{
    UIImagePickerController * cameraPicker = [[UIImagePickerController alloc] init];
    
    cameraPicker.delegate = self;
    cameraPicker.allowsEditing = YES;
    cameraPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:cameraPicker animated:YES completion:nil];
    
}
- (void)camDenied
{
    NSLog(@"%@", @"Denied camera access");
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Error" message:@"It looks like your privacy settings are preventing us from accessing your camera to take Photos. You can fix this by doing the following:\n\n1. Touch the Settings button below to open the Settings of this app.\n\n2. Turn the Camera on.\n\n3. Open this app and try again." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * settingsAction=[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @try
        {
            NSLog(@"tapped Settings");
            BOOL canOpenSettings = (UIApplicationOpenSettingsURLString != NULL);
            if (canOpenSettings)
            {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                UIApplication *application = [UIApplication sharedApplication];
                [application openURL:url options:@{} completionHandler:nil];
                //[[UIApplication sharedApplication] openURL:url];
            }
        }
        @catch (NSException *exception)
        {
            
        }
        
    }];
    UIAlertAction * cancelAction=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:settingsAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
    //NSString *alertText;
    //NSString *alertButton;
    
    //    BOOL canOpenSettings = (UIApplicationOpenSettingsURLString != NULL);
    //    if (canOpenSettings)
    //    {
    //        alertText = @"It looks like your privacy settings are preventing us from accessing your camera to do barcode scanning. You can fix this by doing the following:\n\n1. Touch the Go button below to open the Settings of this app.\n\n2. Turn the Camera on.";
    //
    //        alertButton = @"Go";
    //    }
    //    else
    //    {
    //        alertText = @"It looks like your privacy settings are preventing us from accessing your camera to do barcode scanning. You can fix this by doing the following:\n\n1. Close this app.\n\n2. Open the Settings app.\n\n3. Scroll to the bottom and select this app in the list.\n\n4. Touch Privacy.\n\n5. Turn the Camera on.\n\n6. Open this app and try again.";
    //
    //        alertButton = @"OK";
    //    }
    //
    //    UIAlertView *alert = [[UIAlertView alloc]
    //                          initWithTitle:@"Error"
    //                          message:alertText
    //                          delegate:self
    //                          cancelButtonTitle:alertButton
    //                          otherButtonTitles:nil];
    //    alert.tag = 3491832;
    //    [alert show];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //chosenImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
     choosenImage=[info valueForKey:UIImagePickerControllerOriginalImage];
    if( [picker sourceType] == UIImagePickerControllerSourceTypeCamera )
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error )
         {
             imageURLFromGallery= assetURL;
            NSLog(@"Image URL Camera %@",imageURLFromGallery);
             //here is your URL : assetURL
         }];
    }
    else
    {
        imageURLFromGallery= [info valueForKey:UIImagePickerControllerReferenceURL];
        //else this is valid : [info objectForKey:UIImagePickerControllerReferenceURL]];
        // define the block to call when we get the asset based on the url (below)
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
        {
            ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
            NSLog(@"[imageRep filename] : %@", [imageRep filename]);
        };
        
        // get the asset library and fetch the asset based on the ref url (pass in block above)
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:imageURLFromGallery resultBlock:resultblock failureBlock:nil];
    }
    
    
    NSLog(@"Image URL %@",imageURLFromGallery);
   
    //self.imageVIew.image = chosenImage;
    
    
       dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:3];
    
    
//    
//   MenuItem *menuItem  = [MenuItem itemWithTitle:@"Googleplus" iconName:@"GooglePlus" glowColor:[UIColor colorWithRed:0.840 green:0.264 blue:0.208 alpha:0.800]];
//    [items addObject:menuItem];
    
    MenuItem * menuItem = [MenuItem itemWithTitle:@"Instagram" iconName:@"Instagram" glowColor:[UIColor colorWithRed:0.232 green:0.442 blue:0.687 alpha:0.800]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"Twitter" iconName:@"Twitter" glowColor:[UIColor colorWithRed:0.000 green:0.509 blue:0.687 alpha:0.800]];
    [items addObject:menuItem];
    
    //    menuItem = [MenuItem itemWithTitle:@"Youtube" iconName:@"Youtube" glowColor:[UIColor colorWithRed:0.687 green:0.164 blue:0.246 alpha:0.800]];
    //    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"Facebook" iconName:@"Facebook" glowColor:[UIColor colorWithRed:0.258 green:0.245 blue:0.687 alpha:0.800]];
    [items addObject:menuItem];
    
//    menuItem = [MenuItem itemWithTitle:@"Flicker" iconName:@"Flicker" glowColor:[UIColor colorWithRed:0.258 green:0.245 blue:0.687 alpha:0.800]];
//    [items addObject:menuItem];
    menuItem = [MenuItem itemWithTitle:@"WhatsApp" iconName:@"WhatsApp" glowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]];
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
//       if ([selectedItem.title isEqualToString:@"Googleplus"])
//        {
//            
//            [weakSelf googlePlusShare];
//        }
         if ([selectedItem.title isEqualToString:@"Facebook"])
        {
            
            [weakSelf facebookShare];
        }
        else if ([selectedItem.title isEqualToString:@"Twitter"])
        {
            [weakSelf twitterShare];
        }
        else if ([selectedItem.title isEqualToString:@"Instagram"])
        {
            
            [weakSelf instagramShare];
        }
        else if ([selectedItem.title isEqualToString:@"Flicker"])
        {
            
            //[weakSelf flickerLogin];
        }
        else if ([selectedItem.title isEqualToString:@"WhatsApp"])
        {
            
            [weakSelf whatsappShare];
        }
        
    };
    
    [_popMenu showMenuAtView:self.view];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)facebookShare{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus != NotReachable)
    {
        NSString *textToShare = @"Look at this awesome Video.";
        //NSURL *myWebsite = [NSURL URLWithString:self.URLToShare];
        
        NSArray *objectsToShare = @[textToShare, imageURLFromGallery];
        
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
        
        NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                       UIActivityTypePrint,
                                       UIActivityTypeAssignToContact,
                                       UIActivityTypeSaveToCameraRoll,
                                       UIActivityTypeAddToReadingList,
                                       UIActivityTypePostToFlickr,
                                       UIActivityTypePostToVimeo,
                                       UIActivityTypePostToTwitter,UIActivityTypeMessage,UIActivityTypeCopyToPasteboard];
        
        activityVC.excludedActivityTypes = excludeActivities;
        
        [self presentViewController:activityVC animated:YES completion:nil];
    }
    else
    {
        [self noInternetFunction];
        
    }

}




-(void)twitterShare{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus != NotReachable)
    {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            [tweetSheet addURL:imageURLFromGallery];
            //[tweetSheet addImage:imageForShare];
            
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
        
    }
    else{
        [self noInternetFunction];
        
    }

}
-(void)whatsappShare{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus != NotReachable)
    {
        if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"whatsapp://app"]])
        {
            //NSString *soundFilePath = [NSString stringWithFormat:@"%@test.mp3",[[NSBundle mainBundle] resourcePath]];
            
            //_documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:soundFilePath]];
            _documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:imageURLFromGallery];
            _documentInteractionController.UTI = @"net.whatsapp.movie";
            _documentInteractionController.delegate = self;
            
            [_documentInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated: YES];
            
        }
        else
        {
            UIAlertController *alertCont = [UIAlertController alertControllerWithTitle:@"WhatsApp Not Installed" message:@"Your device has No WhatsApp installed" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertCont animated:true completion:nil];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"ok Action") style:UIAlertActionStyleDefault handler:nil];
            [alertCont addAction:okAction];
            
        }
        
    }
    else{
        [self noInternetFunction];
        
    }

}


-(void)googlePlusShare{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
   
    if (internetStatus != NotReachable)
    {
        
        // Construct the Google+ share URL
        NSURLComponents* urlComponents = [[NSURLComponents alloc]
                                          initWithString:@"https://plus.google.com/share"];
        urlComponents.queryItems = @[[[NSURLQueryItem alloc]
                                      initWithName:@"url"
                                      value:[imageURLFromGallery absoluteString]]];
        NSURL* url = [urlComponents URL];
        
        if ([SFSafariViewController class]) {
            // Open the URL in SFSafariViewController (iOS 9+)
            SFSafariViewController* controller = [[SFSafariViewController alloc]
                                                  initWithURL:url];
            controller.delegate = self;
            [self presentViewController:controller animated:YES completion:nil];
        } else {
            // Open the URL in the device's browser
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:url options:@{} completionHandler:nil];
            //[[UIApplication sharedApplication] openURL:url];
        }
        
    }
    else{
        [self noInternetFunction];
        
    }

}





-(void)instagramShare{
 
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus != NotReachable)
    {
         NSData *imageData = UIImagePNGRepresentation(choosenImage);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
        
        NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
        
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"insta.igo"]]; //add our image to the path
        
        [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
        
        NSLog(@"image saved");
        
        
        CGRect rect = CGRectMake(0 ,0 , 0, 0);
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIGraphicsEndImageContext();
        NSString *fileNameToSave = [NSString stringWithFormat:@"Documents/insta.igo"];
        NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fileNameToSave];
        NSLog(@"jpg path %@",jpgPath);
        NSString *newJpgPath = [NSString stringWithFormat:@"file://%@",jpgPath]; //[[NSString alloc] initWithFormat:@"file://%@", jpgPath] ];
        NSLog(@"with File path %@",newJpgPath);
        NSURL *igImageHookFile = [[NSURL alloc] initFileURLWithPath:newJpgPath];
        NSLog(@"url Path %@",igImageHookFile);
        
        self.documentInteractionController.UTI = @"com.instagram.exclusivegram";
        self.documentInteractionController = [self setupControllerWithURL:igImageHookFile usingDelegate:self];
        self.documentInteractionController=[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
        [self.documentInteractionController presentOpenInMenuFromRect: rect    inView: self.view animated: YES ];
    }
    else
    {
        [self noInternetFunction];
        
    }
   
    
    
    
}
- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    NSLog(@"file url %@",fileURL);
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    
    return interactionController;
}

-(void)noInternetFunction{
    UIAlertController *alertCont = [UIAlertController alertControllerWithTitle:@"Integrations" message:@"Internet Connection Required." preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alertCont addAction:okAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertCont animated:true completion:nil];
    });
    
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
