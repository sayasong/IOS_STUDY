//
//  YYFaceViewController.m
//  MAO_STUDY
//
//  Created by 毛睿 on 17/1/20.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "YYFaceViewController.h"
// http://www.faceplusplus.com.cn/dev-tools-sdks/
//#import "FaceppAPI.h"

#define kwidth self.view.frame.size.width
#define height self.view.frame.size.height
#define btnBorder 40
#define imgBorder 20

@interface YYFaceViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

//显示图片的imageView
@property (nonatomic,strong) UIImageView *firstImgV;
@property (nonatomic,strong) UIImageView *secondImgV;
//触发比较相似度的button
@property (nonatomic,strong) UIButton *recognizedBtn;
//五官的相似度
@property (nonatomic,strong) NSString *eye;
@property (nonatomic,strong) NSString *eyebrow;
@property (nonatomic,strong) NSString *mouth;
@property (nonatomic,strong) NSString *nose;
@property (nonatomic,strong) NSString *similarity;
@property (nonatomic,strong) UITextView *similarityView;
//通过此标记判断选择图片要显示到哪一个相框上
@property (nonatomic,assign) NSInteger imageTag;

@end

@implementation YYFaceViewController
/*
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self drawView];
}

- (void)drawView{
    //创建两个按钮,点击事件为选择照片
    UIButton *firstBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    firstBtn.frame = CGRectMake(btnBorder, 100, (kwidth - btnBorder * 3)/2, 30);
    [firstBtn setTitle:@"setFirstPhoto" forState:UIControlStateNormal];
    [firstBtn addTarget:self action:@selector(selectFirstPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:firstBtn];
    
    UIButton *secondBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    secondBtn.frame = CGRectMake(CGRectGetMaxX(firstBtn.frame) + btnBorder, 100, (kwidth - btnBorder * 3)/2, 30);
    [secondBtn setTitle:@"setSecondPhoto" forState:UIControlStateNormal];
    [secondBtn addTarget:self action:@selector(selectSecondPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:secondBtn];
    
    //创建两个相框,显示图片
    UIImageView *firstImgV = [[UIImageView alloc]initWithFrame:CGRectMake(imgBorder, 140, (kwidth - imgBorder *3)/2, (kwidth - imgBorder *3)/2 *height / kwidth)];
    firstImgV.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:firstImgV];
    self.firstImgV = firstImgV;
    
    UIImageView *secondImgV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(firstImgV.frame) + imgBorder, 140, (kwidth - imgBorder *3)/2, (kwidth - imgBorder *3)/2 *height / kwidth)];
    secondImgV.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:secondImgV];
    self.secondImgV = secondImgV;
    
    //相似度监测按钮
    UIButton *recognizedBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    recognizedBtn.frame = CGRectMake(self.view.bounds.size.width / 2, CGRectGetMaxY(secondImgV.frame) + 20, (kwidth - btnBorder * 3)/2, 30);
    recognizedBtn.center = CGPointMake(self.view.bounds.size.width / 2, CGRectGetMaxY(secondImgV.frame) + 20);
    [recognizedBtn setTitle:@"相似度计算(%)" forState:UIControlStateNormal];
    [recognizedBtn addTarget:self action:@selector(recognized) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recognizedBtn];
    recognizedBtn.enabled = NO;
    self.recognizedBtn = recognizedBtn;
    
    //添加输入框显示输出信息
    UITextView *similarityView = [[UITextView alloc]initWithFrame:CGRectMake((kwidth - 300) / 2, CGRectGetMaxY(recognizedBtn.frame) + 10, 300, 150)];
    similarityView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:similarityView];
    self.similarityView = similarityView;
    
    
}

//设置第一张图片
- (void)selectFirstPhoto{
    self.imageTag = 999;
    [self alertController];
}
//设置第二张图片
- (void)selectSecondPhoto{
    self.imageTag = 888;
    [self alertController];
}

//相似度监测
- (void)recognized{
    //获取到两张面孔的face_id
    NSString *firstFace_id;
    
    NSData *firstImgVData = UIImageJPEGRepresentation(self.firstImgV.image, 0.6);
    FaceppResult *firstResult = [[FaceppAPI detection] detectWithURL:nil orImageData:firstImgVData];
    NSArray *array1 = firstResult.content[@"face"];
    
    if (array1.count == 1) {
        firstFace_id = [firstResult content][@"face"][0][@"face_id"];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未检测到五官" delegate:self cancelButtonTitle:@"重新选择图片" otherButtonTitles: nil];
        [alert show];
        
        return;
    }
    
    
    NSString *secondFace_id;
    NSData *secondImgVData = UIImageJPEGRepresentation(self.secondImgV.image, 0.6);
    FaceppResult *secondResult = [[FaceppAPI detection] detectWithURL:nil orImageData:secondImgVData];
    NSArray *array2 = secondResult.content[@"face"];
    if (array2.count == 1) {
        secondFace_id = [secondResult content][@"face"][0][@"face_id"];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未检测到五官" delegate:self cancelButtonTitle:@"重新选择图片" otherButtonTitles: nil];
        [alert show];
        return;
        
    }
    
    //比较二者的相似度
    FaceppResult *similarResult = [[FaceppAPI recognition] compareWithFaceId1:firstFace_id andId2:secondFace_id async:NO];
    if ([similarResult success]) {
        self.eye = [similarResult content][@"component_similarity"][@"eye"];
        self.eyebrow = [similarResult content][@"component_similarity"][@"eyebrow"];
        self.mouth = [similarResult content][@"component_similarity"][@"mouth"];
        self.nose = [similarResult content][@"component_similarity"][@"nose"];
        self.similarity = [similarResult content][@"similarity"];
        
        
        NSString *content = [NSString stringWithFormat:@"眼睛:%@\n眉毛:%@\n嘴巴:%@\n鼻子:%@\n综合:%@",self.eye,self.eyebrow,self.mouth,self.nose,self.similarity];
        self.similarityView.text = content;
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未检测到五官" delegate:self cancelButtonTitle:@"error" otherButtonTitles: nil];
        [alert show];
        
        return;
    }
    
    
    
}

- (void)alertController{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //添加Button
    [alertController addAction: [UIAlertAction actionWithTitle: @"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //处理点击拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            // 跳转到相机或相册页面
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"打开相机失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
            [alert show];
        }
        
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"从相册选取" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //处理点击从相册选取
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            // 跳转到相机或相册页面
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            
            imagePickerController.delegate = self;
            
            imagePickerController.allowsEditing = YES;
            
            
            [self presentViewController:imagePickerController animated:YES completion:^{}];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"打开相机失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
            [alert show];
        }
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (self.imageTag == 999) {
        self.firstImgV.image = image;
    }
    if (self.imageTag == 888) {
        self.secondImgV.image = image;
    }
    if (self.firstImgV.image && self.secondImgV.image) {
        self.recognizedBtn.enabled = YES;
    }
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    
}
*/
@end
