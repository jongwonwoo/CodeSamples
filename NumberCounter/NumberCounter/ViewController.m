//
//  ViewController.m
//  NumberCounter
//
//  Created by Jongwon Woo on 25/09/2019.
//  Copyright © 2019 jongwonwoo. All rights reserved.
//

#import "ViewController.h"
#import "CPNumberCounterView.h"
#import "CPQuantityCounterView.h"

@interface ViewController ()

@property (nonatomic, weak) CPNumberCounterView *numberCounterView1;
@property (nonatomic, weak) CPNumberCounterView *numberCounterView2;
@property (nonatomic, weak) CPNumberCounterView *numberCounterView3;
@property (nonatomic, weak) CPNumberCounterView *numberCounterView4;

@property (nonatomic, weak) CPQuantityCounterView *qtyView;
@property (nonatomic, weak) CPQuantityCounterView *qtyView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    CPNumberCounterView *numberCounterView1 = [[CPNumberCounterView alloc] initWithFrame:CGRectMake(100, 100, 30, 30)];
    numberCounterView1.backgroundColor = [UIColor blackColor];
    numberCounterView1.layer.cornerRadius = 10;
    numberCounterView1.layer.borderColor = [UIColor yellowColor].CGColor;
    numberCounterView1.layer.borderWidth = 1;
    numberCounterView1.font = [UIFont boldSystemFontOfSize:21];
    numberCounterView1.foregroundColor = [UIColor whiteColor];
    numberCounterView1.fromValue = 1;
    numberCounterView1.toValue = 1;
    numberCounterView1.duration = 1;
    self.numberCounterView1 = numberCounterView1;
    [self.view addSubview:numberCounterView1];
    
    CPNumberCounterView *numberCounterView2 = [[CPNumberCounterView alloc] initWithFrame:CGRectMake(132, 100, 30, 30)];
    numberCounterView2.backgroundColor = [UIColor orangeColor];
    numberCounterView2.fromValue = 9;
    numberCounterView2.toValue = 9;
    numberCounterView2.oneMoreRotation = YES;
    numberCounterView2.duration = 2;
    self.numberCounterView2 = numberCounterView2;
    [self.view addSubview:numberCounterView2];
    
    CPNumberCounterView *numberCounterView3 = [[CPNumberCounterView alloc] initWithFrame:CGRectMake(164, 100, 30, 30)];
    numberCounterView3.backgroundColor = [UIColor orangeColor];
    numberCounterView3.foregroundColor = [UIColor whiteColor];
    numberCounterView3.fromValue = 50;
    numberCounterView3.toValue = 5;
    numberCounterView3.rollingDown = YES;
    numberCounterView3.duration = 3;
    self.numberCounterView3 = numberCounterView3;
    [self.view addSubview:numberCounterView3];
    
    CPNumberCounterView *numberCounterView4 = [[CPNumberCounterView alloc] initWithFrame:CGRectMake(196, 100, 30, 30)];
    numberCounterView4.backgroundColor = [UIColor orangeColor];
    numberCounterView4.toValue = 2;
    numberCounterView4.oneMoreRotation = YES;
    numberCounterView4.duration = 2;
    self.numberCounterView4 = numberCounterView4;
    [self.view addSubview:numberCounterView4];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"start" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didTouchStartButton:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 200, 100, 30);
    [self.view addSubview:button];
    
    UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [resetButton setTitle:@"reset" forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(didTouchResetButton:) forControlEvents:UIControlEventTouchUpInside];
    resetButton.frame = CGRectMake(100, 250, 100, 30);
    [self.view addSubview:resetButton];
    
    CPQuantityCounterView *qtyView = [[CPQuantityCounterView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(resetButton.frame) + 20, self.view.frame.size.width, 35)];
    qtyView.backgroundColor = UIColor.redColor;
    qtyView.minDigit = 6;
    qtyView.maxDigit = 9;
    qtyView.fromValue = 920322;
    qtyView.duration = 1;
    self.qtyView = qtyView;
    [self.view addSubview:qtyView];
    
    UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [plusButton setTitle:@"+470" forState:UIControlStateNormal];
    [plusButton addTarget:self action:@selector(didTouchPlusButton:) forControlEvents:UIControlEventTouchUpInside];
    plusButton.frame = CGRectMake(100, CGRectGetMaxY(qtyView.frame) + 20, 100, 30);
    [self.view addSubview:plusButton];
    
    UIButton *minusButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [minusButton setTitle:@"-470" forState:UIControlStateNormal];
    [minusButton addTarget:self action:@selector(didTouchMinusButton:) forControlEvents:UIControlEventTouchUpInside];
    minusButton.frame = CGRectMake(200, CGRectGetMaxY(qtyView.frame) + 20, 100, 30);
    [self.view addSubview:minusButton];
    
    CPQuantityCounterView *qtyView2 = [[CPQuantityCounterView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(plusButton.frame) + 20, self.view.frame.size.width, 35)];
    qtyView2.backgroundColor = UIColor.redColor;
    qtyView2.minDigit = 8;
    qtyView2.maxDigit = 9;
    qtyView2.fromValue = 99876543;
    qtyView2.duration = 1;
    self.qtyView2 = qtyView2;
    [self.view addSubview:qtyView2];
    
    UIButton *plusButton1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [plusButton1 setTitle:@"+1M" forState:UIControlStateNormal];
    [plusButton1 addTarget:self action:@selector(didTouchPlusButton2:) forControlEvents:UIControlEventTouchUpInside];
    plusButton1.frame = CGRectMake(100, CGRectGetMaxY(qtyView2.frame) + 20, 100, 30);
    [self.view addSubview:plusButton1];
    
    UIButton *minusButton1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [minusButton1 setTitle:@"-1M" forState:UIControlStateNormal];
    [minusButton1 addTarget:self action:@selector(didTouchMinusButton2:) forControlEvents:UIControlEventTouchUpInside];
    minusButton1.frame = CGRectMake(200, CGRectGetMaxY(qtyView2.frame) + 20, 100, 30);
    [self.view addSubview:minusButton1];
    
    UIButton *resetButton2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [resetButton2 setTitle:@"reset" forState:UIControlStateNormal];
    [resetButton2 addTarget:self action:@selector(didTouchResetButton2:) forControlEvents:UIControlEventTouchUpInside];
    resetButton2.frame = CGRectMake(100, CGRectGetMaxY(plusButton1.frame) + 100, 100, 30);
    [self.view addSubview:resetButton2];
}

