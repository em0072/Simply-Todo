//
//  DetailViewController.m
//  TableViewDemo
//
//  Created by Митько Евгений on 27.04.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

#import "DetailViewController.h"
#import <ColorPicker/ColorPicker-Swift.h>



@interface DetailViewController() <ColorPickerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *detailField;
@property (weak, nonatomic) IBOutlet DataPickerLabel *dataPicker;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;
@property (weak, nonatomic) IBOutlet ColorPickerListView *colorPicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashButton;


@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) ToDoItem *itemToEdit;
@property (nonatomic) HSDatePickerViewController *hsdpvc;
@property (nonatomic) NSDateFormatter *dateManager;
@property (nonatomic) NSString *rowColor;


- (void) saveContext;
- (void) saveDataInFields;
- (void) setDueDate: (UITapGestureRecognizer *)tap;
- (void)hsDatePickerPickedDate:(NSDate *)date;
- (void) enableClearButton;
- (void) createNotification;
- (void) registerForNotifications;
- (void) deletNotification;

@end


@implementation DetailViewController 

#pragma mark - View Methods

- (void) viewDidLoad {
    [super viewDidLoad];
    
    
    if (self.isEditing == NO) {
        self.trashButton.enabled = NO;
        
    }
    self.dateManager = [[NSDateFormatter alloc] init];
    self.dateManager.dateFormat = @"HH:mm, EEE, MMM dd, yyyy";
    self.navigationItem.backBarButtonItem.title = @"Don't Save";
    //Add Tap gesture to dataPickerLabel
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(setDueDate:)];
    [self.dataPicker addGestureRecognizer:tap];

    self.colorPicker.colorPickerDelegate = self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self deletNotification];
    
    self.navigationItem.title = self.barTitle;
    self.titleField.text = self.itemToEdit.title;
    self.detailField.text = self.itemToEdit.detail;
    
    
    if (self.itemToEdit.dueDate != nil) {
    self.dataPicker.date = self.itemToEdit.dueDate;
    self.dataPicker.text = [self.dateManager stringFromDate:self.itemToEdit.dueDate];
        [self enableClearButton];
    }
    
    if ([self.itemToEdit.isNotificationSet  isEqual: @YES]) {
        self.notificationSwitch.on = YES;
    } else {
        self.notificationSwitch.on = NO;
    }
    
    NSDate *dueDate = self.itemToEdit.dueDate;
    if (dueDate != nil) {
        [self.dataPicker setDate:dueDate];
    }
    
    
    if (self.itemToEdit.color != nil && ![self.itemToEdit.color  isEqual: @"#404040"]) {
            [self.colorPicker selectColor:self.itemToEdit.color];
    } else {
        self.rowColor =  @"#404040";
    }
    
}

#pragma mark - Gesture Methods


-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.titleField resignFirstResponder];
    [self.detailField resignFirstResponder];
}

#pragma mark - TextField Delegate Methods

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [self.titleField resignFirstResponder];
    [self.detailField resignFirstResponder];
    return YES;
}

#pragma mark - IBAction Methods

