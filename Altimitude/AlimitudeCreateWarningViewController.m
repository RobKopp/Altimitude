//
//  AlimitudeCreateWarningViewController.m
//  Altimitude
//
//  Created by Robert Kopp on 11/30/14.
//  Copyright (c) 2014 Okoppi. All rights reserved.
//

#import "AlimitudeCreateWarningViewController.h"
#import "AlimitudeSharedAppState.h"

@interface AlimitudeCreateWarningViewController () {
    BOOL editing;
    CGRect origLoc;
}

@end

@implementation AlimitudeCreateWarningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.messageView.delegate = self;
    self.warningField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    origLoc = self.textView.frame;
}

-(void)viewWillAppear:(BOOL)animated {
    self.savedText.hidden = YES;
    if(self.warning != nil) {
        self.warningField.text = [NSString stringWithFormat:@"%d", [[self.warning objectForKey:@"Altitude"] intValue]];
        self.messageView.text = [self.warning objectForKey:@"Message"];
        self.warningField.enabled=NO;
    }
    self.unitLabel.text = [AlimitudeSharedAppState sharedInstance].altitudeUnits == ALTITUDE_FEET_UNITS ? @"ft" : @"m";
    editing = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)saveButtonPressed:(id)sender {
    if(!editing) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSNumber *warningNumber = [formatter numberFromString:self.warningField.text ];
        if( warningNumber== nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Altitude Needed!"
                                                            message:@"You need to enter an altitude in the altitude box to save this warning."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
        
        
        //NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        //NSNumber *warningNumber = [formatter numberFromString:self.warningField.text ];
        [self.warningField resignFirstResponder];
        NSMutableArray *warnings = [[AlimitudeSharedAppState sharedInstance] warnings];
        BOOL foundWarning = NO;
        NSMutableDictionary *newWarning = [@{
                                          @"Altitude": warningNumber,
                                          @"Message": self.messageView.text,
                                          @"Enabled": @"YES",
                                          @"Dismissed":@"NO",
                                          } mutableCopy];

        for(int i = 0;i < [warnings count]; ++i) {
            NSMutableDictionary *warning = [warnings objectAtIndex:i];
            long warningAltitude = [[warning objectForKey:@"Altitude"] longValue];
            if(warningAltitude == [warningNumber longValue]) {
                [warning setObject:@"YES" forKey:@"Enabled"];
                [warning setObject:self.messageView.text forKey:@"Message"];
                foundWarning = YES;
                break;
            }else if(warningAltitude > [warningNumber longValue]) {
                [warnings insertObject:newWarning atIndex:i];
                foundWarning = YES;
                break;
            }
        }
        //We do this to add it at the end
        if(!foundWarning) {
            [warnings addObject:newWarning];
        }
        
        [AlimitudeSharedAppState sharedInstance].warnings = warnings;

        self.savedText.hidden = NO;
        self.savedText.alpha = 1.0;
        [UIView animateWithDuration:1.0
                              delay:1.0  /* do not add a delay because we will use performSelector. */
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^ {
                             self.savedText.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             self.savedText.hidden = YES;
                         }];
            [self.navigationController popViewControllerAnimated:YES];}
    } else {
        
        if([self.messageView isFirstResponder]) {
            [self.messageView resignFirstResponder];
        }
        
        if([self.warningField isFirstResponder] ){
            [self.warningField resignFirstResponder];
        }
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    editing = YES;
    self.saveButton.title = @"Done";
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    editing = NO;
    self.saveButton.title = @"Save";
}

-(void)textFieldDidBeginEditing:(UITextField *)textView {
    editing = YES;
    self.saveButton.title = @"Done";
}

-(void)textFieldDidEndEditing:(UITextField *)textView {
    editing = NO;
    self.saveButton.title = @"Save";
}


-(void)keyboardWillHide:(NSNotification*)notification{
    NSDictionary* info = [notification userInfo];
    
    CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect keyboardFrameEnd = [self.view convertRect:keyboardEndFrame toView:nil];
    
    //    CGRect kKeyBoardFrame = [self.view convertRect:[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.textView setFrame:CGRectMake(self.textView.frame.origin.x, origLoc.origin.y
                                           , self.textView.frame.size.width, self.textView.frame.size.height)];
    }];
    
}

-(void)keyboardWillShow:(NSNotification*)notification{
    NSDictionary* info = [notification userInfo];
    
    CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.textView.translatesAutoresizingMaskIntoConstraints = YES;
    CGRect newFrame = self.textView.frame;
    
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.textView.frame = newFrame;
    }];

}



@end
