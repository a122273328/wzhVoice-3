//
//  ViewController.m
//  wzhVoice
//
//  Created by wzh on 2017/7/17.
//  Copyright © 2017年 WZH. All rights reserved.
//

#import "ViewController.h"
//识别UI只添加BDRecognizerViewController.h 、BDRecognizerViewDelegate.h
#import "BDRecognizerViewController.h"
#import "BDRecognizerViewDelegate.h"
#import "BDVRSConfig.h"
//接口识别只添加BDVoiceRecognitionClient.h
#import "BDVoiceRecognitionClient.h"
#import "JSONKit.h"
#import "WZHAnimationView.h"

@interface ViewController ()<MVoiceRecognitionClientDelegate,BDRecognizerViewDelegate,UITextViewDelegate>

/**
 返回结果的view
 */
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (weak, nonatomic) IBOutlet UITextView *stautsTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self configTextView];
    
}

/**
 配置textView
 */
- (void)configTextView{
    self.resultTextView.backgroundColor = [UIColor lightGrayColor];
    self.resultTextView.delegate = self;
}
- (IBAction)startVoice:(UIButton *)sender {
    //开始录音
    [self startRecognitionAction];
}

/**************--普通接口语音识别start--****************/

/**
 开始录音
 */
- (void)startRecognitionAction{
    /***---------开发者身份验证-----------***/
    // 设置开发者申请的api key和secret key
    [[BDVoiceRecognitionClient sharedInstance]setApiKey:API_KEY withSecretKey:SECRET_KEY];
    // 设置识别语言，有效值参见枚举类型TVoiceRecognitionLanguage
    [[BDVoiceRecognitionClient sharedInstance] setLanguage:EVoiceRecognitionLanguageChinese];
    //语音识别请求资源类型
    [[BDVoiceRecognitionClient sharedInstance] setResourceType:RESOURCE_TYPE_NLU];
    // 可以识别类型复合
    [[BDVoiceRecognitionClient sharedInstance] setPropertyList:@[@(EVoiceRecognitionPropertyWeb)]];
    // 判断是否可以录音
    if ([[BDVoiceRecognitionClient sharedInstance] isCanRecorder]) {
        //识别接口进行识别
        [[BDVoiceRecognitionClient sharedInstance] startVoiceRecognition:self];
        
    }
    
}

/**
 语音识别数据加载完

 @param content 返回内容
 */
- (void)loadDBVoiceContent:(NSString *)content{
    
    self.resultTextView.text = content;

}


/**
 状态信息

 @param content 内容
 */
- (void)DBVoiceStatusContent:(NSString *)content{
    
    NSString *star = self.stautsTextView.text;
    
    if (star.length > 0) {
        
        self.stautsTextView.text = [NSString stringWithFormat:@"%@\r\n%@",star,content];
    }else{
        
        self.stautsTextView.text = content;
    
    }
    
    
}

#pragma mark --- MVoiceRecognitionClientDelegate 语音识别工作状态通知
//各个阶段识别状态
- (void)VoiceRecognitionClientWorkStatus:(int) aStatus obj:(id)aObj{

    switch (aStatus) {
        case EVoiceRecognitionClientWorkStatusStartWorkIng:
           {
               NSLog(@"开始录音");
               [self DBVoiceStatusContent:@"开始录音"];
               [WZHAnimationView showInView:self.view];
           }
            
            break;
        case EVoiceRecognitionClientWorkStatusStart:
            {
                NSLog(@"检测到用户开始说话");
                [self DBVoiceStatusContent:@"检测到用户开始说话"];
            }
            break;
        case EVoiceRecognitionClientWorkStatusEnd:
            {
                NSLog(@"结束录音");
                [self DBVoiceStatusContent:@"结束录音"];
                [WZHAnimationView dismiss];
            }
            break;
        case EVoiceRecognitionClientWorkStatusFinish:
            {
                NSLog(@"语音识别功能完成，服务器返回正确结果");
                [self DBVoiceStatusContent:@"语音识别功能完成，服务器返回正确结果"];
                NSString *content = [aObj JSONString];
                NSLog(@"识别结果: %@",content);
                [self loadDBVoiceContent:content];
            }
            break;
            
        default:
            break;
    }

}

- (void)VoiceRecognitionClientErrorStatus:(int)aStatus subStatus:(int)aSubStatus{
    
    switch (aStatus) {
        case EVoiceRecognitionClientErrorStatusClassVDP:
        {
            [self showFailureInfoTip:@"语音数据处理过程出错"];
            [self DBVoiceStatusContent:@"语音数据处理过程出错"];
        }
            
            break;
        case EVoiceRecognitionClientErrorStatusUnKnow:{
            
            [self DBVoiceStatusContent:@"未知错误异常"];
            [self showFailureInfoTip:@"未知错误异常"];
        }
            
            break;

        case EVoiceRecognitionClientErrorStatusNoSpeech:{
            
            [self DBVoiceStatusContent:@"用户未说话"];
            [self showFailureInfoTip:@"用户未说话"];
        }
            
            break;

        case EVoiceRecognitionClientErrorStatusShort:{
            
            [self DBVoiceStatusContent:@"说话声音太短"];
            [self showFailureInfoTip:@"说话声音太短"];
        }
            
            break;
        case EVoiceRecognitionClientErrorStatusClassRecord:{
            
            [self DBVoiceStatusContent:@"录音出错"];
            [self showFailureInfoTip:@"录音出错"];
        
        }
            
            break;
        case EVoiceRecognitionClientErrorStatusClassLocalNet:{
            
            [self DBVoiceStatusContent:@"本地网络联接出错"];
            [self showFailureInfoTip:@"本地网络联接出错"];
        
        }
            
            break;
        case EVoiceRecognitionClientErrorStatusClassServerNet:{
            [self DBVoiceStatusContent:@"本地网络联接出错"];
            [self showFailureInfoTip:@"服务器返回网络错误"];
        }
            
            break;

            
        default:
            break;
    }
}

