//
//  ToDoItem+CoreDataProperties.m
//  TableViewDemo
//
//  Created by Митько Евгений on 28.04.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ToDoItem+CoreDataProperties.h"

@implementation ToDoItem (CoreDataProperties)

@dynamic detail;
@dynamic dueDate;
@dynamic title;
@dynamic priority;
@dynamic color;
@dynamic sectionDate;

@end
