//
//  EMCoreDataContextManager.h
//  TableViewDemo
//
//  Created by Митько Евгений on 27.04.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol EMCoreDataContextManager <NSObject>

- (void) reciveManageObjectContext: (NSManagedObjectContext *)managedObjectContext;

@end
