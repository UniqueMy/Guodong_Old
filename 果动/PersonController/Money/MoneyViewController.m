//
//  MoneyViewController.m
//  果动
//
//  Created by mac on 15/6/12.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "AppDelegate.h"

#import "HQGZViewController.h"

#import "LoginViewController.h"
#import "MainController.h"
#import "MingXiComment.h"
#import "MingXiTableViewCell.h"
#import "MoneyViewController.h"
#import "SYJLViewController.h"
#import <ShareSDK/ShareSDK.h>
@interface MoneyViewController () <UIAlertViewDelegate> {
    UILabel* numberLabel;
    UILabel* label;
    UITableView* _tableView;
    UILabel* noMoneyLabel;
    UIButton* shareButton;
    BOOL isshare;
}
@end

@implementation MoneyViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self createView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    self.navigationItem.titleView = [HeadComment titleLabeltext:@"私房钱"];
    BackView* backView = [[BackView alloc] initWithbacktitle:@"个人" viewController:self];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = backItem;
    self.title = @"私房钱";
}

- (void)createView
{
    UIView* baseImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, Adaptive(240))];
    baseImage.backgroundColor = [UIColor colorWithRed:127 / 255.0 green:127 / 255.0 blue:127 / 255.0 alpha:1];
    [self.view addSubview:baseImage];

    UIView* numberView = [[UIView alloc] initWithFrame:CGRectMake((baseImage.bounds.size.width - Adaptive(100)) / 2, (baseImage.bounds.size.height - Adaptive(100)) / 3, Adaptive(100), Adaptive(100))];
    numberView.layer.cornerRadius = numberView.bounds.size.width / 2;
    numberView.layer.masksToBounds = YES;
    numberView.backgroundColor = [UIColor orangeColor];
    [baseImage addSubview:numberView];

    numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (numberView.bounds.size.height - Adaptive(30)) / 2, numberView.bounds.size.width, Adaptive(30))];
    numberLabel.font = [UIFont fontWithName:FONT size:Adaptive(25)];
    numberLabel.textAlignment = 1;
    numberLabel.text = @"0";
    numberLabel.textColor = [UIColor whiteColor];
    [numberView addSubview:numberLabel];

    UILabel* gonglabel = [[UILabel alloc] initWithFrame:CGRectMake((numberView.bounds.size.width - Adaptive(15)) / 2, CGRectGetMinY(numberLabel.frame) - Adaptive(15), Adaptive(15), Adaptive(10))];
    gonglabel.text = @"共";
    gonglabel.textColor = [UIColor whiteColor];
    gonglabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:Adaptive(14)];
    [numberView addSubview:gonglabel];

    UIButton* HQGZButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    HQGZButton.frame = CGRectMake(baseImage.bounds.size.width / 6, CGRectGetMaxY(numberView.frame) + Adaptive(10), Adaptive(102), Adaptive(33));
    [HQGZButton addTarget:self action:@selector(hqgzButton) forControlEvents:UIControlEventTouchUpInside];
    [HQGZButton setBackgroundImage:[UIImage imageNamed:@"money_hqgz"] forState:UIControlStateNormal];
    [baseImage addSubview:HQGZButton];

    UIButton* SYJLButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    SYJLButton.frame = CGRectMake(baseImage.bounds.size.width - baseImage.bounds.size.width / 6 - Adaptive(102), CGRectGetMaxY(numberView.frame) + Adaptive(10), Adaptive(102),Adaptive(33));
    [SYJLButton addTarget:self action:@selector(syjlButton) forControlEvents:UIControlEventTouchUpInside];
    [SYJLButton setBackgroundImage:[UIImage imageNamed:@"money_syjl"] forState:UIControlStateNormal];
    [baseImage addSubview:SYJLButton];

    UILabel* noMoneyLabelTop = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetMaxY(baseImage.frame) + Adaptive(100)), viewWidth, Adaptive(20))];
    noMoneyLabelTop.textColor = [UIColor whiteColor];
    noMoneyLabelTop.text = @"您还没有可使用的私房钱噢~";
    noMoneyLabelTop.textAlignment = 1;
    noMoneyLabelTop.font = [UIFont fontWithName:FONT size:Adaptive(20)];

    noMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(noMoneyLabelTop.frame) + Adaptive(17.5), viewWidth, Adaptive(15))];
    noMoneyLabel.textColor = [UIColor colorWithRed:94 / 255.0 green:94 / 255.0 blue:94 / 255.0 alpha:1];
    noMoneyLabel.text = @"首次分享,就可获得私房钱啦!";
    noMoneyLabel.textAlignment = 1;
    noMoneyLabel.font = [UIFont fontWithName:FONT size:Adaptive(15)];

    shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shareButton.frame = CGRectMake((viewWidth - Adaptive(99)) / 2, CGRectGetMaxY(noMoneyLabel.frame) + Adaptive(32.5), Adaptive(99), Adaptive(30));
    [shareButton setBackgroundImage:[UIImage imageNamed:@"money_share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButton) forControlEvents:UIControlEventTouchUpInside];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(baseImage.frame) + 1, viewWidth, viewHeight - baseImage.bounds.size.height - 1 - NavigationBar_Height) style:UITableViewStylePlain];
    _tableView.rowHeight = Adaptive(70);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = BASECOLOR;
    // 设置单元格的分割样式
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];

    NSString* url = [NSString stringWithFormat:@"%@api/?method=gdmoney.mymoney", BASEURL];
    [HttpTool postWithUrl:url params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        if (ResponseObject_RC == 0) {
            NSDictionary* data = [responseObject objectForKey:@"data"];
            NSArray* cons = [data objectForKey:@"cons"];
            numberLabel.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"banlance"]];
            if (cons.count == 0) {
                SYJLButton.userInteractionEnabled = NO;
                [SYJLButton setBackgroundImage:[UIImage imageNamed:@"money_nosyjl"] forState:UIControlStateNormal];
            }
            else {
                SYJLButton.userInteractionEnabled = YES;
                [SYJLButton setBackgroundImage:[UIImage imageNamed:@"money_syjl"] forState:UIControlStateNormal];
            }
            if ([[data objectForKey:@"banlance"] intValue] == 0) {

                if ([[data objectForKey:@"isshared"] intValue] != 0) {
                    noMoneyLabel.text = @"上满三次课,就可以获得私房钱啦!";
                    [shareButton setBackgroundImage:[UIImage imageNamed:@"money_dingke"] forState:UIControlStateNormal];
                    isshare = YES;
                }

                [self.view addSubview:noMoneyLabelTop];
                [self.view addSubview:noMoneyLabel];
                [self.view addSubview:shareButton];
            }
            else {
                [noMoneyLabelTop removeFromSuperview];
                [noMoneyLabel removeFromSuperview];
                [shareButton removeFromSuperview];

                self.request = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary* dict in cons) {
                    MingXiComment* mingxi = [[MingXiComment alloc] initWithDictionary:dict];
                    if ([mingxi.code isEqualToString:@"0"]) {
                        [self.request addObject:mingxi];
                    }
                }
                [_tableView reloadData];
            }
        }
        else if (ResponseObject_RC == NotLogin_RC_Number) {
            [HeadComment message:@"您还没有登录呢！" delegate:self witchCancelButtonTitle:@"暂不" otherButtonTitles:@"去登录", nil];
        }
        else {
            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    }
        fail:^(NSError* error){
        }];
}
- (void)shareButton
{
    if (!isshare) {
        /*	@param 	content 	分享内容（新浪、腾讯、网易、搜狐、豆瓣、人人、开心、有道云笔记、facebook、twitter、邮件、打印、短信、微信、QQ、拷贝）
         *	@param 	defaultContent 	默认分享内容（新浪、腾讯、网易、搜狐、豆瓣、人人、开心、有道云笔记、facebook、twitter、邮件、打印、短信、微信、QQ、拷贝）
         *	@param 	image 	分享图片（新浪、腾讯、网易、搜狐、豆瓣、人人、开心、facebook、twitter、邮件、打印、微信、QQ、拷贝、短信）
         *	@param 	title 	标题（QQ空间、人人、微信、QQ）
         *	@param 	url 	链接（QQ空间、人人、instapaper、微信、QQ）
         *	@param 	description 	主体内容（人人）
         *	@param 	mediaType 	分享类型（QQ、微信）
         *	@param 	locationCoordinate 	地理位置 (新浪、腾讯、Twitter)
         */

        NSString* imagePath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:@"http://itunes.apple.com/cn/app/guo-dong/id998425416?l=en&mt=8" //分享内容
                                           defaultContent:@"果动网络" //默认分享内容
                                                    image:[ShareSDK imageWithPath:imagePath] //分享图片
                                                    title:@"果动网络" //标题
                                                      url:XiaZaiConnent //链接
                                              description:@"果动网络" //主体内容
                                                mediaType:SSPublishContentMediaTypeNews]; //分享类型

        //创建弹出菜单容器
        id<ISSContainer> container = [ShareSDK container];

        /*container 	用于显示分享界面的容器，如果只显示在iPhone客户端可以传入nil。如果需要在iPad上显示需要指定容器。
         *	@param 	shareList 	平台类型列表
         *	@param 	content 	分享内容
         *  @param  statusBarTips   状态栏提示标识：YES：显示； NO：隐藏
         *  @param  authOptions 授权选项，用于指定接口在需要授权时的一些属性（如：是否自动授权，授权视图样式等），默认可传入nil
         *  @param  shareOptions    分享选项，用于定义分享视图部分属性（如：标题、一键分享列表、功能按钮等）,默认可传入nil
         *  @param  targets         自定义标识集合，设置自定义标识可以在管理后台查看相关标识的分享统计数据
         *  @param  result  分享返回事件处理*/

        //弹出分享菜单
        [ShareSDK showShareActionSheet:container
                             shareList:nil
                               content:publishContent
                         statusBarTips:YES
                           authOptions:nil
                          shareOptions:nil
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    NSLog(@"status  %u", state);

                                    if (state == SSResponseStateBegan) {

                                        //    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                        NSLog(@"statusInfo  %@", statusInfo);

                                        NSString* url = [NSString stringWithFormat:@"%@api/?method=user.share", BASEURL];
                                        NSDate* date = [NSDate date];
                                        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                                        [formatter setDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];

                                        NSString* string = [formatter stringFromDate:date];
                                        NSDate* date1 = [formatter dateFromString:string];
                                        NSString* timeSp = [NSString stringWithFormat:@"%ld", (long)[date1 timeIntervalSince1970]];

                                        NSDictionary* dict = @{ @"platform" : @"wx",
                                            @"date" : timeSp };
                                        [HttpTool postWithUrl:url params:dict contentType:CONTENTTYPE success:^(id responseObject) {
                                            if (ResponseObject_RC == 0) {
                                                NSDictionary* data = [responseObject objectForKey:@"data"];
                                                if (data) {
                                                    NSString* info = [data objectForKey:@"info"];
                                                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:info delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];

                                                    [alert show];
                                                }
                                            }
                                            else {
                                                [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
                                            }
                                        }
                                            fail:^(NSError* error){
                                            }];
                                    }
                                    else if (state == SSResponseStateFail) {
                                        NSLog(@"发布失败!error code == %ld, error code == %@", (long)[error errorCode], [error errorDescription]);
                                    }
                                }];
    }
    else {
        MainController* main = [MainController new];
        AppDelegate* app = [UIApplication sharedApplication].delegate;
        app.window.rootViewController = main;
    }
}
- (void)hqgzButton
{
    HQGZViewController* hqgz = [HQGZViewController new];
    [self.navigationController pushViewController:hqgz animated:YES];
}
- (void)syjlButton
{
    SYJLViewController* syjl = [SYJLViewController new];
    [self.navigationController pushViewController:syjl animated:YES];
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.request.count;
}

