//
//  AlimitudeInstrumentViewController.m
//  Altimitude
//
//  Created by Robert Kopp on 11/29/14.
//  Copyright (c) 2014 Okoppi. All rights reserved.
//

#import "AlimitudeInstrumentViewController.h"
#import "AlimitudeSharedAppState.h"
#import "AlimitudeAlarmViewController.h"
#import <math.h>
#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>

@interface AlimitudeInstrumentViewControllee <CLLocationManagerDelegate>
@end

@implementation AlimitudeInstrumentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   if([AlimitudeSharedAppState sharedInstance].alarmState == ALARM_STATE_STARTED);
    {
 //pull up the alarm view controller
    }
    
    
    if ([self.bgWarningsSwitch isOn]) {
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Battery Warning" message:@"Background Pressure Monitoring is active.  Be sure to turn this off when you no longer need to monitor pressure." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [errorAlert show];
              [self startBGNotificationReminderService];
        
        [self startLocationManager];
    } else {
        [self.locationManager stopUpdatingLocation];
        self.locationManager = nil;
            [[UIApplication sharedApplication]cancelAllLocalNotifications];
    }
    
  //  UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"This app is NOT certified by the FAA.  This app should only be used for secondary situational awareness only." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
  //  [errorAlert show];
    


    //set the switch
    [self.bgWarningsSwitch addTarget:self
                      action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];

    AlimitudeSharedAppState *sharedInstance =[AlimitudeSharedAppState sharedInstance]; //set whether BG mode on or off for switch
    [self.bgWarningsSwitch setOn:sharedInstance.useBGMode];
    
    if ([self.bgWarningsSwitch isOn]) {
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Battery Warning" message:@"Background Pressure Monitoring will drain battery when your phone is asleep.  Be sure to turn this off when you no longer need to monitor pressure." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [errorAlert show];
        
        [self startLocationManager];
    } else {
        [self.locationManager stopUpdatingLocation];
        self.locationManager = nil;
    }
    
  
    [[AlimitudeSharedAppState sharedInstance] addPropertyChangeCallback:PROPERTY_CHANGE_ALTITUDE_UNITS propertyChangeCallback:^(int altitudeUnitSelection) {
        
        if(altitudeUnitSelection == ALTITUDE_FEET_UNITS) {
            self.altitudeUnits.text = @"ft";
            if(!self.debugOption.isOn) {
                self.verticalSpeedUnits.text = @"ft/min";
            }
        } else if(altitudeUnitSelection == ALTITUDE_METER_UNITS) {
            self.altitudeUnits.text = @"m";
            if(!self.debugOption.isOn) {
                self.verticalSpeedUnits.text = @"m/min";
            }

        }
    }];
    
    NSArray *warnings = [AlimitudeSharedAppState sharedInstance].warnings;
    for(NSMutableDictionary *warning in warnings) {
        //if([[warning objectForKey:@"Enabled"] isEqualToString:@"YES"]) {
        if([[warning objectForKey:@"Dismissed"] isEqualToString:@"YES"]){
            [warning removeObjectForKey:@"Dismissed"];
            [warning setObject:@"NO" forKey:@"Dismissed"];
        }
    }
    
    self.testNum = 10;
    [self startAltimeter];
}


