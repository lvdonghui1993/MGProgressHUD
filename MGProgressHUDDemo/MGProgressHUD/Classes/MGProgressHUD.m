//
//  MGProgressHUD.m
//  MGProgressHUD
//
//  Created by donghui lv on 2018/3/28.
//  Copyright © 2018年 donghui lv. All rights reserved.
//

#import "MGProgressHUD.h"
#import <Masonry/Masonry.h>




@interface MGNativeProgressView : UIActivityIndicatorView <MGBaseProgressViewProtocol>


@end

@implementation MGNativeProgressView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    return self;
}


@end




static MGProgressHUDStyle DefaultProgressHUDStyle = 0;

static MGProgressViewType DefaultProgressViewType = 0;

static MGProgressHUDMaskViewType DefaultMaskViewType = 0;

static BOOL DefaultAllowUserInteractionsWithMaskView = YES;


static UIColor *DefaultMaskViewBackgrouldColor;

static UIColor *DefaultHudBackgrouldColor;

static UIColor *DefaultHudForegroundColor;

static BOOL DefaultShouldTintImages = YES;

static MGProgressHUDLayoutType DefaultLayoutType = 1;

static UIColor *DefaultStatusTextColor;

static UIFont *DefaultStatusTextFont;

static NSString *DefaultStatusTextString;

static UIImage *DefaultImage;

static UIImage *DefaultSuccessImage;

static UIImage *DefaultErrorImage;

static CGSize DefaultImageSize ;

@interface MGProgressHUDBGView: UIView

@end

@implementation MGProgressHUDBGView

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    NSLog(@"213");
}
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
       
            return nil;
    }
    return hitView;
}

@end

@interface MGProgressHUD()

@property(nonatomic, strong) UIView *progressViewOrImageView;

@property(nonatomic, strong) UIView<MGBaseProgressViewProtocol> *progressView;

@property(nonatomic, strong) UIImageView *imageView;

@property(nonatomic, strong) UILabel *statusLabel;

@property(nonatomic, strong) UIVisualEffectView *hudView;

@property(nonatomic, strong) UIView *backgroundView;


@property(nonatomic, strong) UIWindow *frontWindow;

@property(nonatomic, assign) BOOL isShowImage;

@property(nonatomic, assign) BOOL isShowStatusLabel;


@property(nonatomic, strong) NSTimer *dismissTimer;


@property(nonatomic, strong) NSTimer *rotationTimer;


@property(nonatomic, assign) CGFloat rotationValue;

@property(nonatomic, strong) UIView<MGBaseProgressViewProtocol> *customerProgressView;


/**
 根据进度值，生成的状态栏文本
 */
@property(nonatomic, copy, nullable) MGStatusTextStringByProgress textStringByProgress; //defalut nil





@end

@implementation MGProgressHUD


+ (instancetype)sharedView {
    static dispatch_once_t once;
    
    static MGProgressHUD *sharedView;
    dispatch_once(&once, ^{
        sharedView = [[MGProgressHUD alloc] init];
    });

    return sharedView;
}




- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.containerView = self.frontWindow;
        [self initUI];
    }
    return self;
}


#pragma mark + setter

+(void)setDefaultProgressViewType:(MGProgressViewType)defaultProgressViewType {
    DefaultProgressViewType = defaultProgressViewType;
    
}


+(void)setDefaultProgressHUDStyle:(MGProgressHUDStyle)defaultProgressHUDStyle {
    DefaultProgressHUDStyle = defaultProgressHUDStyle;
    
}

+(void)setDefaultMaskViewType:(MGProgressHUDMaskViewType)defaultMaskViewType {
    DefaultMaskViewType = defaultMaskViewType;
    
}

+(void)setDefalutAllowUserInteractions:(BOOL)defaultAllowUserInteractions {
    DefaultAllowUserInteractionsWithMaskView = defaultAllowUserInteractions;
    
}

+(void)setDefalutShouldTintImages:(BOOL)defaultShouldTintImages {
    DefaultShouldTintImages = defaultShouldTintImages;
    
}

