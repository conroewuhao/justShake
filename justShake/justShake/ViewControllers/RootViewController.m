//
//  RootViewController.m
//  justShake
//
//  Created by wuhao on 16/1/5.
//  Copyright © 2016年 houbu. All rights reserved.
//

#import "RootViewController.h"
#import "FoodViewController.h"
#import "HistoryViewController.h"
#import "NSObject+localDateString.h"
#import "NSString+WHAddtion.h"
#import "DBThings.h"
#import "UIColor+HexColor.h"
#import <Masonry.h>
#import "UIDevice+machine.h"

#define fixHeight 165 //修正的高度
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define rgba(a,b,c,d) [UIColor colorWithRed:a/255.f green:b/255.f blue:c/255.f alpha:d]


@interface RootViewController ()
{
    UIImageView *titleImage;//标题图标
    UILabel *titleLabel;//标题按钮
    UILabel *contentLabel;//吃饭内容标题
    UIButton *confirmButton;//确认按钮
    
    UIImageView *image1,*image2,*image3,*image4,*image5,*image6;//
    UIImageView *dong1,*dong2,*dong3,*dong4,*dong5,*dong6;//
    int whichAnimatiom;
    int zeng;
    BOOL canYao;

}

@property(nonatomic,strong)UIImageView *dawanView;//大碗的背景
@property(nonatomic,strong)UIWindow *window;
@property(nonatomic,strong)UIButton *musicButton;

@end

@implementation RootViewController

-(void)viewWillAppear:(BOOL)animated
{


    [self.navigationController.navigationBar setBarTintColor:rgba(41, 204, 169, 1)];
    self.navigationController.navigationBar.clipsToBounds=YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=rgba(41, 204, 169, 1);
    
    //masony

    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:nil action:nil];
    

    canYao=YES;
    
    //[self createTopLevelButton];
    
    [self configNavigationItem];
    
    if (self.navigationItem) {
        
        CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
        SINavigationMenuView *menu = [[SINavigationMenuView alloc] initWithFrame:frame title:@"选择玩意"];
        [menu displayMenuInView:self.navigationController.view];
        menu.items = @[@"吃什么", @"掷色子"];
        menu.delegate = self;
        self.navigationItem.titleView = menu;
    }
    
    [self configShakeView];
    
}

/**
 *  设置导航栏按钮
 */
-(void)configNavigationItem{

    //左边的按钮
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_add"] style:UIBarButtonItemStylePlain target:self action:@selector(pressLeftButton)];
    //右边的按钮
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_record"] style:UIBarButtonItemStylePlain target:self action:@selector(pressRightButton)];
    //设置导航栏背景色

}


-(void)createTitleImage{
    titleImage=[[UIImageView alloc]init];
}



