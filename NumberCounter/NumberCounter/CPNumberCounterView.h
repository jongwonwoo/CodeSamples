//
//  CPNumberCounterView.h
//  NumberCounter
//
//  Created by Jongwon Woo on 25/09/2019.
//  Copyright © 2019 jongwonwoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CPNumberCounterView : UIView

@property (nonatomic) NSUInteger fromValue;
@property (nonatomic) NSUInteger toValue;
@property (nonatomic) BOOL rollingDown;
@property (nonatomic) BOOL oneMoreRotation;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *foregroundColor;

@property (nonatomic) CFTimeInterval duration;

- (void)startAnimation;

@end

NS_ASSUME_NONNULL_END
