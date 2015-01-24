//
//  AlimitudeWarningTableViewController.h
//  Altimitude
//
//  Created by Robert Kopp on 11/30/14.
//  Copyright (c) 2014 Okoppi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlimitudeWarningTableViewController : UITableViewController

@property(strong, nonatomic)NSDictionary *selectedWarning;

-(IBAction)saveButtonPressed:(id)sender;

@end
