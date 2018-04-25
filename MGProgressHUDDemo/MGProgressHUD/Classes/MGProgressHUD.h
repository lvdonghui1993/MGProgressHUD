//
//  MGProgressHUD.h
//  MGProgressHUD
//
//  Created by donghui lv on 2018/3/28.
//  Copyright © 2018年 donghui lv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGBaseProgressViewProtocol.h"

@interface MGProgressHUD : UIView

typedef NS_ENUM(NSInteger, MGProgressHUDStyle) {
    MGProgressHUDStyleDefault,       // default style, white HUD with black text, HUD background will be blurred
    MGProgressHUDStyleCustom        // uses the hudfore- and hudbackground color properties 
};

typedef NS_ENUM(NSInteger, MGProgressViewType) {
    MGProgressViewTypeNative,                       // iOS native UIActivityIndicatorView
    MGProgressViewTypeCustomerProgressView          //customer ProgressView<MGBaseProgressViewProtocol>
};

typedef NS_ENUM(NSUInteger, MGProgressHUDMaskViewType) {
    MGProgressHUDMaskViewTypeClear,     //  透明色 clearColor
    MGProgressHUDMaskViewTypeBlack,     // [UIColor colorWithWhite:0 alpha:0.4]
    MGProgressHUDMaskViewTypeCustom     //  custom color
};

typedef NS_ENUM(NSInteger, MGProgressHUDLayoutType) {
    MGProgressHUDLayoutTypeProgressViewOrImageTopAndStatusLabelBottom,       // 进度视图或者图片上，状态文本下
    MGProgressHUDLayoutTypeProgressViewOrImageLeftAndStatusLabelRight        // 进度视图或者图片左，状态文本右
};

typedef NSString* _Nullable (^MGStatusTextStringByProgress)(CGFloat progressValue);

typedef NSString* _Nullable (^MGProgressHUDDismissCompletion)(void);

typedef UIView<MGBaseProgressViewProtocol>* _Nullable (^MGCustomerProgressViewByProgress)(void);



#pragma mark - readonly interal property
/**
 HUD风格
 */
@property(nonatomic, assign,readonly) MGProgressHUDStyle progressHUDStyle;

/**
 进度值
 */
@property(nonatomic, assign,readonly) CGFloat progressValue; //default is 0

@property(nonatomic, assign, readonly) MGProgressViewType  progressViewType; //default MGProgressViewTypeNative

@property(nonatomic, assign,readonly) MGProgressHUDMaskViewType  maskViewType; //defalut MGProgressHUDMaskViewTypeClear

/**
 maskView 是否允许用户交互
 */
@property(nonatomic, assign,readonly) BOOL allowUserInteractionsWithMaskView; //default yes



/**
 maskView背景色
 */
@property(nonatomic, strong, nonnull,readonly) UIColor *maskViewBackgrouldColor; //default is colorWithWhite:0 alpha:0.4] 当 maskViewType 为 MGProgressHUDMaskViewTypeCustom，才生效

/**
 hudView背景色
 */
@property(nonatomic, strong, nonnull,readonly) UIColor *hudBackgrouldColor;  //default is [[UIColor alloc] initWithWhite:1.f alpha:.1f] 需配合HudType == MGProgressHUDStyleCustom

/**
 hudView前景色
 */
@property(nonatomic, strong, nonnull,readonly) UIColor *hudForegroundColor;// default is  [UIColor blackColor] 需配合HudType == MGProgressHUDStyleCustom

/**
 图片颜色是否采用hudView前景色
 */
@property(nonatomic, assign,readonly) BOOL shouldTintImage; //default YES

/**
 布局方式
 */
@property(nonatomic, assign,readonly) MGProgressHUDLayoutType layoutType;


/**
 状态文本颜色
 */
@property(nonatomic, strong, nonnull,readonly) UIColor *statusTextColor; // defalut is  hudForegroundColor


/**
 状态文本字体
 */
@property(nonatomic, strong, nonnull,readonly) UIFont  *statusTextFont; //defalut  system 15



/**
 状态栏文本
 */
@property(nonatomic, copy,nonnull,readonly) NSString *statusTextString; //defalut nil




