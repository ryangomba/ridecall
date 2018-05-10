//  Copyright (c) 2013-Present Ryan Gomba. All rights reserved.

#import "RGAppDelegate.h"

#import "RGViewController.h"
#import "RGLogInViewController.h"

#import <Parse/Parse.h>

@implementation RGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self setWindow:window];
    
    RGViewController *vc = [[RGViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [window setRootViewController:navVC];
    
    if (![RGAuthManager sharedAuthManager].currentUser) {
        RGLogInViewController *logInVC = [[RGLogInViewController alloc] initWithNibName:nil bundle:nil];
        UINavigationController *logInNavVC = [[UINavigationController alloc] initWithRootViewController:logInVC];
        [self performAfterDelay:0.0 blockOperation:^{
            [navVC presentViewController:logInNavVC animated:NO completion:nil];
        }];
    }
    
    [window makeKeyAndVisible];
    
    // push
    
    [Parse setApplicationId:@"3whfpIsuYrGUZQ5PIEHsm4AauERIBmjHnG2PXKsN"
                  clientKey:@"VJAF16DA9KwvqOVaTWuIT7Rx8jzcrRfhq8FJ6FVV"];
    
    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeSound |
                                                     UIRemoteNotificationTypeBadge |
                                                     UIRemoteNotificationTypeAlert)];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    //
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //
}

- (void)applicationWillTerminate:(UIApplication *)application {
    //
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)token {

    NSLog(@"PUSH TOKEN: %@", token);
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:token];
    [currentInstallation saveInBackground];
    
    NSDictionary *parameters = @{
        @"uuid": token,
    };
    
    if ([RGAuthManager sharedAuthManager].currentUser) {
        NSURL *url = [NSURL URLWithAPIPath:@"/devices/register/"];
        RGRequest *request = [RGPostRequest requestWithURL:url parameters:parameters files:nil];
        [[RGService sharedService] startAPIRequest:request responseHandler:
         ^(NSDictionary *responseDict, RGRequestError *error) {
             if (error) {
                 NSLog(@"%@", error);
             }
        }];
    }
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"PUSH ERROR: %@", error);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@"PUSH RECEIVED: %@", userInfo);
    
    [PFPush handlePush:userInfo];
}

@end