+(void)setDefaultMaskViewBackgrouldColor:(UIColor *)defaultMaskViewBackgrouldColor {
    DefaultMaskViewBackgrouldColor = defaultMaskViewBackgrouldColor;
    
}

+(void)setDefaultHudBackgrouldColor:(UIColor *)defaultHudBackgrouldColor {
    DefaultHudBackgrouldColor = defaultHudBackgrouldColor;
    
}

+(void)setDefaultHudForegroundColor:(UIColor *)defaultHudForegroundColor {
    DefaultHudForegroundColor = defaultHudForegroundColor;
    
}


+(void)setDefaultLayoutType:(MGProgressHUDLayoutType)defaultLayoutType {
    DefaultLayoutType = defaultLayoutType;
    
}

+(void)setDefaultStatusTextColor:(UIColor *)defaultStatusTextColor {
    DefaultStatusTextColor = defaultStatusTextColor;
    
    
}

+(void)setDefaultStatusTextFont:(UIFont *)defaultStatusTextFont {
    DefaultStatusTextFont = defaultStatusTextFont;
}


+(void)setDefaultImageSize:(CGSize)defaultImageSize {
    DefaultImageSize = defaultImageSize;
}

+(void)setDefaultImage:(UIImage *)defaultImage {
    DefaultImage = defaultImage;
    
}

+(void)setDefaultSuccessImage:(UIImage *)defaultSuccessImage {
    DefaultSuccessImage = defaultSuccessImage;
}

+(void)setDefaultErrorImage:(UIImage *)defaultErrorImage {
    DefaultErrorImage = defaultErrorImage;
}

#pragma mark - changeValue

-(void)changeProgressValue:(CGFloat)progressValue {
    [self setProgressValue:progressValue];
}

-(void)changeStatusText:(NSString *)status {
    [self setStatusTextString:status];
}

#pragma mark - show and dismiss function

//
-(void)showProgress {
    
    [self setup];
    
    [self destoryTimer];
    self.isShowImage = NO;
    self.isShowStatusLabel = NO;
    
    [self setProgressViewType:MGProgressViewTypeNative];
    [self updateLayout];
    
    
    
    if (self.progressViewType == MGProgressViewTypeNative && !self.isShowImage) {
        [((MGNativeProgressView*)self.progressView) startAnimating];
    }
    
    [self addToContainerView];
    if (self.isShowImage) {
        [self updateImageViewWithImage:self.image];
    }
    
}


-(void)showProgressWithStatus:(NSString *)status {
    [self setup];
    
    [self destoryTimer];
    
    if (status.length > 0) {
        self.isShowStatusLabel = YES;
    }else {
        self.isShowStatusLabel = NO;
    }
    
    
    self.isShowImage = NO;
    [self setStatusTextString:status];
    
    [self setProgressViewType:MGProgressViewTypeNative];
    
    [self updateLayout];
    
    
    if (self.progressViewType == MGProgressViewTypeNative && !self.isShowImage) {
        [((MGNativeProgressView*)self.progressView) startAnimating];
    }
    
    [self addToContainerView];
    
    
}

-(void)showProgressWithStatusStringByProgress:(MGStatusTextStringByProgress)stringByProgress {
    
    [self setup];
    [self destoryTimer];
    
    self.isShowStatusLabel = YES;
    
    self.isShowImage = NO;
    [self setProgressViewType:MGProgressViewTypeNative];
    [self setTextStringByProgress:stringByProgress];
    [self updateLayout];
    
    if (self.progressViewType == MGProgressViewTypeNative && !self.isShowImage) {
        [((MGNativeProgressView*)self.progressView) startAnimating];
    }
    
    [self addToContainerView];
    
}

-(void)showImage: (UIImage*)image{
    [self showImage:image withStatus:nil];
}

