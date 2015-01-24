//
//  AlimitudeInstrumentViewController.h
//  Altimitude
//
//  Created by Robert Kopp on 11/29/14.
//  Copyright (c) 2014 Okoppi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface AlimitudeInstrumentViewController : UIViewController

@property(weak,nonatomic)IBOutlet UILabel *altitude;
@property(weak,nonatomic)IBOutlet UILabel *altitudeUnits;

@property(weak,nonatomic)IBOutlet UILabel *verticalSpeed;
@property(weak,nonatomic)IBOutlet UILabel *verticalSpeedUnits;
@property(weak,nonatomic)IBOutlet UILabel *verticalSpeedTitle;
@property(weak,nonatomic)IBOutlet UISwitch *debugOption;

@property(nonatomic) int testNum;

@property(strong,nonatomic)CMAltimeter *altimeter;

-(IBAction)debugOptionChange:(id)sender;




@end
