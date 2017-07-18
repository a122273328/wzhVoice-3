//
//  FMProgressHUD.m
//  Aiqiumi
//
//  Created by lan on 2016/12/7.
//  Copyright © 2016年 Lan. All rights reserved.
//

#import "FMProgressHUD.h"

@interface FMProgressHUD ()

@end

@implementation FMProgressHUD


- (void)show:(BOOL)animated text:(NSString *)text hudMode:(FMProgressHUDMode)hudMode
{
    switch (hudMode) {
        case FMProgressHUDModeCustomViewSuccess:{
            self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Hud_Checkmark.png"]];
            self.customView.bounds = CGRectMake(0, 0, 35, 35);
            self.customView.contentMode = UIViewContentModeScaleAspectFit;
            self.labelText = text;
            self.mode = MBProgressHUDModeCustomView;
            [self show:animated];
        }
            break;
            
        case FMProgressHUDModeCustomViewWarning:
        {
            self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Hud_Warning.png"]];
            self.customView.bounds = CGRectMake(0, 0, 35, 35);
            self.customView.contentMode = UIViewContentModeScaleAspectFit;
            self.labelText = text;
            self.mode = MBProgressHUDModeCustomView;
            [self show:animated];
        }
            break;
            
        case FMProgressHUDModeText:
        {
            self.labelText = text;
            self.mode = MBProgressHUDModeText;
            [self show:animated];
        }
            break;
    }
}


- (void)show:(BOOL)animated text:(NSString *)text
{
    self.labelText = text;
    self.mode =MBProgressHUDModeIndeterminate;
    [self show:YES];
}



@end
