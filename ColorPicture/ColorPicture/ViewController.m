//
//  ViewController.m
//  ColorPicture
//
//  Created by ZhenwenLi on 2018/6/21.
//  Copyright © 2018年 lizhenwen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UITextField *pathField;
    UITextField *NewpathField;
    UITextField *colorField;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pathField = [[UITextField alloc]initWithFrame:CGRectMake(20, 50, self.view.frame.size.width-40, 40)];
    pathField.placeholder=@"文件路径";
    [self.view addSubview:pathField];
    
    NewpathField = [[UITextField alloc]initWithFrame:CGRectMake(20, 100, self.view.frame.size.width-40, 40)];
    NewpathField.placeholder=@"保存文件路径";
    [self.view addSubview:NewpathField];
    
    colorField = [[UITextField alloc]initWithFrame:CGRectMake(20, 150, self.view.frame.size.width-40, 40)];
    colorField.placeholder=@"颜色RGB值 如 FFFFFF";
    colorField.text=@"FFFFFF";
    [self.view addSubview:colorField];
    
    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
    but.frame=CGRectMake(20, 200,self.view.frame.size.width-40, 40);
    [but setTitle:@"确定" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(saveBut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
}
///Users/wangbiao/Desktop/CsColor
///Users/wangbiao/Desktop/CsColor/IMG_0513 2_cut.png
///Users/wangbiao/Desktop/CsColor/zl_Special_offer.png
-(void)saveBut
{
    UIColor *color=[self readStr:colorField.text];
    NSArray *files=[self allFilesAtPath:pathField.text];
    
    NSLog(@">>>>>%@",files);
    for (int i=0; i<files.count; i++) {
        UIImage *image=[UIImage imageWithContentsOfFile:[files objectAtIndex:i]];
        UIImage *newImg=[self image:image andColor:color andState:kCGBlendModeDestinationIn];
        NSData *data=UIImagePNGRepresentation(newImg);

        NSString *filePath = [NewpathField.text stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"%@_%d.png",[self getNowTimeTimestamp],i]];  // 保存文件的名称
        
        BOOL result =[data writeToFile:filePath  atomically:YES]; // 保存成功会返回YES
        if (result == YES) {
            NSLog(@"保存成功");
        }
    }

}
- (NSArray*)allFilesAtPath:(NSString*) dirString {
    NSMutableArray* array = [NSMutableArray array];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:dirString error:nil];
    if (tempArray.count<=0) {
        [array addObject:dirString];
        return array;
    }
    for (NSString* fileName in tempArray) {
        BOOL flag = YES;
        NSString* fullPath = [dirString stringByAppendingPathComponent:fileName];
        if ([fileMgr fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                [array addObject:fullPath];
            }
        }
    }
    return array;
}


/*
 给图片着色函数
 image:背着色对象image；
 color:着上的颜色；
 state:着色形式--->
 NSCompositingOperationClear,图片全部变透明
 NSCompositingOperationCopy,无效果
 NSCompositingOperationSourceOver,透明着色，非透明保持
 NSCompositingOperationSourceIn,无效果
 NSCompositingOperationSourceOut,图片全部变透明
 NSCompositingOperationSourceAtop,透明着色，非透明保持
 NSCompositingOperationDestinationOver,全部着色
 NSCompositingOperationDestinationIn,透明保持，非透明被着色
 NSCompositingOperationDestinationOut,透明着色，非透明变透明
 NSCompositingOperationDestinationAtop,透明保持，非透明被着色
 NSCompositingOperationXOR,透明着色，非透明变透明
 NSCompositingOperationPlusDarker,奇葩效果
 NSCompositingOperationHighlight透明着色，非透明保持
 NSCompositingOperationPlusLighter,透明着色，非透明保持
 
 NSCompositingOperationMultiply    奇葩效果
 NSCompositingOperationScreen    透明着色，非透明保持
 NSCompositingOperationOverlay    奇葩效果
 NSCompositingOperationDarken    奇葩效果
 NSCompositingOperationLighten    透明着色，非透明保持
 NSCompositingOperationColorDodge    透明着色，非透明变白色
 NSCompositingOperationColorBurn    全部着色
 NSCompositingOperationSoftLight    奇葩效果
 NSCompositingOperationHardLight    透明着色，非透明轻微着色
 NSCompositingOperationDifference    透明着色，非透明反色
 NSCompositingOperationExclusion    透明着色，非透明反色
 
 NSCompositingOperationHue       透明着色，非透明反色
 NSCompositingOperationSaturation    透明着色，非透明反色
 NSCompositingOperationColor        透明着色，非透明反色
 NSCompositingOperationLuminosity透明着色，非透明轻微着色
 */

-(UIImage *)image:(UIImage *)image andColor:(UIColor *)color andState:(CGBlendMode)state
{
    //创建图片位置大小
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    [color setFill];
    CGRect bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [image drawInRect:imageRect blendMode:state alpha:1.0f];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIColor *)readStr:(NSString *)str
{
    if (str.length<6) {
        return [UIColor whiteColor];
    }
    NSMutableArray *arrColor=[NSMutableArray arrayWithObjects:[str substringWithRange:NSMakeRange(0, 1)],
                              [str substringWithRange:NSMakeRange(1, 1)],
                              [str substringWithRange:NSMakeRange(2, 1)],
                              [str substringWithRange:NSMakeRange(3, 1)],
                              [str substringWithRange:NSMakeRange(4, 1)],
                              [str substringWithRange:NSMakeRange(5, 1)], nil];
    
    for (int i=0; i<arrColor.count; i++) {
        if ([[arrColor objectAtIndex:i] isEqualToString:@"A"]||[[arrColor objectAtIndex:i] isEqualToString:@"a"]) {
            [arrColor replaceObjectAtIndex:i withObject:@"10"];
        }
        if ([[arrColor objectAtIndex:i] isEqualToString:@"B"]||[[arrColor objectAtIndex:i] isEqualToString:@"b"]) {
            [arrColor replaceObjectAtIndex:i withObject:@"11"];
        }
        if ([[arrColor objectAtIndex:i] isEqualToString:@"C"]||[[arrColor objectAtIndex:i] isEqualToString:@"c"]) {
            [arrColor replaceObjectAtIndex:i withObject:@"12"];
        }
        if ([[arrColor objectAtIndex:i] isEqualToString:@"D"]||[[arrColor objectAtIndex:i] isEqualToString:@"d"]) {
            [arrColor replaceObjectAtIndex:i withObject:@"13"];
        }
        if ([[arrColor objectAtIndex:i] isEqualToString:@"E"]||[[arrColor objectAtIndex:i] isEqualToString:@"e"]) {
            [arrColor replaceObjectAtIndex:i withObject:@"14"];
        }
        if ([[arrColor objectAtIndex:i] isEqualToString:@"F"]||[[arrColor objectAtIndex:i] isEqualToString:@"f"]) {
            [arrColor replaceObjectAtIndex:i withObject:@"15"];
        }
    }
    
    return [UIColor colorWithRed:([[arrColor objectAtIndex:0] integerValue]*16+[[arrColor objectAtIndex:1] integerValue])/255.0
                           green:([[arrColor objectAtIndex:2] integerValue]*16+[[arrColor objectAtIndex:3] integerValue])/255.0
                            blue:([[arrColor objectAtIndex:4] integerValue]*16+[[arrColor objectAtIndex:5] integerValue])/255.0 alpha:1];
}


-(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}

@end
