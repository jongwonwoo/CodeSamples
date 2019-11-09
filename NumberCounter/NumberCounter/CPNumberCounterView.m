//
//  CPNumberCounterView.m
//  NumberCounter
//
//  Created by Jongwon Woo on 25/09/2019.
//  Copyright © 2019 jongwonwoo. All rights reserved.
//

#import "CPNumberCounterView.h"
#import <CoreText/CoreText.h>

@interface CPNumberCounterView ()

@property (nonatomic, weak) CATextLayer *placeholderLayer;
@property (nonatomic, weak) CAScrollLayer *scrollLayer;

@end


@implementation CPNumberCounterView

- (void)setFromValue:(NSUInteger)fromValue {
    _fromValue = MIN(fromValue, 9);
    
    [self makePlaceholderLayer];
}

- (void)setToValue:(NSUInteger)toValue {
    _toValue = MIN(toValue, 9);
    
    [self makePlaceholderLayer];
}

- (void)setRollingDown:(BOOL)rollingDown {
    _rollingDown = rollingDown;
    
    [self makePlaceholderLayer];
}

- (void)startAnimation {
    [self makeScrollLayer];
    [self createAnimation];
}

- (void)makePlaceholderLayer {
    [self.placeholderLayer removeFromSuperlayer];
    [self.scrollLayer removeFromSuperlayer];
    
    const CGFloat height = CGRectGetHeight(self.frame);
    const CGFloat width = CGRectGetWidth(self.frame);
    const CGFloat topPadding = [self topPadding];
    
    CATextLayer *textLayer = [self numberTextLayerWithFrame:CGRectMake(0, topPadding, width, height- (topPadding * 2)) numberText:[NSString stringWithFormat:@"%lu", self.fromValue]];
    self.placeholderLayer = textLayer;
    [self.layer addSublayer:textLayer];
}

- (CATextLayer *)numberTextLayerWithFrame:(CGRect)frame numberText:(NSString *)numberText {
    const CGFloat fontSize = [self fontSize];
    CTFontRef font = [self fontForText];
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = frame;
    textLayer.string = numberText;
    textLayer.font = font;
    textLayer.fontSize = fontSize;
    textLayer.foregroundColor = [self colorForText];
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.contentsScale = UIScreen.mainScreen.scale;
//        textLayer.backgroundColor = [numberText intValue] % 2 ? UIColor.redColor.CGColor : UIColor.greenColor.CGColor;
    
    return textLayer;
}

- (void)makeScrollLayer {
    [self.placeholderLayer removeFromSuperlayer];
    [self.scrollLayer removeFromSuperlayer];
    
    CAScrollLayer *layer = [CAScrollLayer layer];
    layer.frame = self.bounds;
    self.scrollLayer = layer;
    [self.layer addSublayer:layer];

    if (self.rollingDown) {
        [self makeNumberOnLayer:layer fromNumber:self.toValue toNumber:self.fromValue];
    } else {
        [self makeNumberOnLayer:layer fromNumber:self.fromValue toNumber:self.toValue];
    }
}

- (void)makeNumberOnLayer:(CAScrollLayer *)scrollLayer fromNumber:(NSUInteger)fromNumber toNumber:(NSUInteger)toNumber {
    CGFloat offsetY = 0;
    const CGFloat height = CGRectGetHeight(scrollLayer.frame);
    const CGFloat width = CGRectGetWidth(scrollLayer.frame);
    const CGFloat topPadding = [self topPadding];
    for (NSString *numberText in [self numbersFromNumber:fromNumber toNumber:toNumber]){
        CATextLayer *textLayer = [self numberTextLayerWithFrame:CGRectMake(0, offsetY + topPadding, width, height- (topPadding * 2)) numberText:numberText];
        [scrollLayer addSublayer:textLayer];
        offsetY += height;
    }
}

- (NSArray *)numbersFromNumber:(NSUInteger)fromNumber toNumber:(NSUInteger)toNumber {
    NSMutableArray *numbers = [NSMutableArray new];
    if (toNumber < fromNumber) {
        for (NSUInteger i = fromNumber; i <= 9; i++){
            [numbers addObject:[NSString stringWithFormat:@"%lu", i]];
        }
        
        if (self.oneMoreRotation) {
            for (NSUInteger i = 0; i <= 9; i++){
                [numbers addObject:[NSString stringWithFormat:@"%lu", i]];
            }
        }
        
        for (NSUInteger i = 0; i <= toNumber; i++){
            [numbers addObject:[NSString stringWithFormat:@"%lu", i]];
        }
    } else if (toNumber > fromNumber) {
        for (NSUInteger i = fromNumber; i <= toNumber; i++){
            [numbers addObject:[NSString stringWithFormat:@"%lu", i]];
        }
        
        if (self.oneMoreRotation) {
            for (NSUInteger i = toNumber + 1; i <= 9; i++){
                [numbers addObject:[NSString stringWithFormat:@"%lu", i]];
            }
            
            for (NSUInteger i = 0; i <= toNumber; i++){
                [numbers addObject:[NSString stringWithFormat:@"%lu", i]];
            }
        }
    } else {
        [numbers addObject:[NSString stringWithFormat:@"%lu", toNumber]];
        
        if (self.oneMoreRotation) {
            for (NSUInteger i = toNumber + 1; i <= 9; i++){
                [numbers addObject:[NSString stringWithFormat:@"%lu", i]];
            }
            
            for (NSUInteger i = 0; i <= toNumber; i++){
                [numbers addObject:[NSString stringWithFormat:@"%lu", i]];
            }
        }
    }
    
    return [numbers copy];
}

- (CGFloat)fontSize {
    return self.font ? self.font.pointSize : 19;
}

- (CTFontRef)fontForText {
    UIFont *font = self.font ?: [UIFont systemFontOfSize:[self fontSize]];
    CTFontRef ctFont = CTFontCreateWithFontDescriptor((__bridge CTFontDescriptorRef)font.fontDescriptor, font.pointSize, NULL);
    return ctFont;
}

- (CGFloat)topPadding {
    CGFloat fontSize = [self fontSize];
    CGFloat height = CGRectGetHeight(self.frame);
    return MAX(0, (height - fontSize) / 2);
}

- (CGColorRef)colorForText {
    return self.foregroundColor ? self.foregroundColor.CGColor : [UIColor blackColor].CGColor;
}

- (void)createAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.translation.y"];
    animation.duration = self.duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    if (self.rollingDown) {
        animation.fromValue = @(-(self.scrollLayer.sublayers.lastObject.frame.origin.y - [self topPadding]));
        animation.toValue = @0;
    } else {
        animation.fromValue = @0;
        animation.toValue = @(-(self.scrollLayer.sublayers.lastObject.frame.origin.y - [self topPadding]));
    }
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.scrollLayer addAnimation:animation forKey:@"NumberCounterView"];
}

@end
