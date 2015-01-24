//
//  AlimitudeWarningCellViewController.h
//  Altimitude
//
//  Created by Robert Kopp on 11/30/14.
//  Copyright (c) 2014 Okoppi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlimitudeWarningCellViewController : UITableViewCell

@property(weak,nonatomic)IBOutlet UILabel *warningValue;
@property(weak,nonatomic)IBOutlet UILabel *warningUnits;
@property(weak,nonatomic)IBOutlet UISwitch *warningEnabled;

@property(strong, nonatomic)NSDictionary *warning;

-(IBAction)toggleEnabled:(id)sender;

@end