- (void)VoiceRecognitionClientNetWorkStatus:(int)aStatus{
    
    switch (aStatus) {
        case EVoiceRecognitionClientNetWorkStatusStart:
            [self DBVoiceStatusContent:@"网络开始工作"];

            break;
        case EVoiceRecognitionClientNetWorkStatusEnd:
            [self DBVoiceStatusContent:@"网络工作完成"];

            break;
        default:
            break;
    }
}

/**************--普通接口语音识别END--****************/

/**************--UI接口语音识别Start--****************/
- (IBAction)startUIVoice:(id)sender {
    
    [self showInfoTip:@"百度审核未通过，实现见227行"];
    
    //[self createdUIVoiceController];
    
}

/**
 创建识别控件
 */
- (void)createdUIVoiceController{
    
    BDRecognizerViewController *recognizerViewController = [[BDRecognizerViewController alloc] initWithOrigin:CGPointMake(9, 128) withTheme: [BDTheme defaultTheme]];
    recognizerViewController.enableFullScreenMode = NO; //设置是否全屏
    recognizerViewController.delegate = self;
    
    // 设置识别参数
    BDRecognizerViewParamsObject *paramsObject = [[BDRecognizerViewParamsObject alloc] init];
    
    // 开发者信息，必须修改API_KEY和SECRET_KEY为在百度开发者平台申请得到的值，否则示例不能工作
    paramsObject.apiKey = API_KEY;
    paramsObject.secretKey = SECRET_KEY;
    
    // 设置是否需要语义理解，只在搜索模式有效
    paramsObject.isNeedNLU = [BDVRSConfig sharedInstance].isNeedNLU;
    
    // 设置识别语言
    paramsObject.language = [BDVRSConfig sharedInstance].recognitionLanguage;
    
    // 设置识别模式，分为搜索和输入
    paramsObject.recogPropList = @[[BDVRSConfig sharedInstance].recognitionProperty];
    
    // 设置城市ID，当识别属性包含EVoiceRecognitionPropertyMap时有效
    paramsObject.cityID = 1;
    
    // 开启联系人识别
    //    paramsObject.enableContacts = YES;
    
    // 设置显示效果，是否开启连续上屏
    if ([BDVRSConfig sharedInstance].resultContinuousShow)
    {
        paramsObject.resultShowMode = BDRecognizerResultShowModeContinuousShow;
    }
    else
    {
        paramsObject.resultShowMode = BDRecognizerResultShowModeWholeShow;
    }
    
    // 设置提示音开关，是否打开，默认打开
    if ([BDVRSConfig sharedInstance].uiHintMusicSwitch)
    {
        paramsObject.recordPlayTones = EBDRecognizerPlayTonesRecordPlay;
    }
    else
    {
        paramsObject.recordPlayTones = EBDRecognizerPlayTonesRecordForbidden;
    }
    
    paramsObject.isShowTipAfter3sSilence = NO;
    paramsObject.isShowHelpButtonWhenSilence = NO;
    paramsObject.tipsTitle = @"可以使用如下指令记账";
    paramsObject.tipsList = [NSArray arrayWithObjects:@"我要记账", @"买苹果花了十块钱", @"买牛奶五块钱", @"第四行滚动后可见", @"第五行是最后一行", nil];
    
    paramsObject.appCode = APPID;
    paramsObject.licenseFilePath= [[NSBundle mainBundle] pathForResource:@"bdasr_temp_license" ofType:@"dat"];
    paramsObject.datFilePath = [[NSBundle mainBundle] pathForResource:@"s_1" ofType:@""];
    if ([[BDVRSConfig sharedInstance].recognitionProperty intValue] == EVoiceRecognitionPropertyMap) {
        paramsObject.LMDatFilePath = [[NSBundle mainBundle] pathForResource:@"s_2_Navi" ofType:@""];
    } else if ([[BDVRSConfig sharedInstance].recognitionProperty intValue] == EVoiceRecognitionPropertyInput) {
        paramsObject.LMDatFilePath = [[NSBundle mainBundle] pathForResource:@"s_2_InputMethod" ofType:@""];
    }
    
    paramsObject.recogGrammSlot = @{@"$name_CORE" : @"张三\n李四\n",
                                    @"$song_CORE" : @"小苹果\n朋友\n",
                                    @"$app_CORE" : @"QQ\n百度\n微信\n百度地图\n",
                                    @"$artist_CORE" : @"刘德华\n周华健\n"};
    
    [recognizerViewController startWithParams:paramsObject];


}

#pragma mark --- BDRecognizerViewDelegate
- (void)onEndWithViews:(BDRecognizerViewController *)aBDRecognizerViewController withResults:(NSArray *)aResults
{
    if ([[BDVoiceRecognitionClient sharedInstance] getRecognitionProperty] != EVoiceRecognitionPropertyInput){
        
        NSMutableString *tmpString = [aResults objectAtIndex:0];
        [self loadDBVoiceContent:[NSString stringWithFormat:@"%@",tmpString]];
    
    }else{
        
        NSLog(@"------");
    
    }
}

/**************--UI接口语音识别END--****************/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    //收起键盘
    [self.view endEditing:YES];
}


#pragma mark --- UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    //设置不弹出键盘
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