-(void)startAltimeter {
    self.altimeter = [[CMAltimeter alloc] init];
    
    if([CMAltimeter isRelativeAltitudeAvailable]) {
        [self.altimeter startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAltitudeData *altitudeData, NSError *error) {
            if(error != nil) {
                self.altitude.text = @"Error!";
                self.verticalSpeed.text = [NSString stringWithFormat:@"%ld", (long)error.code];
            } else {

                long currentAltitude = (long)( 145366.45 * ( 1-pow([altitudeData.pressure doubleValue]/101.325, 0.19028) ) );
                long prevAltitude = [AlimitudeSharedAppState sharedInstance].previousAltitude;
                [AlimitudeSharedAppState sharedInstance].currentPressure=(long)[altitudeData.pressure doubleValue];
                
                NSTimeInterval previousUpdate = [AlimitudeSharedAppState sharedInstance].previousAltitudeTimestamp;
                
                NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
                
                NSTimeInterval timeDiff = currentTime - previousUpdate;
                long altDiff = currentAltitude - prevAltitude;
                long verticalSpeed = 0 ;
                if(timeDiff != 0) {
                    //Convert to minutes
                    verticalSpeed = (altDiff/timeDiff) * 60;
                }
                
                self.altitude.text = [NSString stringWithFormat:@"%ld", currentAltitude];
                if(!self.debugOption.isOn) {
                    self.verticalSpeed.text = [NSString stringWithFormat:@"%ld",verticalSpeed];

                } else {
                    
                    self.verticalSpeed.text = [NSString stringWithFormat:@"%g",[altitudeData.pressure doubleValue]];
                }
                
                [AlimitudeSharedAppState sharedInstance].previousAltitude = currentAltitude;
                [AlimitudeSharedAppState sharedInstance].previousAltitudeTimestamp = currentTime;
                NSArray *warnings = [AlimitudeSharedAppState sharedInstance].warnings;
                //for(NSDictionary *warning in warnings) {
                 for(NSMutableDictionary *warning in warnings) {
                    if([[warning objectForKey:@"Enabled"] isEqualToString:@"YES"]) {
                        if([[warning objectForKey:@"Dismissed"] isEqualToString:@"NO"]){
                        NSNumber *altitude = [warning objectForKey:@"Altitude"];
                        if([altitude longValue] <= currentAltitude) {
                            [warning removeObjectForKey:@"Dismissed"];
                            [warning setObject:@"YES" forKey:@"Dismissed"];
                            //check whether app is in background or foreground.  If in background, ring a local notification.
                            
                            if([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive){
                                
                                [self ringThePressureLocalNotification:altitude message:[warning objectForKey:@"Message"]];
                                
                                
                            } else
                            
                            [self activateWarning:altitude message:[warning objectForKey:@"Message"]];
                            break;
                        }
                        } else {
                          NSNumber *altitude = [warning objectForKey:@"Altitude"];
                            if([altitude longValue] >= currentAltitude) {
                                [warning removeObjectForKey:@"Dismissed"];
                                [warning setObject:@"NO" forKey:@"Dismissed"];
                                break;
                        }
                        }
                    }
                }
            }
        }];
    } else {

//        if(self.testNum > 30) {
//            [self activateWarning:[NSNumber numberWithInt:10000] message:@"Warning Pressure Altitude Too High, Descend Immediately"];
//            self.testNum = 0;
//        } else if(self.testNum > 0) {
//            self.testNum += 10;
//        }
        self.altitude.text = @"Initializing...";
        self.verticalSpeed.text = @"Initializing...";
        [self performSelector:@selector(startAltimeter) withObject:self afterDelay:1];
    }
}

-(IBAction)debugOptionChange:(id)sender {
    if(!self.debugOption.isOn) {
        self.verticalSpeedTitle.text = @"Vertical Speed";
        self.verticalSpeedUnits.text = [AlimitudeSharedAppState sharedInstance].altitudeUnits == ALTITUDE_FEET_UNITS ? @"ft/min" : @"m/min";
        
    } else {
        self.verticalSpeedTitle.text = @"Pressure";
        self.verticalSpeedUnits.text = @"kPA";
    }
}

-(void) performVibration {
    if([AlimitudeSharedAppState sharedInstance].alarmState != ALARM_STATE_SILENCED) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self performSelector:@selector(performVibration) withObject:self afterDelay:1.0];
    }
}

-(void)performFlash {
    if([AlimitudeSharedAppState sharedInstance].alarmState != ALARM_STATE_SILENCED) {
        
     //   NSLog(@"%ld",[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo].torchMode);
               
        
        
        if ([[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] hasTorch] &&
            [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo].torchMode == AVCaptureTorchModeOn)
        {
            [[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] lockForConfiguration:nil];
            [[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] setTorchMode:AVCaptureTorchModeOff];
            [[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] unlockForConfiguration];
        }
        else if ([[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] hasTorch] &&
                 [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo].torchMode == AVCaptureTorchModeOff)
        {
            [[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] lockForConfiguration:nil];
            [[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] setTorchMode:AVCaptureTorchModeOn];
            [[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] unlockForConfiguration];
        }
        
        [self performSelector:@selector(performFlash) withObject:self afterDelay:0.2];
    } else {
        if ([[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] hasTorch] &&
            [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo].torchMode == AVCaptureTorchModeOn)
        {
            [[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] lockForConfiguration:nil];
            [[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] setTorchMode:AVCaptureTorchModeOff];
            [[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] unlockForConfiguration];
        }
    }
}

-(void)playSound {
    //Do sound things
}

-(void) activateWarning:(NSNumber *)warningValue message:(NSString *)messageValue {
    
    if([AlimitudeSharedAppState sharedInstance].alarmState == ALARM_STATE_SILENCED) {
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setGroupingSeparator: [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator]];
        [formatter setGroupingSize:3];
        [formatter setUsesGroupingSeparator:YES];
        
        NSString *altValue = [formatter stringFromNumber:warningValue];
        
        [AlimitudeSharedAppState sharedInstance].alarmState = ALARM_STATE_STARTED;
        AlimitudeAlarmViewController *alarmView = [AlimitudeAlarmViewController new];
        [alarmView setMessageStrings:altValue message:messageValue];
        
        
        UIViewController *presenter = ((UINavigationController *)self.parentViewController).topViewController;
        while(presenter.presentedViewController != nil) {
            presenter = presenter.presentedViewController;
        }
        [presenter presentViewController:alarmView animated:YES completion:nil];
        
        if([AlimitudeSharedAppState sharedInstance].vibrateOnWarning) {
            [self performVibration];
        }
        
        if([AlimitudeSharedAppState sharedInstance].flashLightOnWarning) {
            [self performFlash];
        }
    }
}