- (void)didTouchStartButton:(UIButton *)sender {
    [self.numberCounterView1 startAnimation];
    [self.numberCounterView2 startAnimation];
    [self.numberCounterView3 startAnimation];
    [self.numberCounterView4 startAnimation];
}

- (void)didTouchResetButton:(UIButton *)sender {
    self.numberCounterView1.fromValue = 3;
    self.numberCounterView2.fromValue = 5;
    self.numberCounterView3.fromValue = 9;
    self.numberCounterView4.fromValue = 9;
}

- (void)didTouchPlusButton:(UIButton *)sender {
    self.qtyView.toValue = self.qtyView.fromValue + 470;
    [self.qtyView startAnimationWithCompletion:^(BOOL finished) {
        if (finished) {
            self.qtyView.fromValue = self.qtyView.toValue;            
        }
    }];
}

- (void)didTouchMinusButton:(UIButton *)sender {
    self.qtyView.toValue = self.qtyView.fromValue - 470;
    [self.qtyView startAnimationWithCompletion:^(BOOL finished) {
        if (finished) {
            self.qtyView.fromValue = self.qtyView.toValue;
        }
    }];
}


- (void)didTouchPlusButton2:(UIButton *)sender {
    self.qtyView2.toValue = self.qtyView2.fromValue + 1000123;
    [self.qtyView2 startAnimationWithCompletion:^(BOOL finished) {
        if (finished) {
            self.qtyView2.fromValue = self.qtyView2.toValue;
        }
    }];
}

- (void)didTouchMinusButton2:(UIButton *)sender {
    self.qtyView2.toValue = self.qtyView2.fromValue - 1000123;
    [self.qtyView2 startAnimationWithCompletion:^(BOOL finished) {
        if (finished) {
            self.qtyView2.fromValue = self.qtyView2.toValue;
        }
    }];
}

- (void)didTouchResetButton2:(UIButton *)sender {
    self.qtyView2.fromValue = 99876543;
    self.qtyView2.toValue = 0;
}

@end
