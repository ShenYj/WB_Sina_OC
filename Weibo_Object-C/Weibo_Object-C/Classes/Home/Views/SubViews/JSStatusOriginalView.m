//
//  JSStatusOriginalView.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/21.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSStatusOriginalView.h"
#import "JSHomeStatusModel.h"
#import "JSHomeStatusUserModel.h"
#import "JSPictureView.h"
#import "JSTextLabel.h"
//#import "RegexKitLite.h"
//#import "JSEmoticonTool.h"
//#import "JSEmoticonModel.h"
//#import "JSMatchResultModel.h"
//#import "JSEmoticonTextAttachment.h"

#pragma mark
#pragma mark -- Magic Number  (引用JSHomeStatusModel中的常量)
extern CGFloat const kHeadImageViewSize;
extern CGFloat kMargin;
extern CGFloat kUserStatusImageViewSize;
extern CGFloat kOriginalContentLabelFontSize;


@interface JSStatusOriginalView () <JSTextLabelDelegate>

// 用户头像
@property (nonatomic) UIImageView *headImageView;
// 用户昵称
@property (nonatomic) UILabel *userNickNameLabel;
// 用户等级
@property (nonatomic) UIImageView *userExpiredImageView;
// 发布微博事件
@property (nonatomic) UILabel *timeLabel;
// 微博来源
@property (nonatomic) UILabel *sourceLabel;
// 认证图片
@property (nonatomic) UIImageView *avatarImageView;
// 微博内容
@property (nonatomic) JSTextLabel *contentLabel;
// 用户在线状态
@property (nonatomic) UIImageView *userStatusImageView;
// 配图
@property (nonatomic) JSPictureView *pictureView;
// 记录原创微博的底边约束
@property (nonatomic) MASConstraint *selfBottomConstraint;

@end

@implementation JSStatusOriginalView

- (instancetype)init {
    self = [super init];
    if (self) {
    
        [self prepareView];
    }
    return self;
}

#pragma mark
#pragma mark - set up UI
- (void)prepareView {
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.headImageView];
    [self addSubview:self.userNickNameLabel];
    [self addSubview:self.userExpiredImageView];
    [self addSubview:self.userStatusImageView];
    [self addSubview:self.timeLabel];
    [self addSubview:self.sourceLabel];
    [self addSubview:self.avatarImageView];
    [self addSubview:self.contentLabel];
    [self addSubview:self.pictureView];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self).mas_offset(kMargin);
        make.size.mas_equalTo(CGSizeMake(kHeadImageViewSize, kHeadImageViewSize));
    }];
    
    [self.userNickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_right).mas_offset(kMargin);
        make.top.mas_equalTo(self.headImageView);
    }];
    
    [self.userExpiredImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userNickNameLabel.mas_right).mas_offset(kMargin);
        make.centerY.mas_equalTo(self.userNickNameLabel);
    }];
    
    [self.userStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userExpiredImageView.mas_right).mas_offset(kMargin);
        make.size.mas_equalTo(CGSizeMake(kUserStatusImageViewSize, kUserStatusImageViewSize));
        make.centerY.mas_equalTo(self.userNickNameLabel);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_right).mas_offset(kMargin);
        make.bottom.mas_equalTo(self.headImageView);
    }];
    
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLabel.mas_right).mas_offset(kMargin);
        make.centerY.mas_equalTo(self.timeLabel);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headImageView.mas_right);
        make.centerY.mas_equalTo(self.headImageView.mas_bottom);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView);
        make.top.mas_equalTo(self.headImageView.mas_bottom).mas_offset(kMargin);
        // 通过Label的preferredMaxLayoutWidth属性限制宽度
        //make.right.mas_equalTo(self).mas_offset(-kMargin);
    }];
    
    [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).mas_offset(kMargin);
        make.left.mas_equalTo(self.contentLabel);
        //make.size.mas_equalTo(CGSizeMake(100, 100));迁移到PictureView内部进行约束
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        self.selfBottomConstraint = make.bottom.mas_equalTo(self.pictureView).mas_offset(kMargin);
    }];
    
}

#pragma mark
#pragma mark - set up data & update self bottom constraint

