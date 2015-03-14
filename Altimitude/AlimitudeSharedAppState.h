//
//  AlimitudeSharedAppState.h
//  Altimitude
//
//  Created by Robert Kopp on 11/29/14.
//  Copyright (c) 2014 Okoppi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ALTITUDE_FEET_UNITS 0
#define ALTITUDE_METER_UNITS 1

#define ALTITUDE_INHG_UNITS 0
#define ALTITUDE_HPA_UNITS 1

#define ALARM_STATE_SILENCED 0
#define ALARM_STATE_STARTED 1

#define PROPERTY_CHANGE_ALTITUDE_UNITS @"altUnits"
#define PROPERTY_CHANGE_PRESSURE_UNITS @"presUnits"
#define PROPERTY_CHANGE_FLASH_LIGHT_CHANGE @"flashLight"
#define PROPERTY_CHANGE_VIBRATE_CHANGE @"vibrate"
#define PROPERTY_CHANGE_PLAY_SOUND_CHANGE @"sound"
#define PROPERTY_CHANGE_BG_Mode @"bgmode"

#define WARNINGS_APP_STATE_KEY @"Warnings"
#define ALTITUDE_UNITS_KEY @"AltUnits"
#define PRESSURE_UNITS_KEY @"PressureUnits"
#define FLASH_KEY @"Flash"
#define VIBRATE_KEY @"Vibrate"
#define SOUND_KEY @"Sound"
#define BG_KEY @"BGMode"


@interface AlimitudeSharedAppState : NSObject

typedef void (^PropertyChangeCallback)(int);

@property(strong,nonatomic) NSMutableDictionary *propertyChangeCallbacks;

@property(nonatomic) int altitudeUnits;

@property(nonatomic) int pressureUnits;

@property(nonatomic) BOOL flashLightOnWarning;

@property(nonatomic) BOOL vibrateOnWarning;

@property(nonatomic) BOOL playSoundOnWarning;

@property(nonatomic) BOOL useBGMode;

@property (nonatomic) int alarmState;

@property (strong,nonatomic) NSMutableDictionary *appState;

@property(nonatomic) long previousAltitude;
@property(nonatomic) NSTimeInterval previousAltitudeTimestamp;
@property(nonatomic) long currentPressure;


@property(strong,nonatomic) NSMutableArray *warnings;



+(instancetype)sharedInstance;

-(void)addPropertyChangeCallback:(NSString *)property propertyChangeCallback:(PropertyChangeCallback)propertyChangeCallback;
-(void)saveState;


@end
