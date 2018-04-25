//
//  MGCircleProgressView.m
//  MGProgressHUD
//
//  Created by donghui lv on 2018/3/29.
//  Copyright © 2018年 donghui lv. All rights reserved.
//

#import "MGCircleProgressView.h"

#import <Masonry/Masonry.h>


@interface CircleLayer :CALayer


@property(nonatomic, assign) CGFloat pertent;

@end

@implementation CircleLayer


- (instancetype)initWithLayer:(CircleLayer *)layer {
    NSLog(@"initLayer");
    if (self = [super initWithLayer:layer]) {
        self.pertent = layer.pertent;
    }
    return self;
}

-(void)drawInContext:(CGContextRef)ctx {
    double radius = self.frame.size.width / 2 - 4 ; //半径
    
    int startX= radius + 2 ;//圆心x坐标
    int startY= radius + 2 ;//圆心y坐标
    
    
    CGContextRef context = ctx;//获得当前view的图形上下文(context)
    //设置画笔颜色
    CGContextSetRGBStrokeColor(context, 216/255.0, 216/255.0, 216/255.0, 1);
    //设置画笔线条粗细
    CGContextSetLineWidth(context, 3);
    //画整个背景灰色
    CGContextAddEllipseInRect(context, CGRectMake(2,2, radius*2, radius*2));
    CGContextStrokePath(context);
    
    CGContextSetRGBStrokeColor(context, 247/255.0, 123/255.0, 3/255.0, 1);
    //    //逆时针画扇形
    CGContextAddArc(context, startX, startY, radius, - M_PI / 2,  self.pertent * 2 * M_PI - M_PI / 2  , 0);
    CGContextDrawPath(context, kCGPathStroke);
    
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"pertent"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}




@end

@interface MGCircleProgressView()


@property(nonatomic, strong) CircleLayer *circleLayer;

@end

@implementation MGCircleProgressView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.circleLayer = [CircleLayer layer];
        
        self.circleLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:self.circleLayer];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.circleLayer.frame = self.bounds;
}

-(void)setPertent:(CGFloat)pertent {
//    CABasicAnimation * ani = [CABasicAnimation animationWithKeyPath:@"pertent"];
//    ani.duration = 0.01();
//    ani.toValue = @(pertent);
//    ani.removedOnCompletion = YES;
//    ani.fillMode = kCAFillModeForwards;
//    ani.delegate = self;
//    [self.circleLayer addAnimation:ani forKey:@"pertentAni"];
     self.circleLayer.pertent = self.pertent;
    [self.circleLayer setNeedsDisplay];
    _pertent = pertent;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.circleLayer.pertent = self.pertent;
}


-(void)updateProgressContentViewWithProgressValue:(CGFloat )progressValue {
    [self setPertent:progressValue];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