- (void)setStatusData:(JSHomeStatusModel *)statusData {
    
    _statusData = statusData;
    
    // 用户昵称
    self.userNickNameLabel.text = statusData.user.name;
    
    // 用户头像
//    [self.headImageView js_setImageWithURL:statusData.user.profile_image_url
//                               placeholder:nil
//                              expectedSize:CGSizeMake(kHeadImageViewSize, kHeadImageViewSize)
//                                 fillColor:self.backgroundColor];
    
    
//    [self.headImageView yy_setImageWithURL:[NSURL URLWithString:statusData.user.profile_image_url]
//                               placeholder:nil
//                                   options:YYWebImageOptionSetImageWithFadeAnimation
//                                   manager:nil
//                                  progress:nil
//                                 transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
//        image = [[image yy_imageByResizeToSize:CGSizeMake(kHeadImageViewSize, kHeadImageViewSize) contentMode:UIViewContentModeCenter] yy_imageByRoundCornerRadius:kHeadImageViewSize*0.5];
//        return image;
//    } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//        __weak typeof(self) weakSelf = self;
//        if (kHeadImageViewSize > image.size.width || kHeadImageViewSize > image.size.height) {
//            
//        } else {
//            [image js_cornerImageWithSize:CGSizeMake(kHeadImageViewSize, kHeadImageViewSize) fillClolor:[UIColor whiteColor] completion:^(UIImage *img) {
//                weakSelf.headImageView.image = img;
//            }];
//        }
//    }];
    
    
    
    __weak typeof(self) weakSelf = self;
    [self.headImageView js_imageUrlString:statusData.user.profile_image_url withPlaceHolderImage:nil WithSize:CGSizeMake(kHeadImageViewSize, kHeadImageViewSize) fillClolor:[UIColor whiteColor] completion:^(UIImage *img) {
        weakSelf.headImageView.image = img;
    }];
    
    // 微博来源
    self.sourceLabel.attributedText = statusData.sourceString;
    
    // 时间
    self.timeLabel.text = statusData.created_at_formatterString;
    
    // 微博内容
    self.contentLabel.attributedText = statusData.attributedString;
    
    // 用户状态(在线/离线)
    UserStatus status = statusData.user.userstatus;
    if (status == UserStatusOnline) {
        
        self.userStatusImageView.hidden = NO;
    } else {
        
        self.userStatusImageView.hidden = YES;
    }
    
    // 根据是否有配图,更新原创微博自身底部约束
    // 卸载约束
    [self.selfBottomConstraint uninstall];
    //有配图 赋值数据
    self.pictureView.statusData = statusData;
    
    if (statusData.pic_urls) {
        
        // 显示配图视图
        self.pictureView.hidden = NO;
        
        //self.pictureView.pictures = statusData.pic_urls;
        
        // 更新约束
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            self.selfBottomConstraint = make.bottom.mas_equalTo(self.pictureView).mas_offset(kMargin);
        }];
        
    } else {
        
        // 隐藏配图视图
        self.pictureView.hidden = YES;
        
        //没有配图
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            self.selfBottomConstraint = make.bottom.mas_equalTo(self.contentLabel).mas_offset(kMargin);
        }];
        
    }
    
    // 设置用户等级标识 认证类型 -1:没有认证,0:认证用户,2.3.5:企业认证, 220:达人
    switch (statusData.user.verified_type.intValue) {
        case -1:
            self.avatarImageView.image = nil;
            break;
        case 0:
            self.avatarImageView.image = [UIImage imageNamed:@"avatar_vip"];
            break;
        case 2:
        case 3:
        case 5:
            self.avatarImageView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
        case 220:
            self.avatarImageView.image = [UIImage imageNamed:@"avatar_grassroot"];
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark - 将微博内容转成富文本
//- (NSMutableAttributedString *)getWeiBoAttributedText:(NSString *)originalText {
//    
//    // 可变临时数组
//    NSMutableArray *tempArr = [NSMutableArray array];
//    
//    // 将微博内容转换成富文本
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:originalText];
//    
//    // 正则表达式遍历  \[\]
//    [originalText enumerateStringsMatchedByRegex:@"\\[[A-Za-z0-9\\u4E00-\\u9FA5]+\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
//        
//        JSEmoticonModel *emoticonModel = [[JSEmoticonTool shared] searchEmoticonChs:*capturedStrings];
//        if (emoticonModel) {
//            // 存在图片表情
//            
//            // 创建模型对象
//            JSMatchResultModel *resultModel = [[JSMatchResultModel alloc] initWithResult:*capturedStrings withRange:*capturedRanges];
//            // 添加到可变数组
//            [tempArr addObject:resultModel];
//            
//        }
//        
//    }];
//    
//    // 倒序遍历模型数组 (直接遍历富文本进行转换,会造成数组越界)
//    [tempArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        // 匹配结果模型对象
//        JSMatchResultModel *matchModel = (JSMatchResultModel *)obj;
//        // 通过表情描述遍历查找表情模型
//        JSEmoticonModel *emoticonModel = [[JSEmoticonTool shared] searchEmoticonChs:matchModel.result];
//        
//        // 实例化文本附件
//        JSEmoticonTextAttachment *textAttachment = [[JSEmoticonTextAttachment alloc] init];
//        // 设置属性
//        NSString *imageName = [NSString stringWithFormat:@"%@/%@",emoticonModel.path,emoticonModel.png];
//        textAttachment.image = [UIImage imageNamed:imageName inBundle:[JSEmoticonTool shared].emoticonsBundle compatibleWithTraitCollection:nil];
//        textAttachment.bounds = CGRectMake(0, -4, self.contentLabel.font.lineHeight, self.contentLabel.font.lineHeight);
//        
//        NSAttributedString *attributedStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
//        
//        [attributedString replaceCharactersInRange:matchModel.range withAttributedString:attributedStr];
//        
//    }];
//    
//    // 返回富文本
//    return attributedString;
//    
//}

