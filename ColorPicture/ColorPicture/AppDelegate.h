//
//  AppDelegate.h
//  ColorPicture
//
//  Created by ZhenwenLi on 2018/6/21.
//  Copyright © 2018年 lizhenwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

