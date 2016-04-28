//
//  ViewController.m
//  TableViewDemo
//
//  Created by Митько Евгений on 27.04.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSFetchedResultsController *resultController;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;


- (void) requestData;

@end

@implementation ViewController

#pragma mark - ViewController Methodes

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    self.resultController.delegate = self;
    self.tableView.rowHeight = 76;

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}

#pragma mark - UITableView DataSource

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.resultController.sections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.resultController.sections[section].name;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultController.sections[section].numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ToDoItem *entity = [self.resultController objectAtIndexPath:indexPath];
    [cell setCell:entity];
    return cell;
}


#pragma mark - NSFetchedResultsController Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller;{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:YES]];
    self.resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"dueDate" cacheName:nil];
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
    ToDoItem *toDoEntity = [ToDoItem alloc];
    
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
       toDoEntity = [NSEntityDescription insertNewObjectForEntityForName:@"ToDoItem" inManagedObjectContext:self.managedObjectContext];
        child.barTitle = @"New To Do";
    } else if ([sender isKindOfClass:[UITableViewCell class]]){
        MyTableViewCell *cell = (MyTableViewCell *) sender;
        toDoEntity = cell.toDoItem;
        child.barTitle = @"Edit To Do";
    }
    
    [child reciveToDoEntity:toDoEntity];
    
}

- (void) reloadTableView: (NSNotification *) notification {
    [self.tableView reloadData];
    NSLog(@"reload table");
}
 
@end
