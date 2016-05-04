//
//  DataPickerLabel.h
//  TableViewDemo
//
//  Created by Митько Евгений on 29.04.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface DataPickerLabel : UILabel

@property NSDate *date;

- (void) setText:(NSString *)text;


@end
