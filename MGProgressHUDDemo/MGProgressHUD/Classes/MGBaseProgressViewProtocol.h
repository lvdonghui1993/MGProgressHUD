//
//  MGBaseProgressProtocol.h
//  MGProgressHUD
//
//  Created by donghui lv on 2018/3/28.
//  Copyright © 2018年 donghui lv. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MGBaseProgressViewProtocol <NSObject>


@optional

/**
 通过progressValue 刷新布局

 @param progressValue 进度值
 */
- (void)updateProgressContentViewWithProgressValue:(CGFloat )progressValue;


@end
