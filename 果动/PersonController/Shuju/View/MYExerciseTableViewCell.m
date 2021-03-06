//
//  MYExerciseTableViewCell.m
//  果动
//
//  Created by mac on 15/7/29.
//  Copyright (c) 2015年 Unique. All rights reserved.
//


#import "MYExerciseTableViewCell.h"
@implementation MYExerciseTableViewCell

// 初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        // 把自定义的控件 变成了单元格的属性
        self.frame = CGRectMake(0, 0, viewWidth, Adaptive(70));
        self.baseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.baseImageView];

        self.coachLabel = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(13), (self.frame.size.height - Adaptive(40)) / 2, Adaptive(125), Adaptive(40))];
        self.coachLabel.font = [UIFont fontWithName:FONT size:Adaptive(16)];
        self.coachLabel.textColor = [UIColor whiteColor];

        self.coachLabel.text = @"教练:陈菲菲";
        self.coachLabel.textAlignment = 1;
        [self addSubview:self.coachLabel];

        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.baseImageView.bounds.size.width - Adaptive(125) - Adaptive(10), (self.frame.size.height - Adaptive(40)) / 2, Adaptive(125), Adaptive(40))];
        self.timeLabel.textColor = [UIColor lightGrayColor];
        self.timeLabel.text = @"日期:2015-04-29";
        self.timeLabel.font = [UIFont fontWithName:FONT size:Adaptive(11)];
        [self addSubview:self.timeLabel];
    }
    return self;
}

@end
