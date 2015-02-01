//
//
//  AlimitudeSharedAppState.m
//  Altimitude
//
//  Created by Robert Kopp on 11/29/14.
//  Copyright (c) 2014 Okoppi. All rights reserved.
//

#import "AlimitudeSharedAppState.h"

@implementation AlimitudeSharedAppState

-(NSMutableArray *)warnings {
    
    NSMutableArray *warnings = [self.appState objectForKey:WARNINGS_APP_STATE_KEY];
    if(warnings == nil) {
        
       //NSArray *startingValues = @[[NSNumber numberWithInteger:10000],[NSNumber numberWithInteger:12500],[NSNumber numberWithInteger:14000]];
        warnings = [NSMutableArray array];
        
        [warnings addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:10000],@"Altitude",@"YES",@"Enabled", @"Warning: You have reached 10,000 ft pressure Altitude. The FAA recommends using supplemental oxygen for any time spent above 10,000 ft.", @"Message",@"NO",@"Dismissed", nil]];
        [warnings addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:12500],@"Altitude",@"YES",@"Enabled", @"Warning: You have reached 12,500 ft pressure Altitude. The FAA requires using supplemental oxygen for any time beyond 30 minutes spent above 12,500 ft.", @"Message",@"NO",@"Dismissed", nil]];
        [warnings addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:14000],@"Altitude",@"YES",@"Enabled", @"Warning: DESCEND IMMEDIATELY! You have reached 14,000 ft pressure Altitude. The FAA requires pilots use supplemental oxygen for any time spent above 14,000 ft.", @"Message",@"NO",@"Dismissed", nil]];
        
 
        
        
      //for(int i=0;i<[startingValues count]; ++i) {
        //    NSNumber* value = (NSNumber*)[startingValues objectAtIndex:i];
   //       [warnings addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:value,@"Altitude",@"YES",@"Enabled", @"Warning: You have reached 10,000 ft pressure Altitude. The FAA recommends using supplemental oxygen for any time spend above 10,000 ft.", @"Message", nil]];

        // }
        self.warnings = warnings;
        
    }
    
    return warnings;
}

-(void)setWarnings:(NSMutableArray *)warnings {
    [self.appState setObject:warnings forKey:WARNINGS_APP_STATE_KEY];
    [self saveState];
}

-(int)altitudeUnits {
    NSNumber *units = [self.appState objectForKey:ALTITUDE_UNITS_KEY];
    if(units == nil) {
        return 0;
    }
    
    return [units intValue];
}

-(void)setAltitudeUnits:(int)altitudeUnits {
    [self.appState setObject:[NSNumber numberWithInt:altitudeUnits] forKey:ALTITUDE_UNITS_KEY];
    [self saveState];
    if([self.propertyChangeCallbacks valueForKey:PROPERTY_CHANGE_ALTITUDE_UNITS]) {
        PropertyChangeCallback callback = [self.propertyChangeCallbacks valueForKey:PROPERTY_CHANGE_ALTITUDE_UNITS];
        callback(altitudeUnits);
    }
}

-(int)pressureUnits {
    NSNumber *units = [self.appState objectForKey:PRESSURE_UNITS_KEY];
    if(units == nil) {
        return 0;
    }
    
    return [units intValue];
}

-(void)setPressureUnits:(int)pressureUnits {
    [self.appState setObject:[NSNumber numberWithInt:pressureUnits] forKey:PRESSURE_UNITS_KEY];
    [self saveState];
    if([self.propertyChangeCallbacks valueForKey:PROPERTY_CHANGE_PRESSURE_UNITS]) {
        PropertyChangeCallback callback = [self.propertyChangeCallbacks valueForKey:PROPERTY_CHANGE_ALTITUDE_UNITS];
        callback(pressureUnits);
    }
}

-(BOOL)flashLightOnWarning {
    NSNumber *active = [self.appState objectForKey:FLASH_KEY];
    if(active == nil) {
        return 0;
    }
    
    return [active intValue] == 1 ? YES : NO;
}

-(void)setFlashLightOnWarning:(BOOL)flashLightOnWarning {
    [self.appState setObject:[NSNumber numberWithInt:flashLightOnWarning ? 1 : 0] forKey:FLASH_KEY];
    [self saveState];
    if([self.propertyChangeCallbacks valueForKey:PROPERTY_CHANGE_FLASH_LIGHT_CHANGE]) {
        PropertyChangeCallback callback = [self.propertyChangeCallbacks valueForKey:PROPERTY_CHANGE_FLASH_LIGHT_CHANGE];
        callback(flashLightOnWarning == YES ? 1 : 0);
    }
}

-(BOOL)vibrateOnWarning {
    NSNumber *active = [self.appState objectForKey:VIBRATE_KEY];
    if(active == nil) {
        return 0;
    }
    
    return [active intValue] == 1 ? YES : NO;
}

-(void)setVibrateOnWarning:(BOOL)vibrateOnWarning {
    [self.appState setObject:[NSNumber numberWithInt:vibrateOnWarning ? 1 : 0] forKey:VIBRATE_KEY];
    [self saveState];
    if([self.propertyChangeCallbacks valueForKey:PROPERTY_CHANGE_VIBRATE_CHANGE]) {
        PropertyChangeCallback callback = [self.propertyChangeCallbacks valueForKey:PROPERTY_CHANGE_VIBRATE_CHANGE];
        callback(vibrateOnWarning == YES ? 1 : 0);
    }
}

-(BOOL)playSoundOnWarning {
    NSNumber *active = [self.appState objectForKey:SOUND_KEY];
    if(active == nil) {
        return 0;
    }
    
    return [active intValue] == 1 ? YES : NO;
}

-(void)setPlaySoundOnWarning:(BOOL)playSoundOnWarning {
    [self.appState setObject:[NSNumber numberWithInt:playSoundOnWarning ? 1 : 0] forKey:SOUND_KEY];
    [self saveState];
    if([self.propertyChangeCallbacks valueForKey:PROPERTY_CHANGE_PLAY_SOUND_CHANGE]) {
        PropertyChangeCallback callback = [self.propertyChangeCallbacks valueForKey:PROPERTY_CHANGE_PLAY_SOUND_CHANGE];
        callback(playSoundOnWarning == YES ? 1 : 0);
    }
}

-(void)addPropertyChangeCallback:(NSString *)property propertyChangeCallback:(PropertyChangeCallback)propertyChangeCallback{

    [self.propertyChangeCallbacks setValue:propertyChangeCallback forKeyPath:property];

    
}

-(void)saveState {
    NSString *path = [[AlimitudeSharedAppState getDocsDirectory] stringByAppendingPathComponent:@"settings.plist"];
    
    [self.appState writeToFile:path atomically:YES]; //Write
}


+(NSString *)getDocsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
}

+(instancetype)sharedInstance {
    static AlimitudeSharedAppState *sharedState = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedState = [[self alloc] init];
        if(sharedState.propertyChangeCallbacks == nil) {
            sharedState.propertyChangeCallbacks = [NSMutableDictionary dictionary];
            // read "foo.plist" from application bundle
            NSString *path = [[self getDocsDirectory] stringByAppendingPathComponent:@"settings.plist"];
            sharedState.appState = [NSMutableDictionary dictionaryWithContentsOfFile:path];
            if(sharedState.appState == nil) {
                sharedState.appState = [NSMutableDictionary dictionary];
            }
        }
    });
    
    return sharedState;
}

@end
