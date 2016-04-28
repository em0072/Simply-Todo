//
//  DetailViewController.h
//  TableViewDemo
//
//  Created by Митько Евгений on 27.04.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMCoreDataContextManager.h"
#import "EMToDoEntityManager.h"
#import "ToDoItem.h"


@interface DetailViewController : UIViewController <EMCoreDataContextManager, EMToDoEntityManager>

@property (nonatomic) NSString *barTitle;

- (void) reciveManageObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (void) reciveToDoEntity: (ToDoItem *)toDoEntity;

@end
