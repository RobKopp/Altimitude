//
//  AlimitudeCreateWarningViewController.h
//  Altimitude
//
//  Created by Robert Kopp on 11/30/14.
//  Copyright (c) 2014 Okoppi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlimitudeCreateWarningViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate>

@property(weak,nonatomic)IBOutlet UILabel *unitLabel;
@property(weak,nonatomic)IBOutlet UITextField *warningField;
@property(weak,nonatomic)IBOutlet UITextView *messageView;
@property(weak,nonatomic)IBOutlet UILabel *savedText;
@property(weak,nonatomic)IBOutlet UIView *textView;

@property(weak,nonatomic)IBOutlet UIBarButtonItem *saveButton;

@property(strong, nonatomic)NSDictionary *warning;

-(IBAction)saveButtonPressed:(id)sender;

@end
