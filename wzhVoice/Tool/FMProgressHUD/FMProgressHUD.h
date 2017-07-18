//
//  FMProgressHUD.h
//  Aiqiumi
//
//  Created by lan on 2016/12/7.
//  Copyright © 2016年 Lan. All rights reserved.
//

#import "MBProgressHUD.h"
typedef enum {
    FMProgressHUDModeCustomViewSuccess,
    FMProgressHUDModeCustomViewWarning,
    FMProgressHUDModeText
} FMProgressHUDMode;

@interface FMProgressHUD : MBProgressHUD

- (void)show:(BOOL)animated text:(NSString *)text hudMode:(FMProgressHUDMode)hudMode;

- (void)show:(BOOL)animated text:(NSString *)text;

@end