-(void)createTopLevelButton{
    
    _musicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[_musicButton setTitle:@"悬浮按钮" forState:UIControlStateNormal];
    [_musicButton setBackgroundColor:[UIColor redColor]];
    [_musicButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _musicButton.frame = CGRectMake(100, 200, 30, 30);
    [_musicButton addTarget:self action:@selector(playMusic) forControlEvents:UIControlEventTouchUpInside];
    _musicButton.layer.cornerRadius=15;
    _musicButton.layer.masksToBounds=YES;
    [self.view addSubview:_musicButton];
    [self.view bringSubviewToFront:_musicButton];
}


-(void)playMusic{

}

/**
 *  配置摇一摇视图
 */
-(void)configShakeView{

    //标题label
    if (!titleLabel || titleLabel.superview!=self.view) {
        titleLabel=[[UILabel alloc]init];
        [titleLabel setText:@"摇一摇,今天吃什么"];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setTextColor:[UIColor redColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        
        titleLabel.frame=CGRectMake(kScreenWidth/2-40, 100, 150, 100);
        //titleLabel.center=CGPointMake(100, 200);
        titleLabel.center=CGPointMake(self.view.center.x, self.view.center.y-50);
        [self.view addSubview:titleLabel];
    }
    
    //内容标题
    if (!contentLabel || contentLabel.superview!=self.view) {
        contentLabel=[[UILabel alloc]init];
       // [contentLabel setTextAlignment:NSTextAlignmentCenter];
        // NSString *str=[[DBThings shareInstance]loadDB];
        [contentLabel setText:@""];
        [contentLabel setTextColor:[UIColor blackColor]];
        [contentLabel setBackgroundColor:[UIColor clearColor]];
        
        contentLabel.frame=CGRectMake(kScreenWidth/2-40, 220, 150, 100);
        contentLabel.adjustsFontSizeToFitWidth=YES;
        //titleLabel.center=CGPointMake(100, 200);
        [self.view addSubview:contentLabel];
    }
}

/**
 *  开始摇动手机
 *
 *  @param motion motion
 *  @param event  event
 */
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    if (canYao) {
        
        if (titleLabel) {
           // [titleLabel setText:@"今天吃这个"];
            [titleLabel setText:nil];
        }
        
        
        if (!confirmButton || confirmButton.superview==nil) {
            confirmButton=[[UIButton alloc]init];
            confirmButton.frame=CGRectMake(kScreenWidth/2-40, 350,kScreenWidth/2,kScreenHeight/12);
            [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
            [confirmButton setBackgroundColor:[UIColor clearColor]];
            [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            confirmButton.layer.masksToBounds=YES;
            confirmButton.layer.cornerRadius=5;
            [confirmButton.layer setBorderColor:[UIColor whiteColor].CGColor];
            [confirmButton.layer setBorderWidth:2];
            //确定按钮的点击事件
            [confirmButton addTarget:self action:@selector(pressConfirmButton) forControlEvents:UIControlEventTouchUpInside];
            confirmButton.center=CGPointMake(self.view.center.x,kScreenHeight*0.8);
            [self.view addSubview:confirmButton];
        }
        
        //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        if (contentLabel.superview!=nil) {
            [contentLabel setText:[[DBThings shareInstance]loadDBWithKeyString:@"foodArray"]];
           // [contentLabel setTextAlignment:NSTextAlignmentCenter];
        }
        else
        {
            [self.view addSubview:contentLabel];
            [contentLabel setText:[[DBThings shareInstance]loadDBWithKeyString:@"foodArray"]];
        }
        
        //
        UIColor *randomColor=[self changeBackgroundColor];
        
        
        self.view.backgroundColor=randomColor;
        [self.navigationController.navigationBar setBarTintColor:randomColor];
        
    }
    else
        return;
    
}

/**
 *  停止摇动手机
 *
 *  @param motion motion
 *  @param event  event
 */

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    // AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    if (confirmButton) {
        NSLog(@"进入");
      //  [confirmButton setTitle:@"好的" forState:UIControlStateNormal];
        [confirmButton.titleLabel setText:@"好的"];
    }
    
}
/**
 *  点击好的按钮,增加效果
 */

-(void)pressConfirmButton{
    
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDuration:0.4];
    //    [UIView setAnimationDelegate:self];
    //    confirmButton.frame =CGRectMake(confirmButton.frame.origin.x,confirmButton.frame.origin.y,confirmButton.frame.size.width*2,confirmButton.frame.size.height);
    //    [UIView commitAnimations];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        CGAffineTransform transform=CGAffineTransformMakeScale(1.5, 1.5);
        [confirmButton setTransform:transform];
        confirmButton.alpha=0;
        
    }completion:^(BOOL finished) {
        //        CGAffineTransform transform1=CGAffineTransformMakeScale(1, 1);
        //        [confirmButton setTransform:transform1];
        if (confirmButton) {
          // [confirmButton removeFromSuperview];
            CGAffineTransform transform=CGAffineTransformMakeScale(1, 1);
            [confirmButton setTransform:transform];
            confirmButton.titleLabel.text=@"摇摇";
            confirmButton.alpha=1;

        }
        
    }];
    
    NSString *contentString=contentLabel.text;
    if (![NSString isStringEmpty:contentString]) {
        //NSString *content=[NSString stringWithFormat:@"吃了 %@",contentString];
        [[DBThings shareInstance]writeToDBWithContentAndDate:contentString];
    }
    else
        return;
    
}

/**
 *   改变背景颜色
 *
 *  @return UIColor
 */
-(UIColor *)changeBackgroundColor
{
    
    NSArray *arr=@[[UIColor colorWithHexString:@"#AF4111"],[UIColor cyanColor],[UIColor orangeColor],[UIColor colorWithHexString:@"#5D8749"],[UIColor colorWithHexString:@"5D879D"]];
    NSArray *newArr=@[rgba(41, 204, 204, 1),rgba(255, 102, 102, 1),[UIColor orangeColor]];
    
    int i=arc4random()%(newArr.count);
    return newArr[i];
    
}




