//
//  ZFDownloadedCell.m
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//

#import "ZFDownloadedCell.h"

@interface ZFDownloadedCell()
{
    NSInteger imgHig;
}
@end

@implementation ZFDownloadedCell

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
        imgHig = 45;
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
    img.layer.cornerRadius = 5.0;
    img.layer.masksToBounds = YES;
    
    UILabel *nameLab = [[UILabel alloc] init];
    [self.contentView addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img.mas_right).offset(10);
        make.centerX.equalTo(self);
        make.centerY.equalTo(img).offset(-7);
    }];
    nameLab.textColor = colorTheme;
    nameLab.font = font13;
    
    UILabel *sizeLab = [[UILabel alloc] init];
    [self.contentView addSubview:sizeLab];
    [sizeLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(img);
    }];
    
    sizeLab.font = font11;
    sizeLab.textColor = colorSubtitle;
    
    self.fileNameLabel = nameLab;
    self.sizeLabel = sizeLab;
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
    
    NSString *totalSize = [ZFCommonHelper getFileSizeString:fileInfo.fileSize];
    self.sizeLabel.text = totalSize;

}


@end

