//
//  ViewController.m
//  TableViewDemo
//
//  Created by Митько Евгений on 27.04.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

#import "ViewController.h"
#import <ColorPicker/ColorPicker-Swift.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, NSFetchedResultsControllerDelegate, MGSwipeTableCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSFetchedResultsController *resultController;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;


- (void) requestData;
- (void) saveContext;
- (void) deletNotificationForCell: (MyTableViewCell *)cell;

@end

@implementation ViewController

#pragma mark - ViewController Methodes

- (void)viewDidLoad {
    [super viewDidLoad];
     [self requestData];
    self.resultController.delegate = self;
    self.tableView.rowHeight = 76;
    [self.tableView reloadData];
   

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
//    [self.tableView reloadData];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self.tableView reloadData];
}

#pragma mark - UITableView DataSource
- (void)configureCell:(id)cell atIndexPath:(NSIndexPath*)indexPath
{
    ToDoItem *entity = [self.resultController objectAtIndexPath:indexPath];
    [cell setCell:entity];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.resultController.sections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    NSString *dateString = self.resultController.sections[section].name;
    NSDateFormatter *dateFormatterForSection = [[NSDateFormatter alloc] init];
    [dateFormatterForSection setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatterForSection setLocale:[NSLocale currentLocale]];
    NSDate *capturedStartDate = [dateFormatterForSection dateFromString: dateString];
    NSLog(@"%@", dateString);
    NSString *sectionName = [[NSString alloc] init];
    if ([dateString isEqualToString:@"1970-01-01 21:00:00 +0000"]) {
        sectionName = @"My Simple Tasks";
    } else if ([dateString isEqualToString:@"5000-01-01 21:00:00 +0000"]) {
        sectionName = @"🐣Completed";
    } else {
        sectionName = [self dateToSectionDateFromNSDate:capturedStartDate];
    }
    
    
    
    return sectionName; //self.resultController.sections[section].name;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultController.sections[section].numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    MGSwipeButton *deleteButton = [MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"trash"]  backgroundColor:[UIColor colorWithHexString:@"#E71D36"] callback:^BOOL(MGSwipeTableCell *sender)
    {
        [self.managedObjectContext deleteObject:cell.toDoItem];
        [self saveContext];
        return YES;
    }];
    
    NSString *imgName;
    NSString *buttonColor;
    if ([cell.toDoItem.sectionDate isEqualToString: @"🐣Completed"]) {
        imgName = @"notComplete";
        buttonColor = @"#e3632d";
    } else {
        imgName = @"complete";
        buttonColor = @"#56A902";
    }
    
    MGSwipeButton *completeButton = [MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:imgName]  backgroundColor:[UIColor colorWithHexString:buttonColor] callback:^BOOL(MGSwipeTableCell *sender)
                                   {
                                       if ([cell.toDoItem.sectionDate isEqualToString: @"🐣Completed"]) {
                                           if (cell.toDoItem.dueDate == nil) {
                                               cell.toDoItem.sectionDate = @" My Simple Tasks";
                                               
                                               NSDateComponents *completeDate  =[[NSDateComponents alloc] init];
                                               [completeDate setDay:2];
                                               [completeDate setMonth: 1];
                                               [completeDate setYear: 1970];
                                               NSCalendar *g = [[ NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                                               cell.toDoItem.historyDate = [g dateFromComponents:completeDate];
                                               
                                           } else {
                                               cell.toDoItem.sectionDate = [self dateToSectionDateFromNSDate:cell.toDoItem.dueDate];
                                               cell.toDoItem.historyDate = cell.toDoItem.dueDate;
                                           }
                                           cell.toDoItem.isComplete = @NO;
                                       } else {
                                             cell.toDoItem.sectionDate = @"🐣Completed";
                                             [self deletNotificationForCell:cell];
                                           cell.toDoItem.isComplete = @YES;
                                           NSDateComponents *completeDate  =[[NSDateComponents alloc] init];
                                           [completeDate setDay:2];
                                           [completeDate setMonth: 1];
                                           [completeDate setYear: 5000];
                                           NSCalendar *g = [[ NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                                           cell.toDoItem.historyDate = [g dateFromComponents:completeDate];
                                       }
                                       [self saveContext];
                                       return YES;
                                   }];

    
    cell.rightButtons = @[deleteButton, completeButton];
    cell.rightExpansion.threshold = 1.5;
    cell.rightExpansion.buttonIndex = 1;
    cell.rightExpansion.fillOnTrigger = YES;
    
    return cell;
}


#pragma mark - NSFetchedResultsController Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller;{
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeUpdate:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            break;
        case NSFetchedResultsChangeMove:
            [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [[self tableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];;
            break;
        case NSFetchedResultsChangeUpdate:
            [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [[self tableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];;
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller;{
    [self.tableView endUpdates];
}


#pragma mark - Helper methods

- (void) requestData {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"ToDoItem" inManagedObjectContext:self.managedObjectContext];
    request.predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"historyDate" ascending:YES],[[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:YES]];
    
    self.resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"historyDate" cacheName:nil];
    NSError *error;
    BOOL fetchSucceeded = [self.resultController performFetch:&error];
    if (!fetchSucceeded) {
        NSLog(@"Couldn't fetch");
    }
}

-(void) reciveManageObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self.managedObjectContext = managedObjectContext;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailViewController *child = (DetailViewController *)segue.destinationViewController;
        [child reciveManageObjectContext:self.managedObjectContext];
    
    
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        child.barTitle = @"New To Do";
        child.isEditing = NO;
    } else if ([sender isKindOfClass:[UITableViewCell class]]){
        child.isEditing = YES;
        ToDoItem *toDoEntity = [ToDoItem alloc];
        MyTableViewCell *cell = (MyTableViewCell *) sender;
        toDoEntity = cell.toDoItem;
        child.barTitle = @"Edit To Do";
        [child reciveToDoEntity:toDoEntity];
    }
    
    
    
}

- (void) saveContext {
    NSError *error;
    [self.managedObjectContext save:&error];
    if (error) {
        NSLog(@"Couldn't save");
    }
}

- (void) deletNotificationForCell: (MyTableViewCell *)cell {
    NSString *idString = cell.toDoItem.title;
    idString = [idString stringByAppendingString:cell.toDoItem.detail];
    idString = [idString stringByAppendingString:cell.toDoItem.sectionDate];
    
    NSArray *notificationsArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (int i = 0; i < [notificationsArray count]; i++) {
        UILocalNotification *notification = notificationsArray[i];
        NSDictionary *userInfo = notification.userInfo;
        NSString *idStringFromUserInfo = [userInfo objectForKey:@"id"];
        
        if ([idString isEqualToString:idStringFromUserInfo]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
    cell.toDoItem.isNotificationSet = @NO;
}


- (NSString *) dateToSectionDateFromNSDate: (NSDate *) date {
    NSDateFormatter *sectionDateFormatter = [[NSDateFormatter alloc] init];
    sectionDateFormatter.dateStyle = NSDateFormatterFullStyle;
    return [sectionDateFormatter stringFromDate:date];
}



 
@end
