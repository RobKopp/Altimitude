//
//  AlimitudeWarningCellViewController.m
//  Altimitude
//
//  Created by Robert Kopp on 11/30/14.
//  Copyright (c) 2014 Okoppi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlimitudeWarningCellViewController.h"
#import "AlimitudeSharedAppState.h"

@implementation AlimitudeWarningCellViewController

-(void)setWarning:(NSDictionary *)warning {
    _warning = warning;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setGroupingSeparator: [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator]];
    [formatter setGroupingSize:3];
    [formatter setUsesGroupingSeparator:YES];
    NSNumber *altitude = [warning objectForKey:@"Altitude"];
    self.warningValue.text = [formatter stringFromNumber:altitude];
}

-(IBAction)toggleEnabled:(id)sender {
    
    NSArray *warnings = [AlimitudeSharedAppState sharedInstance].warnings;
    for (NSMutableDictionary *item in warnings) {
        if(self.warning == item ) {
            NSString *value = self.warningEnabled.isOn ? @"YES" : @"NO";
            [item setObject:value forKey:@"Enabled"];
        }
    }
    [[AlimitudeSharedAppState sharedInstance] saveState];
    
}

@end