//
//  NavigationController.m
//  TableViewDemo
//
//  Created by Митько Евгений on 27.04.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

#import "NavigationController.h"



@interface NavigationController()

@property (nonatomic) NSManagedObjectContext *managedObjectContext;

@end


@implementation NavigationController


- (void) viewDidLoad {
    [super viewDidLoad];
}

-(void) reciveManageObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self.managedObjectContext = managedObjectContext;
    id<EMCoreDataContextManager>child = (id<EMCoreDataContextManager>) self.viewControllers[0];
    [child reciveManageObjectContext:self.managedObjectContext];

}


@end