-(void)showImage: (UIImage*)image withStatus:(NSString*)status{
    
    [self setup];
    [self destoryTimer];
    
    if (image) {
        self.isShowImage =YES;
    }else {
        self.isShowImage =NO;
    }
    
    if (status.length>0) {
        self.isShowStatusLabel = YES;
    }else {
        self.isShowStatusLabel = NO;
    }
    
    [self setStatusTextString:status];
    
    [self updateLayout];
    if (self.progressViewType == MGProgressViewTypeNative && !self.isShowImage) {
        [((MGNativeProgressView*)self.progressView) startAnimating];
    }
    
    [self addToContainerView];
    if (self.isShowImage) {
        [self updateImageViewWithImage:image];
    }
}

-(void)showImage: (UIImage*)image withStatusStringByProgress:(MGStatusTextStringByProgress)stringByProgress{
    
    [self setup];
    [self destoryTimer];
    
    if (image) {
        self.isShowImage =YES;
    }else {
        self.isShowImage =NO;
    }
    
    self.isShowStatusLabel = YES;
    
    
    [self setTextStringByProgress:stringByProgress];
    [self updateLayout];
    if (self.progressViewType == MGProgressViewTypeNative && !self.isShowImage) {
        [((MGNativeProgressView*)self.progressView) startAnimating];
    }
    
    [self addToContainerView];
    if (self.isShowImage) {
        [self updateImageViewWithImage:image];
    }
}



-(void)showRotationImage: (UIImage*)image{
    [self setup];
    [self showImage:image];
    if (self.isShowImage) {
        [self rotationImageView];
    }
    
}

-(void)showRotationImage: (UIImage*)image withStatus:(NSString*)status {
    [self setup];
    [self showImage:image withStatus:status];
    if (self.isShowImage) {
        [self rotationImageView];
    }
}

-(void)showRotationImage: (UIImage*)image withStatusStringByProgress:(MGStatusTextStringByProgress)stringByProgress {
    [self setup];
    [self showImage:image withStatusStringByProgress:stringByProgress];
    if (self.isShowImage) {
        [self rotationImageView];
    }
    
}



-(void)showCustomerProgressView:(MGCustomerProgressViewByProgress)customerProgressView WithStatus:(NSString *)status {
    [self setup];
    
    self.customerProgressView = customerProgressView();
    
    [self setProgressViewType:MGProgressViewTypeCustomerProgressView];
    
    self.isShowImage = NO;
    
    [self setStatusTextString:status];
    [self updateLayout];
    
    [self addToContainerView];
}

-(void)showCustomerProgressView:(MGCustomerProgressViewByProgress)customerProgressView withStatusStringByProgress:(MGStatusTextStringByProgress)stringByProgress {
    [self setup];
    self.customerProgressView = customerProgressView();
    
    [self setProgressViewType:MGProgressViewTypeCustomerProgressView];
    
    self.isShowImage = NO;
    
    [self setTextStringByProgress:stringByProgress];
    [self updateLayout];
    
    [self addToContainerView];
}
-(void)showSuccessWithStatus:(NSString *)status {
    
    [self showImage:self.successImage withStatus:status];
    
    
}

-(void)showErrorWithStatus:(NSString *)status {
    
    
    [self showImage:self.errorImage withStatus:status];
}

-(void)dismiss {
    
    [UIView animateWithDuration:0.15 animations:^{
        self.backgroundView.alpha = 0;
        self.hudView.alpha = 0;
        self.progressView.alpha = 0;
        self.imageView.alpha = 0;
        self.statusLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [self destoryTimer];
        [self removeFromSuperview];
    }];
    
    
    //    self=nil;
    
}

-(void)dismissWithCompletion:(MGProgressHUDDismissCompletion)completion {
    [self dismiss];
    completion();
}


-(void)dismissWithDelay:(NSTimeInterval)delay {
    self.dismissTimer = [NSTimer timerWithTimeInterval:delay target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.dismissTimer forMode:NSRunLoopCommonModes];
}

-(void)dismissWithDelay:(NSTimeInterval)delay completion:(MGProgressHUDDismissCompletion)completion {
    [self dismissWithDelay:delay ];
    completion();
}


