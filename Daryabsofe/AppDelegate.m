//
//  AppDelegate.m
//  Daryabsofe
//
//  Created by Masum Chauhan on 15/08/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "PayPalMobile.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //userID
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] == nil) {
        
        UIViewController *viewController =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LOGIN"];
        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
        [navigationController pushViewController:viewController animated:YES];
    }
    else {
        NSLog(@"-->> %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"]);
        UIViewController *viewController =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PARENT"];
        [[NSUserDefaults standardUserDefaults]setObject:@"CATEGORY" forKey:@"storyboardID"];
        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
        [navigationController pushViewController:viewController animated:YES];
    }
   
    //[PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @""}];
    
     [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentSandbox : @"AebkW5t1FHDRoALK4rjHZ893cPzTTRtVtS-Gh9RjSCdJY5zCushzHSnJWi_VcF14EwlTwpkHuZ89cSSA"}];
    //AebkW5t1FHDRoALK4rjHZ893cPzTTRtVtS-Gh9RjSCdJY5zCushzHSnJWi_VcF14EwlTwpkHuZ89cSSA
    //AFcWxV21C7fd0v3bYYYRCpSSRl31AAF1j6Oaj097SnMlPl3vFD6kc-eZ
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
