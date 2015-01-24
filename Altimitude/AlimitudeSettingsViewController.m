//
//  AlimitudeSettingsViewController.m
//  Altimitude
//
//  Created by Robert Kopp on 11/29/14.
//  Copyright (c) 2014 Okoppi. All rights reserved.
//

#import "AlimitudeSettingsViewController.h"
#import "AlimitudeSharedAppState.h"



@interface AlimitudeSettingsViewController ()

@end

@implementation AlimitudeSettingsViewController

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
    
}

-(void)viewWillAppear:(BOOL)animated {
    AlimitudeSharedAppState *sharedInstance =[AlimitudeSharedAppState sharedInstance];
    [self.altitudeUnitsSwitch setOn: sharedInstance.altitudeUnits == ALTITUDE_METER_UNITS];
    [self.pressureUnitsSwitch setOn:sharedInstance.pressureUnits == ALTITUDE_HPA_UNITS ];
    [self.flashLightsSwitch setOn:sharedInstance.flashLightOnWarning];
    [self.vibrateSwitch setOn:sharedInstance.vibrateOnWarning];
    [self.playSoundSwitch setOn:sharedInstance.playSoundOnWarning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)altitudeUnitsClicked:(id)sender {
    BOOL isSelected = ((UISwitch*)sender).isOn;
    [AlimitudeSharedAppState sharedInstance].altitudeUnits = isSelected ? ALTITUDE_METER_UNITS : ALTITUDE_FEET_UNITS;
}

-(IBAction)pressureUnitsClicked:(id)sender {
    BOOL isSelected = ((UISwitch*)sender).isOn;
    [AlimitudeSharedAppState sharedInstance].pressureUnits = isSelected ? ALTITUDE_HPA_UNITS : ALTITUDE_INHG_UNITS;
}

-(IBAction)flashLightsClicked:(id)sender {
    BOOL isSelected = ((UISwitch*)sender).isOn;
    [AlimitudeSharedAppState sharedInstance].flashLightOnWarning = isSelected;
    
}

-(IBAction)vibrateClicked:(id)sender {
    BOOL isSelected = ((UISwitch*)sender).isOn;
    [AlimitudeSharedAppState sharedInstance].vibrateOnWarning = isSelected;
}

-(IBAction)soundClicked:(id)sender {
    BOOL isSelected = ((UISwitch*)sender).isOn;
    [AlimitudeSharedAppState sharedInstance].playSoundOnWarning = isSelected;
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