// 设置单元格的内容的
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    //1,定义一个重用标示符
    static NSString* cellIdentifier = @"Cell";

    //2,从队列中出列一个可以重用的单元格
    MingXiTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    //3,
    if (!cell) {
        cell = [[MingXiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MingXiComment* mingxi = [self.request objectAtIndex:indexPath.row];
    cell.numberLabel.text = mingxi.money;
    cell.titleLabel.text = mingxi.types;
    // 时间戳转时间的方法:
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate* confromTimesp = [NSDate dateWithTimeIntervalSince1970:[mingxi.time intValue]];
    //  NSLog(@"1296035591  = %@",confromTimesp);
    NSString* confromTimespStr = [formatter stringFromDate:confromTimesp];
    cell.timeLabel.text = confromTimespStr;

    if ([mingxi.code intValue] == 1) {
        cell.biaozhi.image = [UIImage imageNamed:@"MingXi_xiaofei"];
        cell.numberImage.image = [UIImage imageNamed:@"mingxi_fouseimage"];
        cell.numberLabel.textColor = [UIColor colorWithRed:177.00 / 255 green:177.00 / 255 blue:174.00 / 255 alpha:1];
    }
    else if ([mingxi.code intValue] == 2) {
        cell.biaozhi.image = [UIImage imageNamed:@"MingXi_guoqi"];
        cell.numberImage.image = [UIImage imageNamed:@"mingxi_fouseimage"];
        cell.numberLabel.textColor = [UIColor colorWithRed:177.00 / 255 green:177.00 / 255 blue:174.00 / 255 alpha:1];
    }
    else {
        cell.numberImage.image = [UIImage imageNamed:@"mingxi_tureimage"];
        cell.biaozhi.image = [UIImage imageNamed:@""];
        cell.numberLabel.textColor = [UIColor colorWithRed:226.00 / 255 green:160.00 / 255 blue:48.00 / 255 alpha:1];
    }

    return cell;
}
//选中单元格的时候调用
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    }
}

@end
