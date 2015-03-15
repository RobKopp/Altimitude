//
//  AlimitudeAppDelegate.m
//  Altimitude
//
//  Created by Robert Kopp on 11/29/14.
//  Copyright (c) 2014 Okoppi. All rights reserved.
//

#import "AlimitudeAppDelegate.h"

@implementation AlimitudeAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"firstBoot"] == nil) {

    
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"This application is not certified by the FAA.  This application should be used as only as a back up to supplement your situational awareness and is not a replacement for any airplane instrument or warning system. Cabin Pressure will only be monitored in the background when enabled from the main screen." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
   [errorAlert show];
    
      [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstBoot"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
     [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //cancel any scheduled notifications
    [[UIApplication sharedApplication]cancelAllLocalNotifications];

}

@end