#pragma mark - private api
- (void)setup {
   
    
    if (self.customerProgressView && self.customerProgressView.superview) {
        [self.customerProgressView removeFromSuperview];
        self.customerProgressView = nil;
    }
    if (self.progressView && self.progressView.superview) {
        
        if ([self.progressView isKindOfClass:[MGNativeProgressView class]]) {
            [((MGNativeProgressView*)self.progressView) stopAnimating];
        }
        [self.progressView removeFromSuperview];
        self.progressView = nil;
    }
    
    //setup defalutValue
    self.progressViewType = DefaultProgressViewType;
    
    self.maskViewType = DefaultMaskViewType;
    
    self.allowUserInteractionsWithMaskView = DefaultAllowUserInteractionsWithMaskView;
    
    self.progressHUDStyle = DefaultProgressHUDStyle;
    
    if (!DefaultMaskViewBackgrouldColor) {
        DefaultMaskViewBackgrouldColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    self.maskViewBackgrouldColor = DefaultMaskViewBackgrouldColor;
    
    if (!DefaultHudBackgrouldColor) {
        DefaultHudBackgrouldColor = [[UIColor alloc] initWithWhite:1.f alpha:.1f];
    }
    self.hudBackgrouldColor = DefaultHudBackgrouldColor;
    
    if (!DefaultHudForegroundColor) {
        DefaultHudForegroundColor = [UIColor blackColor];
    }
    _hudForegroundColor = DefaultHudForegroundColor;
    
    _shouldTintImage = DefaultShouldTintImages;
    
    _layoutType = DefaultLayoutType;
    
    if (!DefaultStatusTextColor) {
        DefaultStatusTextColor = [UIColor blackColor];
    }
       self.statusLabel.textColor = DefaultStatusTextColor;
    if (!DefaultStatusTextFont) {
        DefaultStatusTextFont = [UIFont systemFontOfSize:15];
    }
    
    self.statusLabel.font = DefaultStatusTextFont;
    
    if (!DefaultImage) {
        DefaultImage = [UIImage imageNamed:@"info"];
    }
    _image = DefaultImage;
    
    if (!DefaultSuccessImage) {
        DefaultSuccessImage = [UIImage imageNamed:@
                               "success"];
    }
    _successImage = DefaultSuccessImage;
    
    if (!DefaultErrorImage) {
        DefaultErrorImage = [UIImage imageNamed:@"error"];
    }
    _errorImage = DefaultErrorImage;
    
    
    if (DefaultImageSize.width == 0 && DefaultImageSize.height == 0) {
        DefaultImageSize = CGSizeMake(40, 40);
    }
    _imageSize = DefaultImageSize;
    

    
    
   
    
}


- (void)initUI {
    
    [self addSubview:self.backgroundView];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    
    [self addSubview:self.hudView];
    [self.hudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
//      make.size.mas_equalTo()
    }];
    
    self.progressViewOrImageView = [UIView new];
    
    [self.hudView.contentView addSubview:self.progressViewOrImageView];
    
    [self.hudView.contentView addSubview:self.statusLabel];
    
}

#pragma mark - -setter
- (void)setAllowUserInteractionsWithMaskView:(BOOL)allowUserInteractionsWithMaskView {
    _allowUserInteractionsWithMaskView = allowUserInteractionsWithMaskView;
    if (_backgroundView) {
         _backgroundView.userInteractionEnabled = allowUserInteractionsWithMaskView;
    }
   
}

- (void)setMaskViewBackgrouldColor:(UIColor *)maskViewBackgrouldColor {
    _maskViewBackgrouldColor = maskViewBackgrouldColor;
    if (self.maskViewType == MGProgressHUDMaskViewTypeCustom && _backgroundView) {
        _backgroundView.backgroundColor = maskViewBackgrouldColor;
    }
}

-(void)setProgressHUDStyle:(MGProgressHUDStyle)progressHUDStyle {
    if (_progressHUDStyle != progressHUDStyle) {
        _progressHUDStyle = progressHUDStyle;
        if (_hudView) {
            if (self.progressHUDStyle == MGProgressHUDStyleDefault) {
                // Add blur effect
                UIBlurEffectStyle blurEffectStyle = UIBlurEffectStyleLight;
                UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:blurEffectStyle];
                self.hudView.effect = blurEffect;
                self.hudView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6f];
            }else {
                self.hudView.effect = nil;
                self.hudView.backgroundColor = self.hudBackgrouldColor;
            }
        }
    }
}



