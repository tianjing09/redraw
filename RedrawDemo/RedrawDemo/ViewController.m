//
//  ViewController.m
//  RedrawDemo
//
//  Created by tianjing on 15/4/1.
//  Copyright © 2015年 tianjing. All rights reserved.
//

#import "ViewController.h"
#import "RedrawView.h"

@interface ViewController ()
@property (nonatomic, strong) RedrawView *redrawView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.redrawView = [[RedrawView alloc]initWithFrame:CGRectMake(20, 30, 300, 300)];
    self.redrawView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.redrawView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 400, 100, 30);
    button.backgroundColor = [UIColor greenColor];
    [button setTitle:@"redraw" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(redraw) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)redraw {
    [self.redrawView repeat];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
