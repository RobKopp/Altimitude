//
//  AlimitudeSettingsViewController.h
//  Altimitude
//
//  Created by Robert Kopp on 11/29/14.
//  Copyright (c) 2014 Okoppi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>


@interface AlimitudeSettingsViewController : UIViewController

@property(weak,nonatomic)IBOutlet UISwitch *altitudeUnitsSwitch;
@property(weak,nonatomic)IBOutlet UISwitch *pressureUnitsSwitch;
@property(weak,nonatomic)IBOutlet UISwitch *flashLightsSwitch;
@property(weak,nonatomic)IBOutlet UISwitch *vibrateSwitch;
@property(weak,nonatomic)IBOutlet UISwitch *playSoundSwitch;
@property(weak,nonatomic)IBOutlet UILabel *pressuredatalabel;
@property (weak, nonatomic) IBOutlet UISwitch *pressureswitcher;
@property (weak, nonatomic) IBOutlet UILabel *pressureSettingScreen;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;



-(IBAction)altitudeUnitsClicked:(id)sender;
-(IBAction)pressureUnitsClicked:(id)sender;
-(IBAction)flashLightsClicked:(id)sender;
-(IBAction)vibrateClicked:(id)sender;
-(IBAction)soundClicked:(id)sender;
-(IBAction)switchvaluechanged:(UISwitch *) pressureswitcher;


@end
