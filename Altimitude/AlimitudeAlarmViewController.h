//
//  AlimitudeAlarmViewController.h
//  Altimitude
//
//  Created by Robert Kopp on 12/24/14.
//  Copyright (c) 2014 Okoppi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlimitudeAlarmViewController : UIViewController



@property(weak,nonatomic)IBOutlet UILabel *altitudeLabel;
@property(weak,nonatomic)IBOutlet UILabel *messageLabel;


-(void)setMessageStrings:(NSString*) altitude message:(NSString *)message;

-(IBAction)dismissClicked:(id)sender;

@end
