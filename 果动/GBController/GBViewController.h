//
//  GBViewController.h
//  果动
//
//  Created by mac on 15/9/7.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "GBTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIKit.h>
@interface GBViewController : UIViewController <AVAudioPlayerDelegate>
@property (nonatomic, retain) NSMutableArray* request;
@property (nonatomic, retain) UIImage* SLTImage;
@property (nonatomic, retain) NSString* isMy;
@property (nonatomic, retain) NSString* talkid;
@property (nonatomic, retain) NSString *replay_id, *info_id;
@property (nonatomic, retain) NSString *isNews, *news_talkid;
@property (nonatomic, retain) NSMutableArray* reportArray;
@property (nonatomic, retain) NSMutableArray* report_idArray;
@property (nonatomic, assign) GBTextFieldCell* (^createTextFieldCellBlock)(void);

@end
