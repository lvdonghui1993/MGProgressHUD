//
//  MGCircleProgressView.h
//  MGProgressHUD
//
//  Created by donghui lv on 2018/3/29.
//  Copyright © 2018年 donghui lv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGBaseProgressViewProtocol.h"

@interface MGCircleProgressView : UIView<MGBaseProgressViewProtocol>

/**
 百分比数值
 */
@property(nonatomic, assign) CGFloat pertent;


@end
