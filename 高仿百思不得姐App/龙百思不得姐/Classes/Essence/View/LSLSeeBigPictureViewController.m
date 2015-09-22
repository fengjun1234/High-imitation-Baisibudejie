//
//  LSLSeeBigPictureViewController.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/16.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLSeeBigPictureViewController.h"
#import "LSLTopic.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <DACircularProgress/DALabeledCircularProgressView.h>
#import <SVProgressHUD.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface LSLSeeBigPictureViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;
/** 图片 */
@property(nonatomic,weak)UIImageView *imageView;
/** 图片文件 */
@property(nonatomic,strong)ALAssetsLibrary *library;
@end

@implementation LSLSeeBigPictureViewController
#pragma mark - 懒加载
- (ALAssetsLibrary *)library
{
    if (!_library) {
        _library = [[ALAssetsLibrary alloc] init];
    }
    return _library;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.frame = [UIScreen mainScreen].bounds;
    scrollView.backgroundColor = [UIColor blackColor];
    [self.view insertSubview:scrollView atIndex:0];
    
    // 创建显示图片
    UIImageView *imageView = [[UIImageView alloc] init];
    
    LSLWeakSelf;
    // 内容图片
    [imageView sd_setImageWithURL:[NSURL URLWithString:weakSelf.topic.image1] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        weakSelf.progressView.hidden = NO;
        weakSelf.progressView.roundedCorners =5;
        weakSelf.progressView.progress = 1.0 * receivedSize / expectedSize;
        
        weakSelf.progressView.progressLabel.textColor = [UIColor whiteColor];
        weakSelf.progressView.progressLabel.text = [NSString stringWithFormat:@"%.1f%%",100.0 * weakSelf.progressView.progress];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        weakSelf.progressView.hidden = YES;
    }];
    
    [scrollView addSubview:imageView];
    self.imageView = imageView;
    
    // 设置尺寸和位置
    imageView.x = 0;
    imageView.width = LSLScreenWidth;
    imageView.height = self.topic.height * imageView.width / self.topic.width;
    if (imageView.height > LSLScreenHeight) { // 是大图片
        imageView.y = 0;
        scrollView.contentSize = CGSizeMake(0, imageView.height);
    }else{
        imageView.centerY = LSLScreenHeight * 0.5;
    }
    
    // 拉伸
    CGFloat maxScale = self.topic.height / imageView.height;
    if (maxScale > 1.0) {
        scrollView.maximumZoomScale = maxScale;
    }
}

#pragma mark - 保存图片
static NSString * const LSLDefaultGroupName = @"龙百思不得姐";
static NSString * const LSLGroupNameKey = @"LSLGroupNameKey";
// 从沙盒中获取相册文件名
- (NSString *)getGropName
{
    NSString *groupName = [[NSUserDefaults standardUserDefaults] stringForKey:LSLGroupNameKey];
    if (groupName == nil) {
        groupName = LSLDefaultGroupName;
        
        // 把文件名保存到沙盒中
        [[NSUserDefaults standardUserDefaults] setObject:groupName forKey:LSLGroupNameKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return groupName;
}

/**
 *  保存图片
 *  思路分析：
 *   1>首先创建一个保存图片的文件
 *   2>然后判断文件是否创建成功，如果创建成功则直接保存图片（先把图片保存到【相册胶卷】中，在保存到自定义相册文件夹中）。
 *   3>假如文件创建失败，即文件已经存在。那么遍历相册中的所有文件，当找到以前创建的文件夹，图片保存，如果
     文件夹被用户删了，则特殊处理文件夹名（一般在文件夹名后加一个空格），重写创建一个文件夹，再保存图片。
 */
- (IBAction)save:(id)sender {
    // 获得文件夹的名字
    __block NSString *groupName = [self getGropName];
    
    __weak ALAssetsLibrary *weakLibrary = self.library;
    
    __weak typeof(self) weakSelf = self;
    // 1.先参加一个文件
    [weakLibrary addAssetsGroupAlbumWithName:groupName resultBlock:^(ALAssetsGroup *group) {
        if (group) {  // 2.创建文件成功
            // 保存图片到文件夹中
            [weakSelf saveImageToGroup:group];
        }else{  // 3.文件夹已经存在
            // 遍历所有文件夹
            [weakLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
                if ([name isEqualToString:groupName]) { // 是自己创建的文件夹
                    // 保存图片到文件夹中
                    [weakSelf saveImageToGroup:group];
                    *stop = YES;
                }else if( [name isEqualToString:@"Camera Roll"]){   //  根据遍历的规律，一般先遍历用户创建的文件夹最后遍历系统自带的文件夹“Camera Roll”和“null”即删除文件夹。当判断走到这里的时候，如果文件夹名等于@"Camera Roll"那么表示，系统默认相册文件夹被用户删除了，需重写创建。
                    // 系统默认文件夹被用户删除
                    groupName = [groupName stringByAppendingString:@" "];
                    
                    // 把文件名保存到沙盒中
                    [[NSUserDefaults standardUserDefaults] setObject:groupName forKey:LSLGroupNameKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    // 创建图片文件夹
                    [weakLibrary addAssetsGroupAlbumWithName:groupName resultBlock:^(ALAssetsGroup *group) {
                        // 保存图片
                        [weakSelf saveImageToGroup:group];
                    } failureBlock:nil];
                }
            } failureBlock:nil];
        }
    } failureBlock:nil];
}

// 保存图片到相册中
- (void)saveImageToGroup:(ALAssetsGroup *)group
{
   __weak ALAssetsLibrary *weakLibrary = self.library;
    
    // 先把图片保存到【相册胶卷】中
    [weakLibrary writeImageToSavedPhotosAlbum:self.imageView.image.CGImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        // 再把图片保存到对于的文件中
        [weakLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            [group addAsset:asset];
            [SVProgressHUD showSuccessWithStatus:@"保存图片成功"];
        } failureBlock:nil];
    }];
}

#pragma mark - 保存图片练习
- (void)test{
    // 把图片保存到【相机胶卷】中
    //    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    // 拿到所有图片名称
    /*
     ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
     [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
     LSLLog(@"%@",[group valueForProperty:ALAssetsGroupPropertyName]);
     [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
     LSLLog(@"%@",[UIImage imageWithCGImage:result.thumbnail]);
     }];
     } failureBlock:nil];
     */
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存相片失败"];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"保存相片成功"];
    }
}

#pragma mark - 退出当前界面
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <UIScrollViewDelegate>
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
