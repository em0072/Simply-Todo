//
//  DetailViewController.m
//  TableViewDemo
//
//  Created by Митько Евгений on 27.04.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

#import "DetailViewController.h"



@interface DetailViewController() <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *detailField;
@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;


@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) ToDoItem *itemToEdit;
@property (nonatomic) BOOL isDeleting;
- (void) saveContext;
- (void) saveDataInFields;
@end



@implementation DetailViewController


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.detailField.delegate = self;
    self.isDeleting = NO;
    self.navigationItem.title = self.barTitle;
    
    self.titleField.text = self.itemToEdit.title;
    self.detailField.text = self.itemToEdit.detail;
    
    NSDate *dueDate = self.itemToEdit.dueDate;
    if (dueDate != nil) {
        [self.dataPicker setDate:dueDate];
    }
}


- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    if (!self.isDeleting) {
        [self saveDataInFields];
    }
}

- (void) saveContext {
    NSError *error;
    [self.managedObjectContext save:&error];
    if (error) {
        NSLog(@"Couldn't save");
    }
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.titleField resignFirstResponder];
    [self.detailField resignFirstResponder];
}

- (IBAction)trashButtonTapped:(id)sender {
    self.isDeleting = YES;
    [self.managedObjectContext deleteObject:self.itemToEdit];
    [self saveContext];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) reciveManageObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self.managedObjectContext = managedObjectContext;
}

- (void) reciveToDoEntity: (ToDoItem *)toDoEntity{
    self.itemToEdit = toDoEntity;
}
- (IBAction)titleFieldEndEditing:(id)sender {
    self.itemToEdit.title = self.titleField.text;
    [self saveContext];
}
- (IBAction)dataPickerEndEditing:(id)sender {
    self.itemToEdit.dueDate = self.dataPicker.date;
    [self saveContext];
}



- (void)textViewDidEndEditing:(UITextView *)textView {
    self.itemToEdit.detail = self.detailField.text;
        [self saveContext];
}

- (void) saveDataInFields {
    self.itemToEdit.title = self.titleField.text;
    self.itemToEdit.dueDate = self.dataPicker.date;
    self.itemToEdit.detail = self.detailField.text;

    [self saveContext];
}




@end