/**
 *  配置色子视图
 */
-(void)configSaiziView
{
    if (_dawanView) {
        return;
    }
    else{
        //添加大碗背景
        _dawanView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_shaizi"]];
        _dawanView.frame = CGRectMake(0.0,self.navigationController.navigationBar.frame.size.height+20, _dawanView.image.size.width, _dawanView.image.size.height);
        _dawanView.center=CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame)-([[UIDevice currentDevice]isIphoneOr4s]?230:50));
        NSLog(@"%f",_dawanView.center.x);//207
        NSLog(@"%f",_dawanView.center.y);//318
        _dawanView.tag=100;
        [self.view addSubview:_dawanView];
        
#pragma mark 添加辅助参数
        float centerX=_dawanView.center.x;
        float centerY=_dawanView.center.y;

#pragma mark 位置偏移量,要根据屏幕大小进行调整
        float fix_x=centerX/5;
        float fix_y=centerY/3;
        
        //iPhone4,4s
        //iPhone5,fix_x=32,fix_y=78
        //iPhone6,fix_x=37.5 fix_y=94.5,x,y偏大10个像素
        //iPhone6p上面尺寸差不多
        
       NSString *st=[[UIDevice currentDevice]machineDetail];
        
        if ([st hasPrefix:@"iPhone5"] || [st hasPrefix:@"iPhone6"]) {
            float a=centerX/10;
            fix_x=a;
            float b=centerY/10;
            fix_y=b;
        }
        
   

        if ([[UIDevice currentDevice]isIphoneOr4s]) {
            float a=centerX/15;
            fix_x=a;
            float b=centerY/15;
            fix_y=b;
        }
        
        
            
        //逐个添加骰子
        UIImageView *_image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_shaizi_1"]];
        _image1.tag=101;
        _image1.frame = CGRectMake(75.0+fix_x, 115.0+fix_y, 45.0, 45.0);
        image1 = _image1;
        [self.view addSubview:_image1];
        UIImageView *_image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_shaizi_2"]];
        _image2.frame = CGRectMake(135.0+fix_x, 115.0+fix_y, 45.0, 45.0);
        _image2.tag=102;
        image2 = _image2;
        [self.view addSubview:_image2];
        UIImageView *_image3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_shaizi_3"]];
        _image3.frame = CGRectMake(195.0+fix_x, 115.0+fix_y, 45.0, 45.0);
        _image3.tag=103;
        image3 = _image3;
        [self.view addSubview:_image3];
        UIImageView *_image4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_shaizi_4"]];
        _image4.frame = CGRectMake(80.0+fix_x, 180.0+fix_y, 45.0, 45.0);
        _image4.tag=104;
        image4 = _image4;
        [self.view addSubview:_image4];
        UIImageView *_image5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_shaizi_5"]];
        _image5.frame = CGRectMake(140.0+fix_x, 180.0+fix_y, 45.0, 45.0);
        _image5.tag=105;
        image5 = _image5;
        [self.view addSubview:_image5];
        UIImageView *_image6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_shaizi_6"]];
        _image6.frame = CGRectMake(200.0+fix_x, 180.0+fix_y, 45.0, 45.0);
        _image6.tag=106;
        image6 = _image6;
        [self.view addSubview:_image6];
            
        
            
        //添加按钮
        UIButton *btn_bobing = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn_bobing setTitle:@"点我扔色子!" forState:UIControlStateNormal];
        [btn_bobing setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_bobing addTarget:self action:@selector(bobing)  forControlEvents:UIControlEventTouchUpInside];
        btn_bobing.tag=107;
        btn_bobing.frame = CGRectMake(140.0, 400.0, 80.0, 50.0);
      //  btn_bobing.center=self.view.center;
        btn_bobing.center=CGPointMake(kScreenWidth/2, kScreenHeight/5*4);
        [self.view addSubview:btn_bobing];
    }
    
    
    