-(void)setHudForegroundColor:(UIColor *)hudForegroundColor {
    _hudForegroundColor = hudForegroundColor;

}



-(void)setHudBackgrouldColor:(UIColor *)hudBackgrouldColor {
    _hudBackgrouldColor = hudBackgrouldColor;
    if (self.progressHUDStyle == 1 && _hudView) {
        if (self.progressHUDStyle == MGProgressHUDStyleCustom) {
           
        }
            _hudView.backgroundColor = _hudBackgrouldColor;

    }
}

-(void)setMaskViewType:(MGProgressHUDMaskViewType)maskViewType {
    _maskViewType = maskViewType;
    if (_backgroundView) {
        if (_maskViewType == 0) {
            _backgroundView.backgroundColor = [UIColor clearColor];
        }else if(_maskViewType == 1){
            _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        }else {
            _backgroundView.backgroundColor = self.maskViewBackgrouldColor;
        }
        
        
        
    }
}



-(void)setProgressViewType:(MGProgressViewType)progressViewType {
    if (_progressViewType != progressViewType) {
        _progressViewType = progressViewType;
        if (_progressView) {
            if (_progressViewType == MGProgressViewTypeNative) {
                _progressView = [MGNativeProgressView new];
            }else if(_progressViewType ==  MGProgressViewTypeCustomerProgressView){
                if (self.customerProgressView) {
                    _progressView = self.customerProgressView;
                }else {
                    _progressView = [MGNativeProgressView new];
                }
                
            }
        }

    }
}

-(void)setStatusTextFont:(UIFont *)statusTextFont {
    _statusTextFont = statusTextFont;
    if (_statusLabel) {
        _statusLabel.font = statusTextFont;
    }
}

-(void)setStatusTextColor:(UIColor *)statusTextColor {
    _statusTextColor = statusTextColor;
    if (_statusLabel) {
        
        if (self.progressHUDStyle == 1) {
            _statusTextColor = statusTextColor;
        }
        
        
    }
}

-(void)setTextStringByProgress:(MGStatusTextStringByProgress)textStringByProgress {
    _textStringByProgress = textStringByProgress;
    _statusTextString = nil;
    if (_statusLabel) {
        _statusLabel.text =self.textStringByProgress(self.progressValue);
    }
}

-(void)setStatusTextString:(NSString *)statusTextString {
    _statusTextString = statusTextString;
    _textStringByProgress = nil;
    if (_statusLabel) {
        _statusLabel.text = statusTextString;
    }
}



-(void)setProgressValue:(CGFloat)progressValue {
    _progressValue = progressValue;
    if (_textStringByProgress && _statusLabel) {
        _statusLabel.text = self.textStringByProgress(_progressValue);
    }
    if ([self.progressView respondsToSelector:@selector(updateProgressContentViewWithProgressValue:)]) {
        [self.progressView updateProgressContentViewWithProgressValue:self.progressValue];
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    NSLog(@"213");
}
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        if (self.allowUserInteractionsWithMaskView) {
            return nil;
        }else {
            return hitView;
        }
    }
    return hitView;
}


//-(void)setProgressValue:(CGFloat)progressValue {
//    _progressValue = progressValue;
//    if (self.textStringByProgress && _statusLabel) {
//        _statusLabel.text = self.textStringByProgress(progressValue);
//    }
//}


- (void)setDismissTimer:(NSTimer *)dismissTimer{
    if(_dismissTimer) {
        [_dismissTimer invalidate];
        _dismissTimer = nil;
    }
    if(dismissTimer) {
        _dismissTimer = dismissTimer;
    }
}

- (void)setRotationTimer:(NSTimer *)rotationTimer{
    if(_rotationTimer) {
        [_rotationTimer invalidate];
        _rotationTimer = nil;
    }
    if(rotationTimer) {
        _rotationTimer = rotationTimer;
    }
}



