//
//  DataPickerLabel.m
//  TableViewDemo
//
//  Created by Митько Евгений on 29.04.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

#import "DataPickerLabel.h"


@interface DataPickerLabel()

@end

@implementation DataPickerLabel

- (void) awakeFromNib {
    [super awakeFromNib];
//    self.date = [[NSDate alloc] init];
}


-(void) setText:(NSString *)text {
    [super setText:text];
    
    if ([text isEqualToString:@""]) {
        self.textColor = [[UIColor alloc] initWithRed:0.1921 green:0.1921 blue:0.2196 alpha:1];
    } else {
        self.textColor = [UIColor whiteColor];
    }
}




@end
