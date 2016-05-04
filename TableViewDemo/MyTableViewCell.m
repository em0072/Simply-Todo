//
//  MyTableViewCell.m
//  TableViewDemo
//
//  Created by Митько Евгений on 27.04.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

#import "MyTableViewCell.h"
#import <ColorPicker/ColorPicker-Swift.h>

@implementation MyTableViewCell

- (void) awakeFromNib {
    [super awakeFromNib];
}

- (void) setCell: (ToDoItem *) incoming {
    self.toDoItem = incoming;
    NSLog(@"%@ has dueDate %@, has section name %@ and is complete %@", [incoming title], incoming.dueDate, incoming.sectionDate, incoming.isComplete);
    self.descriptionLabel.text = incoming.detail;
    self.titleLabel.text = incoming.title;
        
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (incoming.dueDate)
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
        if (incoming.dueDate != nil) {
        NSString *dateString = [dateFormatter stringFromDate:incoming.dueDate];
        self.dateLabel.text = dateString;
    } else {
        self.dateLabel.text = @"No Due Date";
    }
    
    if ([incoming.isNotificationSet isEqual:[NSNumber numberWithBool:YES]]) {
        self.notificationIcon.image = [UIImage imageNamed:@"notificationIcon"];
        self.notificationIconWidth.constant = 20;
        self.horizontalConstrainTonotificationIcon.constant = 8;
    } else {
        self.notificationIcon.image = [[UIImage alloc] init];
        self.notificationIconWidth.constant = 0;
        self.horizontalConstrainTonotificationIcon.constant = 0;
    }
    
    if ([[[NSDate alloc] init] timeIntervalSince1970] > [incoming.dueDate timeIntervalSince1970] && incoming.dueDate != nil) {
        self.overDueLabel.text = @"OVERDUE";
    } else {
        self.overDueLabel.text = @"";
    }
    
    if (incoming.color != nil) {
        self.mainView.backgroundColor = [UIColor colorWithHexString:incoming.color];
        
        CGFloat hue;
        CGFloat saturation;
        CGFloat brightness;
        CGFloat alpha;
        UIColor *color = [UIColor colorWithHexString:incoming.color];
        [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
        self.backgroundColor = [UIColor colorWithHue:hue saturation:saturation brightness:(brightness - 0.05) alpha:1];
    }
    
    if ([incoming.isComplete isEqual:[NSNumber numberWithBool:YES]]) {
        self.overDueLabel.text = @"";
        self.dateLabel.text = @"Done";
    }
    
}
@end
