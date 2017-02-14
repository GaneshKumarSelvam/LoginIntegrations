//
//  AppDelegate.m
//  Integrations
//
//  Created by Tarun Sharma on 17/01/17.
//  Copyright © 2017 Chetaru Web LInk Private Limited. All rights reserved.
//

#import "AppDelegate.h"
#import "FlickrKit.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
       [Fabric with:@[[Twitter class]]];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    NSString *apiKey = @"9b4e39813e1c23b48e1274c32c7d1560";
    NSString *secret = @"dedab65c68952c66";
    if (!apiKey) {
        NSLog(@"\n----------------------------------\nYou need to enter your own 'apiKey' and 'secret' in FKAppDelegate for the demo to run. \n\nYou can get these from your Flickr account settings.\n----------------------------------\n");
        exit(0);
    }
    [[FlickrKit sharedFlickrKit] initializeWithAPIKey:apiKey sharedSecret:secret];
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    [GIDSignIn sharedInstance].delegate = self;
    return YES;
}


//- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    NSString *scheme = [url scheme];
//    if([@"integrations" isEqualToString:scheme]) {
//        // I don't recommend doing it like this, it's just a demo... I use an authentication
//        // controller singleton object in my projects
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserAuthCallbackNotification" object:url userInfo:nil];
//    }
//    return YES;
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"URL in Method %@",url);
//    if ([LISDKCallbackHandler shouldHandleUrl:url]) {
//        return [LISDKCallbackHandler application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
//    }
//    else{
//        return [[FBSDKApplicationDelegate sharedInstance] application:application
//                                                              openURL:url
//                                                    sourceApplication:sourceApplication
//                                                           annotation:annotation];
//    }
    
    if ([LISDKCallbackHandler application:application openURL:url sourceApplication:sourceApplication annotation:annotation]) {
        return YES;
    }
    else if ([[FBSDKApplicationDelegate sharedInstance] application:application
                                                            openURL:url
                                                  sourceApplication:sourceApplication
                                                         annotation:annotation]){
        return YES;
        
    }
   // NSString *scheme = ;
    
   
    return NO;
}

    - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
    {
         NSLog(@"URL in other Method %@",url);
        if ([[GIDSignIn sharedInstance] handleURL:url
                                     sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                            annotation:options[UIApplicationOpenURLOptionsAnnotationKey]]){
            return YES;
        }
        else if ([[FBSDKApplicationDelegate sharedInstance]application:app openURL:url options:options]){
            return YES;
        }
       else if([@"integrations" isEqualToString:[url scheme]]) {
            // I don't recommend doing it like this, it's just a demo... I use an authentication
            // controller singleton object in my projects
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserAuthCallbackNotification" object:url userInfo:nil];
            return YES;
        }

        
        // If you handle other (non Twitter Kit) URLs elsewhere in your app, return YES. Otherwise
        return NO;
    }
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    NSLog(@"UserName in GooglePlus %@",fullName);
    [[NSUserDefaults standardUserDefaults] setObject:fullName forKey:@"googlePlusLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ForceUpdateLocation" object:self userInfo:[NSDictionary dictionaryWithObject:fullName?:@"" forKey:@"full_name"]];

    
    // ...
}
    
    
- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

@end
