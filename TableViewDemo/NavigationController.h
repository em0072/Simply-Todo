//
//  NavigationController.h
//  TableViewDemo
//
//  Created by Митько Евгений on 27.04.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMCoreDataContextManager.h"

@interface NavigationController : UINavigationController <EMCoreDataContextManager>

-(void) reciveManageObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
