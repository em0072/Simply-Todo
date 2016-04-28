//
//  EMToDoEntityManager.h
//  TableViewDemo
//
//  Created by Митько Евгений on 27.04.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToDoItem.h"

@protocol EMToDoEntityManager <NSObject>

- (void) reciveToDoEntity: (ToDoItem *)toDoEntity;

@end
