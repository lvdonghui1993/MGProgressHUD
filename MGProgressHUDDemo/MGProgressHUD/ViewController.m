//
//  ViewController.m
//  MGProgressHUD
//
//  Created by donghui lv on 2018/3/28.
//  Copyright © 2018年 donghui lv. All rights reserved.
//

#import "ViewController.h"
#import "MGProgressHUD.h"
#import "MGCircleProgressView.h"
#import "HRSampleColorPickerViewController2.h"
@interface ViewController ()


@property(nonatomic, assign) CGFloat progressValue;

@property(nonatomic, strong) MGProgressHUD *hud;

@property(nonatomic, strong) NSTimer *progressTimer;

@property(nonatomic, strong) NSTimer *stautsTimer;


@property (weak, nonatomic) IBOutlet UIButton *selectHudForColorButton;

@property (weak, nonatomic) IBOutlet UIButton *selectHudBackColorButton;

@property (weak, nonatomic) IBOutlet UIButton *selectTextColorButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.selectHudForColorButton.backgroundColor = [UIColor blackColor];
    
    self.selectHudBackColorButton.backgroundColor =  [[UIColor alloc] initWithWhite:1.f alpha:.1f];;

    self.selectTextColorButton.backgroundColor = [UIColor blackColor];;

    
//    self.view.backgroundColor = [UIColor whiteColor];

    
    [MGProgressHUD setDefaultProgressHUDStyle:MGProgressHUDStyleCustom];
    [MGProgressHUD setDefaultProgressViewType:MGProgressViewTypeNative];
    [MGProgressHUD setDefaultHudBackgrouldColor:[UIColor clearColor]];
    [MGProgressHUD setDefaultStatusTextColor:[UIColor whiteColor]];
    [MGProgressHUD setDefaultHudForegroundColor:[UIColor whiteColor]];
    [MGProgressHUD setDefaultStatusTextFont:[UIFont systemFontOfSize:15]];

    [MGProgressHUD setDefaultMaskViewType:MGProgressHUDMaskViewTypeClear];

  
    [MGProgressHUD setDefaultImageSize:CGSizeMake(35, 35)];
    [MGProgressHUD setDefaultLayoutType:MGProgressHUDLayoutTypeProgressViewOrImageTopAndStatusLabelBottom];
//    [MGProgressHUD show]
    _hud=  [MGProgressHUD sharedView];
    _hud.containerView = self.view;
//    [MGProgressHUD setcon]
    
//
    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImageView]]
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [hud showSuccessWithStatus:@"成功"];
//    });
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)updateHudProgress {
    int x =  arc4random() % 20;
    CGFloat addProgress = x / 100.0;
    self.progressValue = self.progressValue + addProgress;
    if (self.progressValue > 1) {

        [_hud showSuccessWithStatus:@"OK"];
        [_hud dismissWithDelay:2];
        [self destoryTimer];
        
    }else {

        [_hud changeProgressValue:self.progressValue];
    }
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    NSLog(@"1231231");
}

- (IBAction)showProgress:(id)sender {
    
     [self destoryTimer];
    [[MGProgressHUD sharedView] showProgress];
    
    
   
}

- (IBAction)showProgressWithStatus:(id)sender {
     [self destoryTimer];
    [[MGProgressHUD sharedView] showProgressWithStatus:@"加载中.."];
    
    
}

- (IBAction)showProgressWithStatusStringByProgress:(id)sender {
     [self destoryTimer];
    
    self.progressValue = 0 ;
    
    [[MGProgressHUD sharedView] showProgressWithStatusStringByProgress:^NSString * _Nullable(CGFloat progressValue) {
        NSString *str = [NSString stringWithFormat:@"%d %@",(int)(progressValue * 100),@"%"];
        return str;
    }];
    _progressTimer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(updateHudProgress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_progressTimer forMode:NSRunLoopCommonModes];
    
    

}




- (IBAction)showCustomerProgressViewWithProgressStr:(id)sender {
     [self destoryTimer];
    self.progressValue = 0 ;
    
    [[MGProgressHUD sharedView] showCustomerProgressView:^UIView<MGBaseProgressViewProtocol> * _Nullable{
        return [MGCircleProgressView new];
    } withStatusStringByProgress:^NSString * _Nullable(CGFloat progressValue) {
        NSString *str = [NSString stringWithFormat:@"%d %@",(int)(progressValue * 100),@"%"];
        return str;
    }];
    
    _progressTimer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(updateHudProgress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_progressTimer forMode:NSRunLoopCommonModes];
}

- (IBAction)showImageWithStatus:(id)sender {
     [self destoryTimer];
     [[MGProgressHUD sharedView] showSuccessWithStatus:@"OK"];

}

