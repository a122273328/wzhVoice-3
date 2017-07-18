//
//  BaseViewController.h
//  wzhVoice
//
//  Created by wzh on 2017/7/18.
//  Copyright © 2017年 WZH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)showInfoTip:(NSString *)tip;
- (void)showSuccessInfoTip:(NSString *)tip;

- (void)showFailureInfoTip:(NSString *)tip;

- (void)showLoadingInfoTip:(NSString *)tip;


- (void)showInfoTipsInView:(UIView *)view text:(NSString *)text;



- (void)hideHud;

@end