//    [btn_bobing mas_makeConstraints:^(MASConstraintMaker *make) {
//        
////        make.width.equalTo(self.view.mas_width).multipliedBy(0.2);
////        make.height.equalTo(self.view.mas_height).multipliedBy(0.2);
////        make.centerY.equalTo(self.view.mas_centerY).multipliedBy(0.6);
////        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(0.5);
//        
//       // make.center.equalTo(ws.view);
//        make.centerXWithinMargins.equalTo(ws.view).multipliedBy(0.5);
//        make.centerYWithinMargins.equalTo(ws.view).multipliedBy(0.6);
//        make.size.mas_equalTo(CGSizeMake(80, 80));
//    }];

}


- (void)bobing
{
//    //引入音频文件
//    //    SystemSoundID sound1;
//    //    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"yao" ofType:@"wav"];//音频文件的路径
//    //    CFURLRef sound1URL = (CFURLRef)[NSURL fileURLWithPath:path1];//将路径转换为CFURLRef
//    //    AudioServicesCreateSystemSoundID(sound1URL, &sound1);//加载音频文件并与指定soundID联系起来
//    //    AudioServicesPlayAlertSound(sound1);//播放音频文件
//    
//    static SystemSoundID soundIDTest = 0;
//    
//    
//    NSString * path = [[NSBundle mainBundle] pathForResource:@"yao" ofType:@"wav"];
//    
//    if (path) {
//        
//        AudioServicesCreateSystemSoundID( (CFURLRef)[NSURL fileURLWithPath:path], &soundIDTest );
//        
//    }
//    
//    AudioServicesPlaySystemSound( soundIDTest );
    
    //隐藏初始位置的骰子
    image1.hidden = YES;
    image2.hidden = YES;
    image3.hidden = YES;
    image4.hidden = YES;
    image5.hidden = YES;
    image6.hidden = YES;
    dong1.hidden = YES;
    dong2.hidden = YES;
    dong3.hidden = YES;
    dong4.hidden = YES;
    dong5.hidden = YES;
    dong6.hidden = YES;
    //******************旋转动画的初始化******************
    //转动骰子的载入
    NSArray *myImages = [NSArray arrayWithObjects:
                         [UIImage imageNamed:@"img_shaizi_y_1"],
                         [UIImage imageNamed:@"img_shaizi_y_2"],
                         [UIImage imageNamed:@"img_shaizi_y_3"],nil];
    
#pragma mark 添加辅助参数
    float centerX=_dawanView.center.x;
    float centerY=_dawanView.center.y;
    
#pragma mark 位置偏移量,要根据屏幕大小进行调整
    float fix_x=centerX/5;
    float fix_y=centerY/3;
    
    NSString *st=[[UIDevice currentDevice]machineDetail];
    
    if ([st hasPrefix:@"iPhone5"] || [st hasPrefix:@"iPhone6"]) {
        float a=centerX/10;
        fix_x=a;
        float b=centerY/10;
        fix_y=b;
    }
    
    if ([[UIDevice currentDevice]isIphoneOr4s]) {
        float a=centerX/15;
        fix_x=a;
        float b=centerY/15;
        fix_y=b;
    }
    
    


    //骰子1的转动图片切换
    UIImageView *dong11 = [UIImageView alloc];
    //CGRectMake(75.0+fix_x, 115.0+fix_y, 45.0, 45.0);
    [dong11 initWithFrame:CGRectMake(85.0+fix_x, 115.0+fix_y, 45.0, 45.0)];
    dong11.animationImages = myImages;
    dong11.animationDuration = 0.5;
    [dong11 startAnimating];
    [self.view addSubview:dong11];
    dong1 = dong11;
    //骰子2的转动图片切换
    UIImageView *dong12 = [UIImageView alloc];
    //CGRectMake(135.0+fix_x, 115.0+fix_y, 45.0, 45.0);
    [dong12 initWithFrame:CGRectMake(135.0+fix_x, 115.0+fix_y, 45.0, 45.0)];
    dong12.animationImages = myImages;
    dong12.animationDuration = 0.5;
    [dong12 startAnimating];
    [self.view addSubview:dong12];
    dong2 = dong12;
    //骰子3的转动图片切换
    UIImageView *dong13 = [UIImageView alloc];
    //CGRectMake(195.0+fix_x, 115.0+fix_y, 45.0, 45.0);
    [dong13 initWithFrame:CGRectMake(195.0+fix_x, 115.0+fix_y, 45.0, 45.0)];
    dong13.animationImages = myImages;
    dong13.animationDuration = 0.5;
    [dong13 startAnimating];
    [self.view addSubview:dong13];
    dong3 = dong13;
    //骰子4的转动图片切换
    UIImageView *dong14 = [UIImageView alloc];
    //CGRectMake(80.0+fix_x, 180.0+fix_y, 45.0, 45.0);
    [dong14 initWithFrame:CGRectMake(80.0+fix_x, 180.0+fix_y, 45.0, 45.0)];
    dong14.animationImages = myImages;
    dong14.animationDuration = 0.5;
    [dong14 startAnimating];
    [self.view addSubview:dong14];
    dong4 = dong14;
    //骰子5的转动图片切换
    UIImageView *dong15 = [UIImageView alloc];
    //CGRectMake(140.0+fix_x, 180.0+fix_y, 45.0, 45.0);
    [dong15 initWithFrame:CGRectMake(140.0+fix_x, 180.0+fix_y, 45.0, 45.0)];
    dong15.animationImages = myImages;
    dong15.animationDuration = 0.5;
    [dong15 startAnimating];
    [self.view addSubview:dong15];
    dong5 = dong15;
    //骰子6的转动图片切换
    UIImageView *dong16 = [UIImageView alloc];
    //CGRectMake(200.0+fix_x, 180.0+fix_y, 45.0, 45.0);
    [dong16 initWithFrame:CGRectMake(200.0+fix_x, 180.0+fix_y, 45.0, 45.0)];
    dong16.animationImages = myImages;
    dong16.animationDuration = 0.5;
    [dong16 startAnimating];
    [self.view addSubview:dong16];
    dong6 = dong16;
    
    //******************旋转动画******************
    //设置动画
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [spin setToValue:[NSNumber numberWithFloat:M_PI * 16.0]];
    [spin setDuration:4];
    //******************位置变化******************
    
    
    
    //骰子1的位置变化
    CGPoint p1 = CGPointMake(85.0+fix_x, 115.0+fix_y);
    CGPoint p2 = CGPointMake(165.0+fix_x, 100.0+fix_y);
    CGPoint p3 = CGPointMake(240.0+fix_x, 160.0+fix_y);
    CGPoint p4 = CGPointMake(140.0+fix_x, 200.0+fix_y);
    NSArray *keypoint = [[NSArray alloc] initWithObjects:[NSValue valueWithCGPoint:p1],[NSValue valueWithCGPoint:p2],[NSValue valueWithCGPoint:p3],[NSValue valueWithCGPoint:p4], nil];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation setValues:keypoint];
    [animation setDuration:4.0];
    [animation setDelegate:self];
    [dong11.layer setPosition:CGPointMake(140.0+fix_x, 200.0+fix_y)];
    //骰子2的位置变化
    CGPoint p21 = CGPointMake(135.0+fix_x, 115.0+fix_y);
    CGPoint p22 = CGPointMake(160.0+fix_x, 220.0+fix_y);
    CGPoint p23 = CGPointMake(85.0+fix_x, 190.0+fix_y);
    CGPoint p24 = CGPointMake(190.0+fix_x, 175.0+fix_y);
    NSArray *keypoint2 = [[NSArray alloc] initWithObjects:[NSValue valueWithCGPoint:p21],[NSValue valueWithCGPoint:p22],[NSValue valueWithCGPoint:p23],[NSValue valueWithCGPoint:p24], nil];
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation2 setValues:keypoint2];
    [animation2 setDuration:4.0];
    [animation2 setDelegate:self];
    [dong12.layer setPosition:CGPointMake(190.0+fix_x, 175.0+fix_y)];
    //骰子3的位置变化
    CGPoint p31 = CGPointMake(195.0+fix_x, 115.0+fix_y);
    CGPoint p32 = CGPointMake(175.0+fix_x, 95.0+fix_y);
    CGPoint p33 = CGPointMake(140.0+fix_x, 220.0+fix_y);
    CGPoint p34 = CGPointMake(100.0+fix_x, 130.0+fix_y);
    NSArray *keypoint3 = [[NSArray alloc] initWithObjects:[NSValue valueWithCGPoint:p31],[NSValue valueWithCGPoint:p32],[NSValue valueWithCGPoint:p33],[NSValue valueWithCGPoint:p34], nil];
    CAKeyframeAnimation *animation3 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation3 setValues:keypoint3];
    [animation3 setDuration:4.0];
    [animation3 setDelegate:self];
    [dong13.layer setPosition:CGPointMake(100.0+fix_x, 130.0+fix_y)];
    //骰子4的位置变化
    CGPoint p41 = CGPointMake(80.0+fix_x,180.0+fix_y);
    CGPoint p42 = CGPointMake(220.0+fix_x, 160.0+fix_y);
    CGPoint p43 = CGPointMake(75.0+fix_x,  115.0+fix_y);
    CGPoint p44 = CGPointMake(155.0+fix_x, 100.0+fix_y);
    NSArray *keypoint4 = [[NSArray alloc] initWithObjects:[NSValue valueWithCGPoint:p41],[NSValue valueWithCGPoint:p42],[NSValue valueWithCGPoint:p43],[NSValue valueWithCGPoint:p44], nil];
    CAKeyframeAnimation *animation4 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation4 setValues:keypoint4];
    [animation4 setDuration:4.0];
    [animation4 setDelegate:self];
    [dong14.layer setPosition:CGPointMake(155.0+fix_x, 100.0+fix_y)];
    //骰子5的位置变化
    CGPoint p51 = CGPointMake(140.0+fix_x, 180.0+fix_y);
    CGPoint p52 = CGPointMake(225.0+fix_x, 180.0+fix_y);
    CGPoint p53 = CGPointMake(195.0+fix_x, 115.0+fix_y);
    CGPoint p54 = CGPointMake(160.0+fix_x, 190.0+fix_y);
    NSArray *keypoint5 = [[NSArray alloc] initWithObjects:[NSValue valueWithCGPoint:p51],[NSValue valueWithCGPoint:p52],[NSValue valueWithCGPoint:p53],[NSValue valueWithCGPoint:p54], nil];
    CAKeyframeAnimation *animation5 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation5 setValues:keypoint5];
    [animation5 setDuration:4.0];
    [animation5 setDelegate:self];
    [dong15.layer setPosition:CGPointMake(190.0+fix_x, 220.0+fix_y)];
    //骰子6的位置变化
    CGPoint p61 = CGPointMake(200.0+fix_x, 180.0+fix_y);
    CGPoint p62 = CGPointMake(90.0+fix_x, 190.0+fix_y);
    CGPoint p63 = CGPointMake(70.0+fix_x, 140.0+fix_y);
    CGPoint p64 = CGPointMake(230.0+fix_x, 110.0+fix_y);
    NSArray *keypoint6 = [[NSArray alloc] initWithObjects:[NSValue valueWithCGPoint:p61],[NSValue valueWithCGPoint:p62],[NSValue valueWithCGPoint:p63],[NSValue valueWithCGPoint:p64], nil];
    CAKeyframeAnimation *animation6 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation6 setValues:keypoint6];
    [animation6 setDuration:4.0];
    [animation6 setDelegate:self];
    [dong16.layer setPosition:CGPointMake(230.0+fix_x, 110.0+fix_y)];
    
    //******************动画组合******************
    //骰子1的动画组合
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects: animation, spin,nil];
    animGroup.duration = 4;
    [animGroup setDelegate:self];
    [[dong11 layer] addAnimation:animGroup forKey:@"position"];
    //骰子2的动画组合
    CAAnimationGroup *animGroup2 = [CAAnimationGroup animation];
    animGroup2.animations = [NSArray arrayWithObjects: animation2, spin,nil];
    animGroup2.duration = 4;
    [animGroup2 setDelegate:self];
    [[dong12 layer] addAnimation:animGroup2 forKey:@"position"];
    //骰子3的动画组合
    CAAnimationGroup *animGroup3 = [CAAnimationGroup animation];
    animGroup3.animations = [NSArray arrayWithObjects: animation3, spin,nil];
    animGroup3.duration = 4;
    [animGroup3 setDelegate:self];
    [[dong13 layer] addAnimation:animGroup3 forKey:@"position"];
    //骰子4的动画组合
    CAAnimationGroup *animGroup4 = [CAAnimationGroup animation];
    animGroup4.animations = [NSArray arrayWithObjects: animation4, spin,nil];
    animGroup4.duration = 4;
    [animGroup4 setDelegate:self];
    [[dong14 layer] addAnimation:animGroup4 forKey:@"position"];
    //骰子5的动画组合
    CAAnimationGroup *animGroup5 = [CAAnimationGroup animation];
    animGroup5.animations = [NSArray arrayWithObjects: animation5, spin,nil];
    animGroup5.duration = 4;
    [animGroup5 setDelegate:self];
    [[dong15 layer] addAnimation:animGroup5 forKey:@"position"];
    //骰子6的动画组合
    CAAnimationGroup *animGroup6 = [CAAnimationGroup animation];
    animGroup6.animations = [NSArray arrayWithObjects: animation6, spin,nil];
    animGroup6.duration = 4;
    [animGroup6 setDelegate:self];
    [[dong16 layer] addAnimation:animGroup6 forKey:@"position"];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //停止骰子自身的转动
    [dong1 stopAnimating];
    [dong2 stopAnimating];
    [dong3 stopAnimating];
    [dong4 stopAnimating];
    [dong5 stopAnimating];
    [dong6 stopAnimating];
    
    //*************产生随机数，真正博饼**************
    srand((unsigned)time(0));  //不加这句每次产生的随机数不变
    //骰子1的结果
    int result1 = (rand() % 5) +1 ;  //产生1～6的数
    switch (result1) {
        case 1:dong1.image = [UIImage imageNamed:@"img_shaizi_1"];break;
        case 2:dong1.image = [UIImage imageNamed:@"img_shaizi_2"];break;
        case 3:dong1.image = [UIImage imageNamed:@"img_shaizi_3"];break;
        case 4:dong1.image = [UIImage imageNamed:@"img_shaizi_4"];break;
        case 5:dong1.image = [UIImage imageNamed:@"img_shaizi_5"];break;
        case 6:dong1.image = [UIImage imageNamed:@"img_shaizi_6"];break;
    }
    //骰子2的结果
    int result2 = (rand() % 5) +1 ;  //产生1～6的数
    switch (result2) {
        case 1:dong2.image = [UIImage imageNamed:@"img_shaizi_1"];break;
        case 2:dong2.image = [UIImage imageNamed:@"img_shaizi_2"];break;
        case 3:dong2.image = [UIImage imageNamed:@"img_shaizi_3"];break;
        case 4:dong2.image = [UIImage imageNamed:@"img_shaizi_4"];break;
        case 5:dong2.image = [UIImage imageNamed:@"img_shaizi_5"];break;
        case 6:dong2.image = [UIImage imageNamed:@"img_shaizi_6"];break;

    }
    //骰子3的结果
    int result3 = (rand() % 5) +1 ;  //产生1～6的数
    switch (result3) {
        case 1:dong3.image = [UIImage imageNamed:@"img_shaizi_1"];break;
        case 2:dong3.image = [UIImage imageNamed:@"img_shaizi_2"];break;
        case 3:dong3.image = [UIImage imageNamed:@"img_shaizi_3"];break;
        case 4:dong3.image = [UIImage imageNamed:@"img_shaizi_4"];break;
        case 5:dong3.image = [UIImage imageNamed:@"img_shaizi_5"];break;
        case 6:dong3.image = [UIImage imageNamed:@"img_shaizi_6"];break;
    }
    //骰子4的结果
    int result4 = (rand() % 5) +1 ;  //产生1～6的数
    switch (result4) {
        case 1:dong4.image = [UIImage imageNamed:@"img_shaizi_1"];break;
        case 2:dong4.image = [UIImage imageNamed:@"img_shaizi_2"];break;
        case 3:dong4.image = [UIImage imageNamed:@"img_shaizi_3"];break;
        case 4:dong4.image = [UIImage imageNamed:@"img_shaizi_4"];break;
        case 5:dong4.image = [UIImage imageNamed:@"img_shaizi_5"];break;
        case 6:dong4.image = [UIImage imageNamed:@"img_shaizi_6"];break;
    }
    //骰子5的结果
    int result5 = (rand() % 5) +1 ;  //产生1～6的数
    switch (result5) {
        case 1:dong5.image = [UIImage imageNamed:@"img_shaizi_1"];break;
        case 2:dong5.image = [UIImage imageNamed:@"img_shaizi_2"];break;
        case 3:dong5.image = [UIImage imageNamed:@"img_shaizi_3"];break;
        case 4:dong5.image = [UIImage imageNamed:@"img_shaizi_4"];break;
        case 5:dong5.image = [UIImage imageNamed:@"img_shaizi_5"];break;
        case 6:dong5.image = [UIImage imageNamed:@"img_shaizi_6"];break;
    }
    //骰子6的结果
    int result6 = (rand() % 5) +1 ;  //产生1～6的数
    switch (result6) {
        case 1:dong6.image = [UIImage imageNamed:@"img_shaizi_1"];break;
        case 2:dong6.image = [UIImage imageNamed:@"img_shaizi_2"];break;
        case 3:dong6.image = [UIImage imageNamed:@"img_shaizi_3"];break;
        case 4:dong6.image = [UIImage imageNamed:@"img_shaizi_4"];break;
        case 5:dong6.image = [UIImage imageNamed:@"img_shaizi_5"];break;
        case 6:dong6.image = [UIImage imageNamed:@"img_shaizi_6"];break;
    }
}

