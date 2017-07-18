//
//  BaseViewController.m
//  wzhVoice
//
//  Created by wzh on 2017/7/18.
//  Copyright © 2017年 WZH. All rights reserved.
//

#import "BaseViewController.h"
#import "FMProgressHUD.h"
#import "MBProgressHUD.h"
@interface BaseViewController ()

@property (nonatomic, strong) FMProgressHUD      *hud;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark -- setter Method

- (MBProgressHUD *)hud{
    if (!_hud){
        _hud = [[FMProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hud];
    }
    [self.view bringSubviewToFront:_hud];
    return _hud;
}


#pragma mark - 显示等待框

- (void)showInfoTip:(NSString *)tip
{
    //    [self.hud show:YES];
    [self.hud show:YES text:tip hudMode:FMProgressHUDModeText];
    [self.hud hide:YES afterDelay:2.0f];
}

- (void)showSuccessInfoTip:(NSString *)tip
{
    [self.hud show:YES text:tip hudMode:FMProgressHUDModeCustomViewSuccess];
    [self.hud hide:YES afterDelay:2.0f];
}


- (void)showFailureInfoTip:(NSString *)tip
{
    [self.hud show:YES text:tip hudMode:FMProgressHUDModeCustomViewWarning];
    [self.hud hide:YES afterDelay:2.0f];
}

- (void)showLoadingInfoTip:(NSString *)tip{
    [self.hud show:YES text:tip];
}

/**
 *  @author Lan, 16-07-28 14:07:50
 *
 *  TODO: 显示提示消息
 *
 *  @param view 视图消息
 */
- (void)showInfoTipsInView:(UIView *)view text:(NSString *)text
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    [view bringSubviewToFront:hud];
    [self.hud show:YES text:text];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hide:YES];
        [hud removeFromSuperview];
    });
}

/**
 *  @author Lan, 16-07-13 14:07:54
 *
 *  TODO: 隐藏信息
 */
- (void)hideHud{
    [self.hud hide:YES];
}


- (void)hideHudAfterDelay:(NSTimeInterval)delay{
    [self.hud hide:YES afterDelay:delay];
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
