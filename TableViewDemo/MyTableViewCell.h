//
//  MyTableViewCell.h
//  TableViewDemo
//
//  Created by Митько Евгений on 27.04.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoItem.h"
#import <MGSwipeTableCell/MGSwipeTableCell.h>

@interface MyTableViewCell : MGSwipeTableCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *notificationIcon;
@property (nonatomic) ToDoItem * toDoItem;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notificationIconWidth;
@property (weak, nonatomic) IBOutlet UILabel *overDueLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalConstrainTonotificationIcon;
@property (weak, nonatomic) IBOutlet UIView *mainView;


- (void) setCell: (ToDoItem *) incoming;

@end
