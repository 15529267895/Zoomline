//
//  LoginViewController.m
//  Zoomlion
//
//  Created by 王li on 2017/11/12.
//  Copyright © 2017年 wli. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"

@interface LoginViewController ()
{
    UIImageView *img, *psdImg, *userImg;
    UIView *psdView, *useView;
    UITextField *psdTF, *userTf;
    UIButton *selectBtn, *loginBtn;
    UILabel *agreementLab;
    int viewHig;
}

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *leftImg;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation LoginViewController

- (UIView *)contentView
{
    _contentView = [UIView new];
    [self.view addSubview:_contentView];
    _contentView.backgroundColor = colorWhite;

    return _contentView;
}
- (UIImageView *)leftImg
{
    _leftImg = [UIImageView new];
    _leftImg.contentMode = UIViewContentModeScaleAspectFit;

    return _leftImg;
}
- (UITextField *)textField
{
    _textField = [UITextField new];
    _textField.font = font15;
    _textField.textColor = colorTitle;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
    return _textField;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configView];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self updateOrientation];
    
    if (isiPad)
    {
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(updateOrientation)
                                                    name:UIDeviceOrientationDidChangeNotification object:nil];
    }
}
#pragma mark - 旋转方向
// 设备支持方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (isiPad)
    {
        return UIInterfaceOrientationMaskAll;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}
// 默认方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait; // 或者其他值 balabala~
}

// 开启自动转屏
- (BOOL)shouldAutorotate
{
    if (isiPad)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - 屏幕
- (void)updateOrientation
{
    [img mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    [psdView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.centerY.equalTo(self.view.mas_centerY).offset(-65);
        make.height.offset(viewHig);
    }];
    
    [psdImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(psdView.mas_centerY);
        make.width.offset(40);
        make.left.equalTo(psdView.mas_left);
    }];
    
    [psdTF mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(psdImg.mas_right);
        make.top.bottom.right.equalTo(psdView);
    }];
    
    [useView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(psdView);
        make.bottom.equalTo(psdView.mas_top).offset(-15);
    }];
    
    [userImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(useView.mas_centerY);
        make.width.equalTo(psdImg);
        make.left.equalTo(useView.mas_left);
    }];
    
    [userTf mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(psdTF);
        make.top.bottom.right.equalTo(useView);
    }];
    
    [selectBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(psdView);
        make.top.equalTo(psdView.mas_bottom).offset(10);
        make.width.height.offset(18);
    }];
    
    [agreementLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectBtn.mas_right).offset(10);
        make.centerY.equalTo(selectBtn);
    }];
    
    [loginBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(useView);
        make.top.equalTo(selectBtn.mas_bottom).offset(30);
        make.height.equalTo(psdView);
    }];
}


- (void)configView
{
    if (isiPhone)
    {
        viewHig = 45;
    }
    else
    {
        viewHig = 65;
    }
    
    img = [UIImageView new];
    [self.view addSubview:img];
    img.image = [UIImage imageNamed:@"sign-in-bg"];
    [img mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    img.contentMode = UIViewContentModeScaleToFill;
    
    psdView = self.contentView;
    
    
    psdImg = self.leftImg;
    [psdView addSubview:psdImg];
    
    psdImg.image = [UIImage imageNamed:@"psd"];
    
    psdTF = self.textField;
    [psdView addSubview:psdTF];
    
    [[psdTF rac_textSignal] subscribeNext:^(id x) {
        WWLog(@"%@=====pasd",x);
    }];
    [[psdTF rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x) {
        WWLog(@"psd编辑变化的值为：%@",x);
    }];
    
    psdTF.placeholder = @"请输入密码";
    psdTF.secureTextEntry = YES;
    
    useView = self.contentView;
    
    
    userImg = self.leftImg;
    [useView addSubview:userImg];
    
    userImg.image = [UIImage imageNamed:@"user"];
    
    userTf = self.textField;
    [useView addSubview:userTf];
    
    userTf.keyboardType = UIKeyboardTypeNamePhonePad;
    [[userTf rac_textSignal] subscribeNext:^(id x) {
        WWLog(@"输出改变后的变化===%@",x);
    }];
    [[userTf rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x) {
        WWLog(@"%@====改变职位：",x);
    }];
    
    userTf.placeholder = @"请输入用户名";
    selectBtn = [UIButton new];
    [self.view addSubview:selectBtn];
    
    [selectBtn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateSelected];
    [selectBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    [[selectBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        selectBtn.selected = !selectBtn.selected;
    }];
    
    agreementLab= [UILabel new];
    [self.view addSubview:agreementLab];
    
    agreementLab.text = @"记住密码";
    agreementLab.textColor = colorWhite;
    agreementLab.font = font13;
    
    loginBtn = [UIButton new];
    [self.view addSubview:loginBtn];
    
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.backgroundColor = colorTheme;
    loginBtn.titleLabel.font = font17;
    [loginBtn setTitleColor:colorWhite forState:UIControlStateNormal];
   
    NSDictionary *me = [USERCENTERMANAGER getLoginUser];
    if (me.count != 0)
    {
        userTf.text = me[KName];
        psdTF.text = me[KPassword];
    }
    
    [[loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x)
    {
        [self.view endEditing:YES];
        if (userTf.text.length <= 0)
        {
            [Common showMessage:@"请输入昵称"];
            return ;
        }
        if (psdTF.text.length <= 0)
        {
            [Common showMessage:@"请输入密码"];
            return ;
        }
        [WLAFNetwork POSTNoToken:urlLogin param:@{@"uName":userTf.text,@"uPass":psdTF.text} success:^(id responseObject)
        {
            if ([responseObject[@"code"] intValue] == 1)
            {
                NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"data"]];
//                UserModel *user = [UserModel shareModel];
//                [user setValueForDict:responseObject[@"data"]];
                [[NSUserDefaults standardUserDefaults] setValue:dataDic[@"token"] forKey:@"token"];
             
                [USERCENTERMANAGER saveLoginUser:dataDic];
                
                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:[HomeViewController new]];
                [self.navigationController presentViewController:navi animated:YES completion:nil];
            }
        } failure:^(NSError *error)
        {
          
        }];
    }];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
