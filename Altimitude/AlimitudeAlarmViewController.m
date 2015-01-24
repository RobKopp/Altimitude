//
//  AlimitudeAlarmViewController.m
//  Altimitude
//
//  Created by Robert Kopp on 12/24/14.
//  Copyright (c) 2014 Okoppi. All rights reserved.
//

#import "AlimitudeAlarmViewController.h"
#import "AlimitudeSharedAppState.h"

@interface AlimitudeAlarmViewController () {
    UIColor *fadeToColor;
    NSString *altitudeValue;
    NSString *messageValue;
}
@end

@implementation AlimitudeAlarmViewController

-(void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UIColor redColor];
    fadeToColor = [UIColor whiteColor];
    self.altitudeLabel.text = altitudeValue;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self beginFlash];
}

-(void)setMessageStrings:(NSString*) altitude message:(NSString *)message {
    altitudeValue = altitude;
    messageValue = message;
}

-(void)beginFlash {
    if([AlimitudeSharedAppState sharedInstance].alarmState != ALARM_STATE_SILENCED) {
        [UIView animateWithDuration:0.0 animations:^{
            self.view.backgroundColor = fadeToColor;
        } completion:^(BOOL finished) {
            if(fadeToColor == [UIColor whiteColor]) {
                fadeToColor = [UIColor redColor];
            } else {
                fadeToColor = [UIColor whiteColor];
            }
            [self performSelector:@selector(beginFlash) withObject:self afterDelay:0.5];
        }];
    }
}

-(IBAction)dismissClicked:(id)sender{
    [AlimitudeSharedAppState sharedInstance].alarmState = ALARM_STATE_SILENCED;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
