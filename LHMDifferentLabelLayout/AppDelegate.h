//
//  AppDelegate.h
//  LHMDifferentLabelLayout
//
//  Created by 李浩淼 on 2016/11/13.
//  Copyright © 2016年 opstt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

