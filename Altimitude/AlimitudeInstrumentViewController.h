//
//  AlimitudeInstrumentViewController.h
//  Altimitude
//
//  Created by Robert Kopp on 11/29/14.
//  Copyright (c) 2014 Okoppi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

@interface AlimitudeInstrumentViewController : UIViewController <CLLocationManagerDelegate,UIAlertViewDelegate>
@property(weak,nonatomic)IBOutlet UILabel *altitude;
@property(weak,nonatomic)IBOutlet UILabel *altitudeUnits;
@property(weak,nonatomic)IBOutlet UILabel *verticalSpeed;
@property(weak,nonatomic)IBOutlet UILabel *verticalSpeedUnits;
@property(weak,nonatomic)IBOutlet UILabel *verticalSpeedTitle;
@property(weak,nonatomic)IBOutlet UISwitch *debugOption;
@property (strong, nonatomic) IBOutlet UISwitch *bgWarningsSwitch;
@property(nonatomic) int testNum;
@property(strong,nonatomic)CMAltimeter *altimeter;
@property (weak, nonatomic) IBOutlet UILabel *GPSAltitude;
@property(strong,nonatomic)CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
-(IBAction)debugOptionChange:(id)sender;
@end
