//
//  WGOperation.m
//  WGOperationLearn
//
//  Created by wanggang on 2018/8/3.
//  Copyright © 2018年 wanggang. All rights reserved.
//

#import "WGOperation.h"

@implementation WGOperation

-(void)main{
    if (!self.isCancelled) {
        for (int i = 0; i < 3; i++) {
            sleep(3);
            NSLog(@"WGOperation---%@", [NSThread currentThread]);
        }
    }
}

@end
