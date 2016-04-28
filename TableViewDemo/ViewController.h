//
//  ViewController.h
//  TableViewDemo
//
//  Created by Митько Евгений on 27.04.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTableViewCell.h"
#import "ToDoItem.h"
#import "EMCoreDataContextManager.h"
#import "EMToDoEntityManager.h"
#import "DetailViewController.h"


@interface ViewController : UIViewController <EMCoreDataContextManager>

-(void) reciveManageObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end

