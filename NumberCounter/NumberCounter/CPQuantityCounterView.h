//
//  CPQuantityCounterView.h
//  NumberCounter
//
//  Created by Jongwon Woo on 07/10/2019.
//  Copyright © 2019 jongwonwoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CPQuantityCounterView : UIView

@property (nonatomic) NSUInteger fromValue;
@property (nonatomic) NSUInteger toValue;

@property (nonatomic) NSUInteger minDigit;
@property (nonatomic) NSUInteger maxDigit;

@property (nonatomic) CFTimeInterval duration;

- (void)startAnimationWithCompletion:(void (^)(BOOL finished))completion;

@end

NS_ASSUME_NONNULL_END