- (IBAction)showRotationImageWithStatus:(id)sender {
     [self destoryTimer];
   [[MGProgressHUD sharedView] showRotationImage:[UIImage imageNamed:@"旋转"] withStatus:@"加载中"];
    
}




- (IBAction)showRotationImageWithProgressStatus:(id)sender {
     [self destoryTimer];
    self.progressValue = 0 ;
    
    [[MGProgressHUD sharedView] showRotationImage:[UIImage imageNamed:@"旋转"] withStatusStringByProgress:^NSString * _Nullable(CGFloat progressValue) {
        NSString *str = [NSString stringWithFormat:@"%d %@",(int)(progressValue * 100),@"%"];
        return str;
    }];
    _progressTimer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(updateHudProgress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_progressTimer forMode:NSRunLoopCommonModes];
}


- (IBAction)chanegStauts:(id)sender {
    [self destoryTimer];
    self.progressValue = 0 ;

    [[MGProgressHUD sharedView] showRotationImage:[UIImage imageNamed:@"旋转"] withStatus:@"17KB/s"];
    _progressTimer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(updateHudProgress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_progressTimer forMode:NSRunLoopCommonModes];
    
    _stautsTimer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(changeStatus) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_stautsTimer forMode:NSRunLoopCommonModes];
    
}
- (IBAction)changeProgressValue:(id)sender {
    [self destoryTimer];
    self.progressValue = 0 ;
    
    [[MGProgressHUD sharedView] showRotationImage:[UIImage imageNamed:@"旋转"] withStatusStringByProgress:^NSString * _Nullable(CGFloat progressValue) {
        NSString *str = [NSString stringWithFormat:@"%d %@",(int)(progressValue * 100),@"%"];
        return str;
    }];
    _progressTimer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(updateHudProgress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_progressTimer forMode:NSRunLoopCommonModes];
}

-(void)changeStatus{
    int x =  arc4random() % 1000;
    
    [[MGProgressHUD sharedView] changeStatusText:[NSString stringWithFormat:@"%d%@",x,@"KB/s"]];
}



- (IBAction)dismiss:(id)sender {
     [self destoryTimer];
    [[MGProgressHUD sharedView] dismiss];
}


- (IBAction)changeProgressType:(id)sender {
    UISegmentedControl *se = (UISegmentedControl*)sender;
    [MGProgressHUD setDefaultProgressViewType:se.selectedSegmentIndex];
}


- (IBAction)changeHudViewStyle:(id)sender {
    UISegmentedControl *se = (UISegmentedControl*)sender;
    [MGProgressHUD setDefaultProgressHUDStyle:se.selectedSegmentIndex];
}


- (IBAction)changeMaskViewType:(id)sender {
    UISegmentedControl *se = (UISegmentedControl*)sender;
    [MGProgressHUD setDefaultMaskViewType:se.selectedSegmentIndex];
}

- (IBAction)allowUserInteraction:(id)sender {
    UISwitch *sw = (UISwitch*)sender;
    [MGProgressHUD setDefalutAllowUserInteractions:sw.isOn];
}

- (IBAction)shouldTintImage:(id)sender {
    UISwitch *sw = (UISwitch*)sender;
    [MGProgressHUD setDefalutShouldTintImages:sw.isOn];
}


- (IBAction)changeLayoutType:(id)sender {
    UISegmentedControl *se = (UISegmentedControl*)sender;
    [MGProgressHUD setDefaultLayoutType:se.selectedSegmentIndex];

}

- (IBAction)selectHudForColor:(id)sender {
    UIButton *btn = (UIButton*)sender;
    HRSampleColorPickerViewController2 *vc = [HRSampleColorPickerViewController2 new];
    [vc setSelectColorCompletion:^(UIColor *color) {
        [MGProgressHUD setDefaultHudForegroundColor:color];
//        [_hud setHudForegroundColor:color];
        btn.backgroundColor = color;
        
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)selectHudBackColor:(id)sender {
    UIButton *btn = (UIButton*)sender;
    HRSampleColorPickerViewController2 *vc = [HRSampleColorPickerViewController2 new];
    [vc setSelectColorCompletion:^(UIColor *color) {
        [MGProgressHUD setDefaultHudBackgrouldColor:color];
        btn.backgroundColor = color;
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)selectStatusColor:(id)sender {
    UIButton *btn = (UIButton*)sender;
    HRSampleColorPickerViewController2 *vc = [HRSampleColorPickerViewController2 new];
    [vc setSelectColorCompletion:^(UIColor *color) {
        [MGProgressHUD setDefaultStatusTextColor:color];
         btn.backgroundColor = color;
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)destoryTimer {
    [self.progressTimer invalidate];
    self.progressTimer = nil;
    
    [self.stautsTimer invalidate];
   self.stautsTimer = nil;
    
   
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
