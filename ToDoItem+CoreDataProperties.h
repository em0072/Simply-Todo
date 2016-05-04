//
//  ToDoItem+CoreDataProperties.h
//  TableViewDemo
//
//  Created by Митько Евгений on 04.05.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ToDoItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface ToDoItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *color;
@property (nullable, nonatomic, retain) NSString *detail;
@property (nullable, nonatomic, retain) NSDate *dueDate;
@property (nullable, nonatomic, retain) NSDate *historyDate;
@property (nullable, nonatomic, retain) NSNumber *isComplete;
@property (nullable, nonatomic, retain) NSNumber *isNotificationSet;
@property (nullable, nonatomic, retain) NSString *sectionDate;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *sortString;

@end

NS_ASSUME_NONNULL_END