@property(nonatomic, strong, nonnull,readonly) UIImage *image; //defalut  is [uiimage imagenamed:@"info"]



@property(nonatomic, strong, nonnull,readonly) UIImage *successImage; //defalut  is [uiimage imagenamed:@"success"]



@property(nonatomic, strong, nonnull,readonly) UIImage *errorImage; //defalut  is [uiimage imagenamed:@"error"]


@property(nonatomic, assign,readonly) CGSize imageSize;

#pragma mark - init function
+ (instancetype)sharedView;

- (MGProgressHUD*)init;

#pragma mark - public property
/**
 父容器视图
 */
@property(nonatomic, strong, nullable) UIView * containerView; //default is default window level


#pragma mark - default setter


+ (void) setDefaultProgressHUDStyle:(MGProgressHUDStyle)defaultProgressHUDStyle;


+ (void) setDefaultProgressViewType:(MGProgressViewType)defaultProgressViewType;

+ (void) setDefaultMaskViewType:(MGProgressHUDMaskViewType)defaultMaskViewType;

+ (void) setDefalutAllowUserInteractions:(BOOL)defaultAllowUserInteractions;

+ (void) setDefalutShouldTintImages:(BOOL)defaultShouldTintImages;



+ (void) setDefaultMaskViewBackgrouldColor:(nonnull UIColor*)defaultMaskViewBackgrouldColor;


+ (void) setDefaultHudBackgrouldColor:(nonnull UIColor*)defaultHudBackgrouldColor;

+ (void) setDefaultHudForegroundColor:(nonnull UIColor*)defaultHudForegroundColor;

+ (void) setDefaultLayoutType:(MGProgressHUDLayoutType)defaultLayoutType;

+ (void) setDefaultStatusTextColor:(nonnull UIColor*)defaultStatusTextColor;

+ (void) setDefaultStatusTextFont:(nonnull UIFont*)defaultStatusTextFont;

+ (void) setDefaultImageSize: (CGSize)defaultImageSize;

+ (void) setDefaultImage:(nonnull UIImage* )defaultImage;

+ (void) setDefaultSuccessImage:(nonnull UIImage*)defaultSuccessImage;

+ (void) setDefaultErrorImage:(nonnull UIImage*)defaultErrorImage;


#pragma mark - show and dismiss function

-(void)showProgress ;
-(void)showProgressWithStatus:(nullable NSString *)status ;
-(void)showProgressWithStatusStringByProgress:(nonnull MGStatusTextStringByProgress)stringByProgress ;

-(void)showCustomerProgressView:(nonnull MGCustomerProgressViewByProgress)customerProgressView WithStatus:(nullable NSString *)status;
-(void)showCustomerProgressView:(nonnull MGCustomerProgressViewByProgress)customerProgressView withStatusStringByProgress:(nonnull MGStatusTextStringByProgress)stringByProgress;



-(void)showImage: (nullable UIImage*)image;
-(void)showImage: (nullable UIImage*)image withStatus:(nullable NSString*)status;
-(void)showImage: (nullable UIImage*)image withStatusStringByProgress:(nonnull MGStatusTextStringByProgress)stringByProgress;
-(void)showSuccessWithStatus:(nullable NSString *)status ;
-(void)showErrorWithStatus:(nullable NSString *)status ;


-(void)showRotationImage: (nullable UIImage*)image;
-(void)showRotationImage: (nullable UIImage*)image withStatus:(nullable NSString*)status;
-(void)showRotationImage: (nullable UIImage*)image withStatusStringByProgress:(nonnull MGStatusTextStringByProgress)stringByProgress;




- (void)dismiss;
- (void)dismissWithCompletion:(nullable MGProgressHUDDismissCompletion)completion;
- (void)dismissWithDelay:(NSTimeInterval)delay;
- (void)dismissWithDelay:(NSTimeInterval)delay completion:(nullable MGProgressHUDDismissCompletion)completion;

#pragma mark - change Value

- (void)changeStatusText:(nullable NSString*)status;

- (void)changeProgressValue:(CGFloat)progressValue;





@end
