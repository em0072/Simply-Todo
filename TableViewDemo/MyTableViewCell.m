//
//  MyTableViewCell.m
//  TableViewDemo
//
//  Created by Митько Евгений on 27.04.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

- (void) awakeFromNib {
    [super awakeFromNib];
}

- (void) setCell: (ToDoItem *) incoming {
    self.toDoItem = incoming;
    
    self.descriptionLabel.text = incoming.detail;
    self.titleLabel.text = incoming.title;
        
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (incoming.dueDate)
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    
//    dateFormatter.dateFormat = @"HH:mm, MMMM dd, yyyy";
    NSString *dateString = [dateFormatter stringFromDate:incoming.dueDate];
    self.dateLabel.text = dateString;
    NSLog(@"%@", incoming.priority);
    
    
     
}
@end