- (void) ringThePressureLocalNotification:(NSNumber *)warningValue message:(NSString *)messageValue {
    if([AlimitudeSharedAppState sharedInstance].alarmState == ALARM_STATE_SILENCED) {
        
        
        
    //Show the warning
    [self activateWarning:warningValue message:messageValue];
    
    
    
    UIApplication* app = [UIApplication sharedApplication];
  //  NSArray*    oldNotifications = [app scheduledLocalNotifications];
    
    // Clear out the old notification before scheduling a new one.
  //  if ([oldNotifications count] > 0)
   //     [app cancelAllLocalNotifications];
    
    // Create a new notification.
    UILocalNotification* alarm = [[UILocalNotification alloc] init];
    if (alarm)
    {
        NSDate *now = [[NSDate alloc] init];
        alarm.fireDate = now;
        alarm.timeZone = [NSTimeZone defaultTimeZone];
        alarm.repeatInterval = 0;
        //alarm.ApplicationIconBadgeNumber = 1;
        //alarm.soundName = @"/Users/nkopp2/Documents/Apps/TestAPKs/PAWS/Altimitude/Altimitude/Alarm.caf";
        alarm.soundName =@"alarm2.caf";
        alarm.alertBody = [NSString stringWithFormat:@"%@ ft: %@\r\rOpen the app to silence the alarm.", warningValue, messageValue];
        
        [app scheduleLocalNotification:alarm];
    }
    }
}
                        
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    // UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error with location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    //  [errorAlert show];
    //NSLog(@"Error: %@",error.description);
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self performSelector:@selector(startAltimeter) withObject:self afterDelay:1];
    
    // [self startAltimeter];
    // CLLocation *crnLoc = [locations lastObject];
    
    // LOCATIONS are working!
    // latitude.text = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.latitude];
    // longitude.text = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.longitude];
    //  self.GPSAltitude.text= [NSString stringWithFormat:@"%.0f m",crnLoc.altitude];
    //  speed.text = [NSString stringWithFormat:@"%.1f m/s", crnLoc.speed];
    
    
}



-(void)startBGNotificationReminderService
{

UIApplication* app = [UIApplication sharedApplication];
// Create a new notification.
UILocalNotification* alarm = [[UILocalNotification alloc] init];
if (alarm)
{
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:30*60];
    alarm.fireDate = now;
    alarm.timeZone = [NSTimeZone defaultTimeZone];
    alarm.repeatInterval = NSCalendarUnitHour;
    //alarm.ApplicationIconBadgeNumber = 1;
    //alarm.soundName = @"/Users/nkopp2/Documents/Apps/TestAPKs/PAWS/Altimitude/Altimitude/Alarm.caf";
    alarm.soundName =@"Images/Alarm.caf";
    alarm.alertBody = @"PAWS is monitoring the Cabin Pressure Altitude in the background.  If this is no longer needed, open the app and deselect enable background warnings.";
    
    [app scheduleLocalNotification:alarm];
}
}


-(void)startLocationManager
{
    
    self.locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
    self.locationManager.delegate = self;// we set the delegate of locationManager to self.
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers; // setting the accuracy
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];  //requesting location updates
    
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning: Unable to Perform Background Monitoring!"
                                                        message:@"We require access to your location to monitor the pressure in the background, please go to Settings> Privacy > Location Services and turn on Always for this app. Location data is not collected or sent to the developer but only used to provide Warnings in the background."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
         }
        UIUserNotificationSettings *grantedSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (grantedSettings.types == UIUserNotificationTypeNone) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning: Notifications disabled."
                                                            message:@"To view Pressure Alerts while in the background. Please turn on notifications for this app by going to Settings>Notifications>PAWS and allowing notifications and sounds."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            NSLog(@"disabled");
        }
        else if (grantedSettings.types & UIUserNotificationTypeSound & UIUserNotificationTypeAlert ){
            NSLog(@"Sound and alert permissions ");
        }
        else if (grantedSettings.types  & UIUserNotificationTypeAlert){
            NSLog(@"Alert Permission Granted");
        }
}



- (void)stateChanged:(UISwitch *)switchState
{
  if ([switchState isOn]) {
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Battery Warning" message:@"Background Pressure Monitoring may drain battery when your phone is asleep.  Be sure to turn this off when you no longer need to monitor pressure." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
      [errorAlert show];
            [self startBGNotificationReminderService];
      
    [self startLocationManager];
} else {
        [[UIApplication sharedApplication]cancelAllLocalNotifications];
        [self.locationManager stopUpdatingLocation];
      self.locationManager = nil;
  }

    BOOL isSelected = ((UISwitch*)switchState).isOn;
        [AlimitudeSharedAppState sharedInstance].useBGMode = isSelected;
    
    //[AlimitudeSharedAppState sharedInstance].playSoundOnWarning = isSelected;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
