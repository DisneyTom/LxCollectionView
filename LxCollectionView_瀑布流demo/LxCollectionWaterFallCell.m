//
//  LxCollectionWaterfallCell.m
//  LxCollectionWaterfallFlow
//
//  Created by admin on 15/8/11.
//  Copyright (c) 2015年 YinLong. All rights reserved.
//

#import "LxCollectionWaterFallCell.h"

@implementation LxCollectionWaterFallCell

#pragma mark -
#pragma mark init methods
- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont boldSystemFontOfSize:25];
        _label.textColor = [UIColor blackColor];
    }
    return _label;
}

#pragma mark -
#pragma mark lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.label];
    }
    return self;
}

@end
