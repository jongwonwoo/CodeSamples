//
//  CPQuantityCounterView.m
//  NumberCounter
//
//  Created by Jongwon Woo on 07/10/2019.
//  Copyright © 2019 jongwonwoo. All rights reserved.
//

#import "CPQuantityCounterView.h"
#import "CPNumberCounterView.h"

@interface CPQuantityCounterView ()

@property (nonatomic, weak) UIView *containerView;

@end

@implementation CPQuantityCounterView

- (void)setMinDigit:(NSUInteger)minDigit {
    _minDigit = MAX(1, minDigit);
    if (_minDigit > self.maxDigit) {
        self.maxDigit = _minDigit;
    }
}

- (void)setMaxDigit:(NSUInteger)maxDigit {
    _maxDigit = MAX(1, MAX(self.minDigit, maxDigit));
}

- (void)setFromValue:(NSUInteger)fromValue {
    _fromValue = fromValue;
    
    [self makeCounterViews];
}

- (void)setToValue:(NSUInteger)toValue {
    _toValue = toValue;
    
    [self makeCounterViews];
}

- (void)makeCounterViews {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    UIView *containerview = [[UIView alloc] initWithFrame:self.bounds];
    self.containerView = containerview;
    [self addSubview:containerview];
    
    NSMutableArray<NSNumber *> *fromNumbers = [[self numberListWithNumber:self.fromValue] mutableCopy];
    NSMutableArray<NSNumber *> *toNumbers = [[self numberListWithNumber:self.toValue] mutableCopy];
    if (fromNumbers.count != toNumbers.count) {
        if (fromNumbers.count > toNumbers.count) {
            for (NSUInteger i = 0, len = fromNumbers.count - toNumbers.count; i < len; i++) {
                [toNumbers insertObject:@(0) atIndex:0];
            }
        } else if (toNumbers.count > fromNumbers.count) {
            for (NSUInteger i = 0, len = toNumbers.count - fromNumbers.count; i < len; i++) {
                [fromNumbers insertObject:@(0) atIndex:0];
            }
        }
    }
    
    if (fromNumbers.count > self.maxDigit) {
        [fromNumbers removeObjectsInRange:NSMakeRange(0, fromNumbers.count - self.maxDigit)];
    }
    if (toNumbers.count > self.maxDigit) {
        [toNumbers removeObjectsInRange:NSMakeRange(0, toNumbers.count - self.maxDigit)];
    }
    
    CGFloat offsetX = 0;
    CGFloat totalWidth = 0;
    NSUInteger diffIndex = toNumbers.count;
    const NSUInteger commaIndex = toNumbers.count % 3;
    for (NSUInteger index = 0, len = toNumbers.count; index < len; index++) {
        if (diffIndex == len) {
            if ([fromNumbers[index] unsignedIntegerValue] != [toNumbers[index] unsignedIntegerValue]) {
                diffIndex = index;
            }
        }
        UIView *numberCounterView = [self makeNumberCounterViewWithFrame:CGRectMake(offsetX, 0, 30, 30) fromValue:[fromNumbers[index] unsignedIntegerValue] toValue:[toNumbers[index] unsignedIntegerValue] oneMoreRotation:diffIndex < index rollingDown:self.fromValue > self.toValue];
        [containerview addSubview:numberCounterView];
        offsetX += CGRectGetWidth(numberCounterView.frame);
        totalWidth = CGRectGetMaxX(numberCounterView.frame);
        
        if ((index + 1) != len) {
            if ((index + 1) % 3 == commaIndex) {
                UIView *commaView = [self makeCommaViewWithFrame:CGRectMake(offsetX, 9, 9, 25)];
                [containerview addSubview:commaView];
                offsetX += CGRectGetWidth(commaView.frame);
                totalWidth = CGRectGetMaxX(commaView.frame);
            } else {
                offsetX += 2;
            }
        }
    }
    
    UIView *unitView = [self makeUnitViewWithFrame:CGRectMake(offsetX, 0, 18, 30)];
    [containerview addSubview:unitView];
    totalWidth = CGRectGetMaxX(unitView.frame);
    
    containerview.frame = CGRectMake((CGRectGetWidth(self.bounds) - totalWidth) / 2, 0, totalWidth, CGRectGetHeight(self.bounds));
}

- (UIView *)makeNumberCounterViewWithFrame:(CGRect)rect fromValue:(NSUInteger)fromValue toValue:(NSUInteger)toValue oneMoreRotation:(BOOL)oneMoreRotation rollingDown:(BOOL)rollingDown {
    CPNumberCounterView *numberCounterView = [[CPNumberCounterView alloc] initWithFrame:rect];
    numberCounterView.backgroundColor = [UIColor blackColor];
    numberCounterView.layer.cornerRadius = 2;
    numberCounterView.layer.borderColor = [UIColor blackColor].CGColor;
    numberCounterView.layer.borderWidth = 1;
    numberCounterView.font = [UIFont boldSystemFontOfSize:19];
    numberCounterView.foregroundColor = [UIColor whiteColor];
    numberCounterView.fromValue = fromValue;
    numberCounterView.toValue = toValue;
    numberCounterView.oneMoreRotation = oneMoreRotation;
    numberCounterView.rollingDown = rollingDown;
    numberCounterView.duration = 1;
    
    return numberCounterView;
}

- (UIView *)makeCommaViewWithFrame:(CGRect)rect {
    UILabel *commaLabel = [[UILabel alloc] initWithFrame:rect];
    commaLabel.text = @",";
    commaLabel.font = [UIFont systemFontOfSize:22];
    commaLabel.textColor = UIColor.whiteColor;
    
    return commaLabel;
}

- (UIView *)makeUnitViewWithFrame:(CGRect)rect {
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:rect];
    unitLabel.text = @"개";
    unitLabel.font = [UIFont systemFontOfSize:20];
    unitLabel.textColor = UIColor.whiteColor;
    
    return unitLabel;
}

- (NSArray<NSNumber *> *)numberListWithNumber:(NSUInteger)number {
    NSMutableArray *numberList = [NSMutableArray new];
    
    NSUInteger temp = number;
    while (temp > 0) {
        NSUInteger digit = temp % 10;
        temp /= 10;
        [numberList addObject:@(digit)];
    }

    if (numberList.count < self.minDigit) {
        for (NSUInteger i = 0, len = self.minDigit - numberList.count; i < len; i++) {
            [numberList addObject:@(0)];
        }
    }
    
    return [[numberList reverseObjectEnumerator] allObjects];
}

- (void)startAnimationWithCompletion:(void (^)(BOOL finished))completion {
    for (UIView *subView in self.containerView.subviews) {
        if ([subView isKindOfClass:[CPNumberCounterView class]]) {
            [((CPNumberCounterView *)subView) startAnimation];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completion) {
            completion(YES);
        }
    });
}

@end