- (void)updateImageViewWithImage:(UIImage*)image {
    
    
    
    if (self.shouldTintImage) {
        if (image.renderingMode != UIImageRenderingModeAlwaysTemplate) {
            self.imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        self.imageView.tintColor = self.hudForegroundColor;
    }else {
        self.imageView.image = image;
    }
    [self.imageView.layer removeAllAnimations];
    
//    if (self.progressViewType == MGProgressViewTypeCustomerRotationImageVIew) {
//        
//        [self rotationImageView];
//    }
    
}

- (void)rotationImageView {
    CABasicAnimation *rotationAnimation;
    
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    
    rotationAnimation.duration = 1;
    
    rotationAnimation.repeatCount = HUGE_VALF;
    
    [self.imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}


-(void)rotaionToZero

{
    self.imageView.transform=CGAffineTransformMakeRotation(0);
}

- (void)updateLayout {
    CGFloat progressViewOrImageWidth;
    CGFloat progressViewOrImageHeight;
    if (self.isShowImage) {
        self.imageView.hidden = NO;
        self.progressView.hidden = YES;
     
        progressViewOrImageWidth = (self.imageSize.width != 0) ? self.imageSize.width : 40;
        progressViewOrImageHeight = (self.imageSize.height != 0) ? self.imageSize.height : 40;
    }else {
        self.imageView.hidden = YES;
        self.progressView.hidden = NO;
        progressViewOrImageWidth =  40;
        progressViewOrImageHeight =  40;
    }
    
    
    switch (self.layoutType) {
        case MGProgressHUDLayoutTypeProgressViewOrImageTopAndStatusLabelBottom:
        {
            
            [self.progressViewOrImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(progressViewOrImageWidth, progressViewOrImageHeight));
                make.top.equalTo(self.hudView.contentView).offset(15);
                make.centerX.equalTo(self.hudView.contentView);
            }];
            
            
            [self.progressViewOrImageView addSubview:self.imageView];
            [self.progressViewOrImageView addSubview:self.progressView];
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.progressViewOrImageView);
            }];
            
            [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.progressViewOrImageView);
            }];
            

            if (self.isShowStatusLabel) {
                [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.hudView.contentView);
                    make.top.equalTo(self.progressViewOrImageView.mas_bottom).offset(8);
                    make.width.greaterThanOrEqualTo(self.progressViewOrImageView);
                    make.left.equalTo(self.hudView.contentView).offset(20);
                    make.right.equalTo(self.hudView.contentView).offset(-20);
                    make.bottom.equalTo(self.hudView.contentView).offset(-20);
                }];
            }else {
                [self.progressViewOrImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.hudView.contentView).offset(20);
                    make.right.equalTo(self.hudView.contentView).offset(-20);
                    make.bottom.equalTo(self.hudView.contentView).offset(-20);
                }];
            }
            
          
            
            
        }
            break;
        case MGProgressHUDLayoutTypeProgressViewOrImageLeftAndStatusLabelRight:
        {
            [self.progressViewOrImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(progressViewOrImageWidth, progressViewOrImageHeight));
                make.left.equalTo(self.hudView.contentView).offset(20);
                make.centerY.equalTo(self.hudView.contentView);
            }];
            [self.progressViewOrImageView addSubview:self.imageView];
            [self.progressViewOrImageView addSubview:self.progressView];
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.progressViewOrImageView);
            }];
            
            [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.progressViewOrImageView);
            }];
            
            
            if (self.isShowStatusLabel) {
                [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.hudView.contentView);
                    make.left.equalTo(self.progressViewOrImageView.mas_right).offset(8);
                    make.height.greaterThanOrEqualTo(self.progressViewOrImageView);
                    make.width.mas_lessThanOrEqualTo(150);
                    make.top.equalTo(self.hudView.contentView).offset(20);
                    make.bottom.equalTo(self.hudView.contentView).offset(-20);
                    make.right.equalTo(self.hudView.contentView).offset(-20);
                }];
            }else {
                [self.progressViewOrImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.hudView.contentView).offset(20);
                    make.bottom.equalTo(self.hudView.contentView).offset(-20);
                    make.right.equalTo(self.hudView.contentView).offset(-20);
                }];
            }
            
            
        }
            break;
            
        default:
            break;
    }
}



