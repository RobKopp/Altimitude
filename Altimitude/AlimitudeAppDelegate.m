//
//  AlimitudeAppDelegate.m
//  Altimitude
//
//  Created by Robert Kopp on 11/29/14.
//  Copyright (c) 2014 Okoppi. All rights reserved.
//

#import "AlimitudeAppDelegate.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation AlimitudeAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
  
    

    
    
    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"firstBoot"] == nil) {

    
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"This application is not certified by the FAA.  This application should be used only as a back up to supplement your situational awareness and is not a replacement for any airplane instrument or warning system. Cabin Pressure will only be monitored in the background when enabled from the main screen." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
   [errorAlert show];
    
      [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstBoot"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
     [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
    
    
    // Gets a string with the device model
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    NSLog(@"%@",platform);
    
    
    // if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    //  if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    // if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    // if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    // if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    // if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    // if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    // if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    // if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    // if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    // if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,2"])
    { } else {
        if ([platform isEqualToString:@"iPhone7,1"])
        {} else{
            
            UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Warning your iPhone is not supported." message:@"This application requires a pressure sensor in your phone. Unfortunately, this application is currently only supported on the iPhone 6 and 6+ due to this hardware availability." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [errorAlert show];
        }
        
    }
    
    
    // if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch (1 Gen)";
    // if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch (2 Gen)";
    // if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch (3 Gen)";
    // if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch (4 Gen)";
    // if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    // if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    // if ([platform isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    // if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    // if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    // if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    // if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    // if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    //if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    // if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    // if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    // if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    // if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    // if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    // if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    // if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    
    //   if ([platform isEqualToString:@"i386"])         return @"Simulator";
    // if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    
    // return platform;
    
    
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
