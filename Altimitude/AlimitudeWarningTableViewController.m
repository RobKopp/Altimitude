//
//  AlimitudeWarningTableViewController.m
//  Altimitude
//
//  Created by Robert Kopp on 11/30/14.
//  Copyright (c) 2014 Okoppi. All rights reserved.
//

#import "AlimitudeWarningTableViewController.h"
#import "AlimitudeSharedAppState.h"
#import "AlimitudeCreateWarningViewController.h"
#import "AlimitudeWarningCellViewController.h"

@interface AlimitudeWarningTableViewController ()

@end

@implementation AlimitudeWarningTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.allowsSelection = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(self.editing) {
        return [[AlimitudeSharedAppState sharedInstance].warnings count] + 1;
    } else {
        return [[AlimitudeSharedAppState sharedInstance].warnings count];
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AlimitudeWarningCellViewController *cell = (AlimitudeWarningCellViewController *)[tableView cellForRowAtIndexPath:indexPath];
    if(cell != nil) {
        self.selectedWarning = cell.warning;
        [self performSegueWithIdentifier:@"CreateWarning" sender:self];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    AlimitudeWarningCellViewController *cell = [tableView dequeueReusableCellWithIdentifier:@"WarningCell"];
    
    if (cell == nil) {
        cell = [[AlimitudeWarningCellViewController alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"WarningCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    NSArray *warnings = [AlimitudeSharedAppState sharedInstance].warnings;
    NSString *units = [AlimitudeSharedAppState sharedInstance].altitudeUnits == ALTITUDE_FEET_UNITS ? @"ft" : @"m";
    
    
    NSInteger row = indexPath.row;
    if(row < [warnings count]) {
        //Its a regular item

        NSDictionary *warning = [warnings objectAtIndex:row];
        cell.warningValue.hidden = NO;
        cell.warningUnits.text = units;
        cell.warningUnits.hidden = NO;
        cell.warning = warning;

        [cell.warningEnabled setOn:[[warning objectForKey:@"Enabled"] isEqualToString:@"YES"]];
        cell.warningEnabled.hidden = NO;
    } else {
        cell.warningValue.text = @"Add Warning";
        cell.warningUnits.hidden = YES;
        cell.warningEnabled.hidden = YES;
    }

    return cell;
}

-(IBAction)saveButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{

    [super setEditing:editing animated:animated];
    if(editing) {
        //Add the add row
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[[AlimitudeSharedAppState sharedInstance].warnings count] inSection:0]] withRowAnimation:UITableViewRowAnimationFade];

    } else {
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[[AlimitudeSharedAppState sharedInstance].warnings count] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *warnings = [AlimitudeSharedAppState sharedInstance].warnings;
    if (indexPath.row >= [warnings count])
        return UITableViewCellEditingStyleInsert;
    //gives green circle with +
    else
        return UITableViewCellEditingStyleDelete;
    //or UITableViewCellEditingStyleNone
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[AlimitudeSharedAppState sharedInstance].warnings removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self setEditing:NO animated:NO];
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        [self performSegueWithIdentifier:@"CreateWarning" sender:self];
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view )[segue destinationViewController]
    AlimitudeCreateWarningViewController *newLoc = (AlimitudeCreateWarningViewController *)[segue destinationViewController];
    if(newLoc != nil) {
        newLoc.warning = self.selectedWarning;
    }
}


@end