#pragma mark - getter
- (UIWindow *)frontWindow {

    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= UIWindowLevelNormal);
        BOOL windowKeyWindow = window.isKeyWindow;
        
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported && windowKeyWindow) {
            return window;
        }
    }
    return nil;
}

-(UIView<MGBaseProgressViewProtocol> *)progressView {
    
    if (_progressView) {
        return _progressView;
    }
    if (self.progressViewType == MGProgressViewTypeNative) {
        _progressView = [MGNativeProgressView new];
        return _progressView;
    }else if (self.progressViewType == MGProgressViewTypeCustomerProgressView){
        if (self.customerProgressView) {
            _progressView = self.customerProgressView;
        }else {
            _progressView = [MGNativeProgressView new];
        }
        return _progressView;

    }else {
        _progressView = [MGNativeProgressView new];
        return _progressView;
    }
}


-(UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    _imageView = [UIImageView new];
   
    return _imageView;
}

-(UILabel *)statusLabel {
    if (_statusLabel) {
        return _statusLabel;
    }

    _statusLabel = [[UILabel alloc] init];
    if (self.progressHUDStyle == 0) {
        _statusLabel.textColor = [UIColor blackColor];
    }else {
        if (self.statusTextColor) {
            _statusLabel.textColor = self.statusTextColor;
        }else {
            _statusLabel.textColor = self.hudForegroundColor;
        }
    }
    _statusLabel.font = self.statusTextFont;
    if (_textStringByProgress) {
        _statusLabel.text = self.textStringByProgress(self.progressValue);
    }else {
        _statusLabel.text = self.statusTextString;
    }
    return _statusLabel;
}

-(UIView *)backgroundView {
    if (_backgroundView) {
        return _backgroundView;
    }
    _backgroundView = [[MGProgressHUDBGView alloc]init];
    if(self.maskViewType == MGProgressHUDMaskViewTypeBlack){
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    } else if(self.maskViewType == MGProgressHUDMaskViewTypeCustom){
        _backgroundView.backgroundColor = self.maskViewBackgrouldColor;
    } else {
        _backgroundView.backgroundColor = [UIColor clearColor];
    }
    _backgroundView.userInteractionEnabled = self.allowUserInteractionsWithMaskView;
    return _backgroundView;
}

-(UIVisualEffectView *)hudView {
    if (_hudView) {
        return _hudView;
    }
    _hudView = [UIVisualEffectView new];
    _hudView.layer.masksToBounds = YES;
    _hudView.layer.cornerRadius = 12;
    if (self.progressHUDStyle == MGProgressHUDStyleDefault) {
        // Add blur effect
        UIBlurEffectStyle blurEffectStyle = UIBlurEffectStyleLight;
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:blurEffectStyle];
        self.hudView.effect = blurEffect;
        // We omit UIVibrancy effect and use a suitable background color as an alternative.
        // This will make everything more readable. See the following for details:
        // https://www.omnigroup.com/developer/how-to-make-text-in-a-uivisualeffectview-readable-on-any-background
        self.hudView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6f];
    }else {
        self.hudView.effect = nil;
        self.hudView.backgroundColor = self.hudBackgrouldColor;
    }
    return _hudView;
}


- (void)addToContainerView{
    if (!self.superview) {
        [self.containerView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.containerView);
        }];
    }
    
    self.backgroundView.alpha = 0;
    self.hudView.alpha = 0;
    self.progressView.alpha = 0;
    self.imageView.alpha = 0;
    self.statusLabel.alpha = 0;
    
    [UIView animateWithDuration:0.15 animations:^{
        self.backgroundView.alpha = 1;
        self.hudView.alpha = 1;
        self.progressView.alpha = 1;
        self.imageView.alpha = 1;
        self.statusLabel.alpha = 1;
        
    }];
}

-(void)destoryTimer {
    [self.dismissTimer invalidate];
    self.dismissTimer = nil;
    
    [self.rotationTimer invalidate];
    self.rotationTimer = nil;
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
