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

@interface AlimitudeInstrumentViewController ()

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
        
        [self performSelector:@selector(performFlash) withObject:self afterDelay:1.0];
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
        [self presentViewController:alarmView animated:YES completion:nil];
        
        if([AlimitudeSharedAppState sharedInstance].vibrateOnWarning) {
            [self performVibration];
        }
        
        if([AlimitudeSharedAppState sharedInstance].flashLightOnWarning) {
            [self performFlash];
        }
    }
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
