//
//  AlimitudeSettingsViewController.m
//  Altimitude
//
//  Created by Robert Kopp on 11/29/14.
//  Copyright (c) 2014 Okoppi. All rights reserved.
//

#import "AlimitudeSettingsViewController.h"
#import "AlimitudeSharedAppState.h"
#import "AlimitudeInstrumentViewController.h"



@interface AlimitudeSettingsViewController ()
@property (nonatomic,strong) CMAltimeter *altimeter;
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
    
    if ([AlimitudeSharedAppState sharedInstance].pressureUnits == ALTITUDE_INHG_UNITS) {
        _pressureSettingScreen.text=[NSString stringWithFormat:@"%.02f",[AlimitudeSharedAppState sharedInstance].currentPressure*0.295333727];
    _pressureLabel.text = @"inHg";
    }
    else {
        _pressureSettingScreen.text=[NSString stringWithFormat:@"%.02f",[AlimitudeSharedAppState sharedInstance].currentPressure*10.00];
           _pressureLabel.text = @"hPa";
    }

    
    self.altimeter = [[CMAltimeter alloc] init];
    
    if([CMAltimeter isRelativeAltitudeAvailable]) {
        [self.altimeter startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAltitudeData *altitudeData, NSError *error) {
            if(error != nil) {
                self.pressureSettingScreen.text = @"Error!";
            } else {
                
                
                if ([AlimitudeSharedAppState sharedInstance].pressureUnits == ALTITUDE_INHG_UNITS) {
                    _pressureSettingScreen.text=[NSString stringWithFormat:@"%.02f",altitudeData.pressure.floatValue*0.295333727];
                    _pressureLabel.text = @"inHg";}
                else {
                    _pressureSettingScreen.text=[NSString stringWithFormat:@"%.02f",altitudeData.pressure.floatValue*10];
                    _pressureLabel.text = @"hPa";
                
        
                }
            }
        }];
    }
    
    
    
    
    
    
    
    //uncomment here to the next obvious statement.
    //if([CMAltimeter isRelativeAltitudeAvailable]){
    //self.altimeter = [[CMAltimeter alloc]init];
       // [self.altimeter startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAltitudeData *altitudeData, NSError *error)]
       // _pressureSettingScreen.text = [NSString stringWithFormat:@"%.02f", altitudeData.pressure.floatValue*0.295333727;
         }
                                       
        // if ([AlimitudeSharedAppState sharedInstance].pressureUnits == ALTITUDE_INHG_UNITS {
        // _pressureSettingScreen.text=[[NSString stringWithFormat:@"%.02f",altitudeData.pressure.floatValue*0.295333727];
           //         }
        //else {
          //  _pressureSettingScreen.text=[NSString stringWithFormat:@"%.2ld",altitudeData.pressure.floatvalue*10];
        //}
                                          
                                          
                                    
                                          
         
         //the above is what you need to uncomment to make pressure happen.
           // _RelativeAltitude.text = [NSString stringWithFormat:@"%.02f m", altitudeData.relativeAltitude.floatValue];
            /**
             the "%.02f" are defining the decimals
             **/
    //}];
    //}
                                          
    
                                          

   // }

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