-(void)didSelectItemAtIndex:(NSUInteger)index
{
  
    [self reFreshTitleWithIndex:index];
    
    //色子
    if (index==1) {
        
       // self.view.backgroundColor=[UIColor colorWithHexString:@"FF6666"];
        self.view.backgroundColor=rgba(255, 102, 102, 1);
        [self.navigationController.navigationBar setBarTintColor:rgba(255, 102, 102, 1)];
        
        if (contentLabel||confirmButton) {
            if (contentLabel) {
                [contentLabel removeFromSuperview];
                contentLabel=nil;
            }
            if (titleLabel) {
                [titleLabel removeFromSuperview];
                titleLabel=nil;
            }
            if (confirmButton) {
                [confirmButton removeFromSuperview];
                confirmButton=nil;
            }
            
         //   self.navigationController.navigationBarHidden=YES;
            
           self.navigationItem.leftBarButtonItem=nil;
           self.navigationItem.rightBarButtonItem=nil;
            
            
        }
        
        canYao=NO;//是否可以摇动
        [self configSaiziView];
    }
    
    //吃什么
    if (index==0) {
        
        self.view.backgroundColor=rgba(41, 204, 169, 1);
        
        [self configNavigationItem];
        
        [self.navigationController.navigationBar setBarTintColor:rgba(41, 204, 169, 1)];
        

        canYao=YES;//不可以摇动
        [image1 removeFromSuperview];
        image1=nil;
        [image2 removeFromSuperview];
        image2=nil;
        [image3 removeFromSuperview];
        image3=nil;
        [image4 removeFromSuperview];
        image4=nil;
        [image5 removeFromSuperview];
        image5=nil;
        [image6 removeFromSuperview];
        image6=nil;
        
        [dong1 removeFromSuperview];
        dong1=nil;
        [dong2 removeFromSuperview];
        dong2=nil;
        [dong3 removeFromSuperview];
        dong3=nil;
        [dong4 removeFromSuperview];
        dong4=nil;
        [dong5 removeFromSuperview];
        dong5=nil;
        [dong6 removeFromSuperview];
        dong6=nil;
        
        [self.dawanView removeFromSuperview];
        self.dawanView=nil;
        
        UIButton *btn=(UIButton *)[self.view viewWithTag:107];
        if (btn) {
            [btn removeFromSuperview];
            btn=nil;
        }
        
        [self configShakeView];

        
    }
    
}


/**
*  跳转到添加事件
*/
-(void)pressLeftButton
{
    FoodViewController *food=[FoodViewController new];
    [self.navigationController pushViewController:food animated:YES];
}

/**
 *  跳转到历史事件
 */
-(void)pressRightButton
{
    
    HistoryViewController *history=[HistoryViewController new];
    [self.navigationController pushViewController:history animated:YES];
    
}

-(void)reFreshTitleWithIndex:(NSUInteger)index
{

    CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
    
    NSString *str;

    switch (index) {
        case 0:
            str=@"吃什么";
            break;
        case 1:
            str=@"掷色子";
            break;
    }
    
    SINavigationMenuView *menu = [[SINavigationMenuView alloc] initWithFrame:frame title:str];
    [menu displayMenuInView:self.navigationController.view];
    menu.items = @[@"吃什么",@"掷色子"];
    menu.delegate = self;
    self.navigationItem.titleView = menu;
}

@end
