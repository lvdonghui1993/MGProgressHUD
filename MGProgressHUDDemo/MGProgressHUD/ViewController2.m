//
//  ViewController2.m
//  MGProgressHUD
//
//  Created by donghui lv on 2018/3/29.
//  Copyright © 2018年 donghui lv. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()



@end

@implementation ViewController2
- (void)asdasd{
    NSLog(@"2sdasdsad");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
    b.frame = CGRectMake(100, 100, 200, 200);
    [b setTitle:@"123" forState:UIControlStateNormal];
    [self.view addSubview:b];
    [b addTarget:self action:@selector(asdasd) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *s = [UIView new];
    s.frame = self.view.bounds;
    s.userInteractionEnabled = YES;
    [self.view addSubview:s];
    // Do any additional setup after loading the view.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    NSLog(@"213");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