#pragma mark
#pragma mark - JSTextLabelDelegate

- (void)textLabel:(JSTextLabel *)textLabel withClickTextStorageString:(NSString *)string {
    
    if (self.urlTextCompeletionHandler) {
        self.urlTextCompeletionHandler(string);
    }
}



#pragma mark
#pragma mark - lazy

- (UIImageView *)headImageView {
    
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.image = [UIImage imageNamed:@"avatar_default_small"];
    }
    return _headImageView;
}

- (UILabel *)userNickNameLabel {
    
    if (_userNickNameLabel == nil) {
        _userNickNameLabel = [[UILabel alloc] init];
        _userNickNameLabel.font = [UIFont systemFontOfSize:15];
        _userNickNameLabel.textColor = [UIColor purpleColor];
    }
    return _userNickNameLabel;
}

- (UIImageView *)userExpiredImageView {
    
    if (_userExpiredImageView == nil) {
        _userExpiredImageView = [[UIImageView alloc] init];
        _userExpiredImageView.image = [UIImage imageNamed:@"common_icon_membership_expired"];
    }
    return _userExpiredImageView;
}

- (UILabel *)timeLabel {
    
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = THEME_COLOR;
    }
    return _timeLabel;
}

- (UILabel *)sourceLabel {
    
    if (_sourceLabel == nil) {
        _sourceLabel = [[UILabel alloc] init];
        _sourceLabel.font = [UIFont systemFontOfSize:10];
        _sourceLabel.textColor = [UIColor lightGrayColor];
    }
    return _sourceLabel;
}

- (UIImageView *)avatarImageView {
    
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        //_avatarImageView.image = [UIImage imageNamed:@"avatar_vip"];
    }
    return _avatarImageView;
}

- (JSTextLabel *)contentLabel {
    
    if (_contentLabel == nil) {
        _contentLabel = [[JSTextLabel alloc] init];
        _contentLabel.delegate = self;
        _contentLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 2 * kMargin;
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:kOriginalContentLabelFontSize];
    }
    return _contentLabel;
}

- (UIImageView *)userStatusImageView {
    
    if (_userStatusImageView == nil) {
        _userStatusImageView = [[UIImageView alloc] init];
        [[UIImage imageNamed:@"v2_selected"] js_cornerImageWithSize:CGSizeMake(kUserStatusImageViewSize, kUserStatusImageViewSize) fillClolor:[UIColor whiteColor] completion:^(UIImage *img) {
            _userStatusImageView.image = img;
        }];

    }
    return _userStatusImageView;
}

- (JSPictureView *)pictureView {
    
    if (_pictureView == nil) {
        _pictureView = [[JSPictureView alloc] init];
    }
    return _pictureView;
}

@end