- (IBAction)trashButtonTapped:(id)sender {
    [self.managedObjectContext deleteObject:self.itemToEdit];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)saveButtonPressed:(id)sender {
    
    [self saveDataInFields];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)todayButtonTapped:(id)sender {
    NSDateComponents* deltaComps = [[NSDateComponents alloc] init];
    [deltaComps setHour:5];
    NSDate* todayDate = [[NSCalendar currentCalendar] dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
    self.dataPicker.date = todayDate;
    self.dataPicker.text = [self.dateManager stringFromDate:todayDate];
    [self enableClearButton];
}

- (IBAction)tomorrowButtonTapped:(id)sender {
    NSDateComponents* deltaComps = [[NSDateComponents alloc] init];
    [deltaComps setDay:1];
    NSDate* tomorrow = [[NSCalendar currentCalendar] dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
    self.dataPicker.date = tomorrow;
    self.dataPicker.text = [self.dateManager stringFromDate:tomorrow];
    [self enableClearButton];
}

- (IBAction)inAWeekButtonTapped:(id)sender {
    NSDateComponents* deltaComps = [[NSDateComponents alloc] init];
    [deltaComps setDay:7];
    NSDate* inAWeek = [[NSCalendar currentCalendar] dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
    self.dataPicker.date = inAWeek;
    self.dataPicker.text = [self.dateManager stringFromDate:inAWeek];
    [self enableClearButton];

}

- (IBAction)cleraButtonPressed:(id)sender {
    self.dataPicker.text = @"Pick Due Date (optional)";
    self.dataPicker.textColor = [[UIColor alloc] initWithRed:0.1921 green:0.1921 blue:0.2196 alpha:1];
    self.dataPicker.date = nil;
    [self.clearButton setImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    self.clearButton.enabled = NO;
}

- (IBAction)notificationSwitchCangeValue:(id)sender {
    if (self.notificationSwitch.on == YES) {
        [self registerForNotifications];
    } else {
        NSLog(@"Turn of notifications");
    }
}

#pragma  mark - CoreData Methods

-(void) reciveManageObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self.managedObjectContext = managedObjectContext;
}

- (void) saveContext {
    NSError *error;
    [self.managedObjectContext save:&error];
    if (error) {
        NSLog(@"Couldn't save");
    }
}



#pragma mark - HSDatePickerViewController Delegate
- (void)hsDatePickerPickedDate:(NSDate *)date {
    NSString *dateString = [self.dateManager stringFromDate:date];
    self.dataPicker.text = dateString;
    self.dataPicker.date = date;
    [self enableClearButton];
}

#pragma mark - ColorPicker Delegate

- (void) colorPicker:(ColorPickerListView *)colorPicker selectedColor:(NSString *)selectedColor {
    self.rowColor = selectedColor;
//    self.itemToEdit.color = color;
//    NSLog(@"Select color - %@", selectedColor);
//    NSLog(@"Color in item - %@", self.itemToEdit.color);
}

- (void) colorPicker:(ColorPickerListView *)colorPicker deselectedColor:(NSString *)deselectedColor {
    self.rowColor = @"#404040";
}

#pragma mark - Helper Methods

- (void) createNotification {
    if (self.notificationSwitch.on == YES) {
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = self.itemToEdit.dueDate;
        localNotification.alertBody = self.itemToEdit.title;
        localNotification.alertAction = @"Show The ToDo";
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        localNotification.soundName = @"notificationSound.wav";
        
        NSString *idString = self.itemToEdit.title;
        idString = [idString stringByAppendingString:self.itemToEdit.detail];
        idString = [idString stringByAppendingString:self.itemToEdit.sectionDate];
        
        localNotification.userInfo = @{@"id":idString};
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        self.itemToEdit.isNotificationSet = @YES;
    } else {
        self.itemToEdit.isNotificationSet = @NO;
        NSLog(@"No notifications");
    }
}

- (void) deletNotification {
    NSString *idString = self.itemToEdit.title;
    idString = [idString stringByAppendingString:self.itemToEdit.detail];
    idString = [idString stringByAppendingString:self.itemToEdit.sectionDate];
    
    NSArray *notificationsArray = [[UIApplication sharedApplication] scheduledLocalNotifications];

    for (int i = 0; i < [notificationsArray count]; i++) {
        UILocalNotification *notification = notificationsArray[i];
        NSDictionary *userInfo = notification.userInfo;
        NSString *idStringFromUserInfo = [userInfo objectForKey:@"id"];
        
        if ([idString isEqualToString:idStringFromUserInfo]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

- (void) registerForNotifications {
    UIMutableUserNotificationCategory *notificationCategory = [[UIMutableUserNotificationCategory alloc] init];
    notificationCategory.identifier = @"MAIN_CATEGORY";
    
    NSSet *categorySet = [NSSet setWithObjects:notificationCategory, nil];
    
    UIUserNotificationType type = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:categorySet];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];

}

- (void) enableClearButton {
    [self.clearButton setImage:[UIImage imageNamed:@"Clear"] forState:UIControlStateNormal];
    self.clearButton.enabled = YES;
}

- (void) setDueDate: (UITapGestureRecognizer *)tap {
    self.hsdpvc = [[HSDatePickerViewController alloc] init];
    self.hsdpvc.delegate = self;
    if (self.dataPicker.date != nil){
        self.hsdpvc.date = self.dataPicker.date;
    }
    self.hsdpvc.mainColor = [[UIColor alloc] initWithRed:0.6078 green:0.6823 blue:0.7843 alpha:1];
    [self presentViewController:self.hsdpvc animated:YES completion:nil];
}

- (void) reciveToDoEntity: (ToDoItem *)toDoEntity{
    self.itemToEdit = toDoEntity;
}

- (void) saveDataInFields {
    if (self.isEditing) {
        [self.managedObjectContext deleteObject:self.itemToEdit];
    }
    
    self.itemToEdit = [NSEntityDescription insertNewObjectForEntityForName:@"ToDoItem" inManagedObjectContext:self.managedObjectContext];
    
    self.itemToEdit.title = self.titleField.text;
    self.itemToEdit.detail = self.detailField.text;
    
    if (self.dataPicker.date == nil) {
        self.itemToEdit.sectionDate = @" My Simple Tasks";
        self.itemToEdit.sortString = @"a";
        
        NSDateComponents *completeDate  =[[NSDateComponents alloc] init];
        [completeDate setDay:2];
        [completeDate setMonth: 1];
        [completeDate setYear: 1970];
        NSCalendar *g = [[ NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        self.itemToEdit.historyDate = [g dateFromComponents:completeDate];
    } else {
        self.itemToEdit.dueDate = self.dataPicker.date;
        self.itemToEdit.historyDate = self.itemToEdit.dueDate;
        self.itemToEdit.sectionDate = [self dateToSectionDateFromNSDate:self.dataPicker.date];
//        NSString *sort = @"b";
//        sort = [sort stringByAppendingString:[NSString stringWithFormat:@"%f", [self.itemToEdit.dueDate timeIntervalSince1970]]];
//        self.itemToEdit.sortString = sort;
        // Create notification, order matters!!
        [self createNotification];
    }
    self.itemToEdit.color = self.rowColor;
    
    self.itemToEdit.isComplete = @NO;
    
    
    [self saveContext];
    NSLog(@"Color - %@", self.itemToEdit.color);
    
    
}

- (NSString *) dateToSectionDateFromNSDate: (NSDate *) date {
    NSDateFormatter *sectionDateFormatter = [[NSDateFormatter alloc] init];
    sectionDateFormatter.dateStyle = NSDateFormatterFullStyle;
    return [sectionDateFormatter stringFromDate:date];
}
@end
