//
//  ToDoItem+CoreDataProperties.h
//  TableViewDemo
//
//  Created by Митько Евгений on 28.04.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ToDoItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface ToDoItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *detail;
@property (nullable, nonatomic, retain) NSDate *dueDate;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *priority;
@property (nullable, nonatomic, retain) NSNumber *color;
@property (nullable, nonatomic, retain) NSString *sectionDate;

@end

NS_ASSUME_NONNULL_END
