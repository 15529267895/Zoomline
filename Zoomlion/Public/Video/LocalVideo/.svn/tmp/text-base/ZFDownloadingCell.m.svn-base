//
//  ZFDownloadingCell.m
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//


#import "ZFDownloadingCell.h"

@interface ZFDownloadingCell ()
{
    NSInteger imgHig;
}

@end

@implementation ZFDownloadingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initView];
    }
    return self;
}

- (void)initView
{
    if (isiPhone)
    {
        imgHig = 50;
    }
    else
    {
        imgHig = 90;
    }
    
    UIImageView *img = [[UIImageView alloc] init];
    [self.contentView addSubview:img];
    [img mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.height.offset(imgHig);
    }];
    
    img.image = [UIImage imageNamed:@"video_img"];
//    img.contentMode = UIViewContentModeScaleAspectFit;
    img.layer.cornerRadius = 5.0;
    img.layer.masksToBounds = YES;
    
    UIButton *stopBtn = [[UIButton alloc] init];
    [stopBtn setImage:[UIImage imageNamed:@"menu_pause"] forState:UIControlStateNormal];
    [stopBtn setImage:[UIImage imageNamed:@"menu_play"] forState:UIControlStateSelected];

    [stopBtn addTarget:self action:@selector(clickDownload:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:stopBtn];
    [stopBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(img);
        make.width.height.offset(50);
    }];
    
    UIProgressView *progress = [[UIProgressView alloc] init];
    [self.contentView addSubview:progress];
    [progress mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img.mas_right).offset(5);
        make.right.equalTo(stopBtn.mas_left).offset(-2);
        make.centerY.equalTo(img);
    }];
    
    _fileNameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_fileNameLabel];
    [_fileNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(progress);
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(img);
    }];
    _fileNameLabel.textColor = colorTheme;
    _fileNameLabel.font = font13;
    
    self.progressLabel = [UILabel new];
    [self.contentView addSubview:self.progressLabel];
    [self.progressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(progress);
        make.bottom.equalTo(img);
    }];
    
    UILabel *sizeLab = [[UILabel alloc] init];
    [self.contentView addSubview:sizeLab];
    [sizeLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(progress);
        make.centerY.equalTo(self.progressLabel);
    }];
    
    self.progressLabel.font = sizeLab.font = font11;
    self.progressLabel.textColor = sizeLab.textColor = colorSubtitle;
    
    self.speedLabel = sizeLab;
    _downloadBtn = stopBtn;
    self.progress = progress;
}

/**
 *  暂停、下载
 *
 *  @param sender UIButton
 */
- (void)clickDownload:(UIButton *)sender
{
    // 执行操作过程中应该禁止该按键的响应 否则会引起异常
    sender.userInteractionEnabled = NO;
    ZFFileModel *downFile = self.fileInfo;
    ZFDownloadManager *filedownmanage = [ZFDownloadManager sharedDownloadManager];
    if(downFile.downloadState == ZFDownloading) { //文件正在下载，点击之后暂停下载 有可能进入等待状态
        self.downloadBtn.selected = YES;
        [filedownmanage stopRequest:self.request];
    } else {
        self.downloadBtn.selected = NO;
        [filedownmanage resumeRequest:self.request];
    }
    
    // 暂停意味着这个Cell里的ASIHttprequest已被释放，要及时更新table的数据，使最新的ASIHttpreqst控制Cell
    if (self.btnClickBlock)
    {
        self.btnClickBlock();
    }
    sender.userInteractionEnabled = YES;
}

- (void)setFileInfo:(ZFFileModel *)fileInfo
{
    _fileInfo = fileInfo;

    NSString *str2 = [fileInfo.fileName stringByRemovingPercentEncoding];
   
    if ([str2 containsString:@".mp4?name="])
    {
        NSRange range = [str2 rangeOfString:@".mp4?name="];
        NSString *resultStr = [str2 substringFromIndex:range.location+10];
        self.fileNameLabel.text = resultStr;
    }else
    {
        self.fileNameLabel.text = str2;
    }
    
    // 服务器可能响应的慢，拿不到视频总长度 && 不是下载状态
    if ([fileInfo.fileSize longLongValue] == 0 && !(fileInfo.downloadState == ZFDownloading)) {
        self.progressLabel.text = @"";
        if (fileInfo.downloadState == ZFStopDownload) {
            self.speedLabel.text = @"已暂停";
        } else if (fileInfo.downloadState == ZFWillDownload) {
            self.downloadBtn.selected = YES;
            self.speedLabel.text = @"等待下载";
        }
        self.progress.progress = 0.0;
        return;
    }
    
    NSString *currentSize = [ZFCommonHelper getFileSizeString:fileInfo.fileReceivedSize];
    NSString *totalSize = [ZFCommonHelper getFileSizeString:fileInfo.fileSize];
    // 下载进度
    float progress = (float)[fileInfo.fileReceivedSize longLongValue] / [fileInfo.fileSize longLongValue];
    
    self.progressLabel.text = [NSString stringWithFormat:@"%@ / %@ (%.2f%%)",currentSize, totalSize, progress*100];
    
    self.progress.progress = progress;
    
     NSString *spped = [NSString stringWithFormat:@"%@/S",[ZFCommonHelper getFileSizeString:[NSString stringWithFormat:@"%lu",[ASIHTTPRequest averageBandwidthUsedPerSecond]]]];
    if (spped)
    {
        NSString *speed = [NSString stringWithFormat:@"%@",spped];
        self.speedLabel.text = speed;
    }
    else
    {
        self.speedLabel.text = @"正在获取";
    }

    if (fileInfo.downloadState == ZFDownloading) { //文件正在下载
        self.downloadBtn.selected = NO;
    } else if (fileInfo.downloadState == ZFStopDownload&&!fileInfo.error) {
        self.downloadBtn.selected = YES;
        self.speedLabel.text = @"已暂停";
    }else if (fileInfo.downloadState == ZFWillDownload&&!fileInfo.error) {
        self.downloadBtn.selected = YES;
        self.speedLabel.text = @"等待下载";
    } else if (fileInfo.error) {
        self.downloadBtn.selected = YES;
        self.speedLabel.text = @"错误";
    }
    
}



@end
