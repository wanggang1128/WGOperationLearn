//
//  ViewController.m
//  WGOperationLearn
//
//  Created by wanggang on 2018/8/3.
//  Copyright © 2018年 wanggang. All rights reserved.
//

#import "ViewController.h"
#import "WGOperation.h"

@interface ViewController ()

@property (nonatomic, assign) int totalCount;
@property (nonatomic, strong) NSLock *lock;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ViewController";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self unsafeQueue];
}

- (NSLock *)lock{
    if (!_lock) {
        _lock = [[NSLock alloc] init];
    }
    return _lock;
}

#pragma mark -非线程安全
- (void)unsafeQueue{
    NSLog(@"unsafeQueue---%@",[NSThread currentThread]); // 打印当前线程
    self.totalCount = 30;
    //1号票点
    NSOperationQueue *queue1 = [[NSOperationQueue alloc] init];
    queue1.maxConcurrentOperationCount = 1;
    [queue1 addOperationWithBlock:^{
        [self saleTickets];
    }];
    
    //2号票点
    NSOperationQueue *queue2 = [[NSOperationQueue alloc] init];
    queue2.maxConcurrentOperationCount = 1;
    [queue2 addOperationWithBlock:^{
        [self saleTickets];
    }];
}

- (void)saleTickets{
    while (YES) {
        if (self.totalCount > 0) {
            [self.lock lock];
            self.totalCount --;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数:%d 窗口:%@", self.totalCount, [NSThread currentThread]]);
            sleep(1);
            [self.lock unlock];
        }else{
            NSLog(@"票已售完");
            break;
        }
    }
}

#pragma mark -线程之间的通信
- (void)communication{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [queue addOperationWithBlock:^{
        for (int i=0; i<3; i++) {
            sleep(3);
            NSLog(@"111---%@", [NSThread currentThread]); // 打印当前线程
        }
        //回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            for (int i=0; i<3; i++) {
                sleep(3);
                NSLog(@"222---%@", [NSThread currentThread]); // 打印当前线程
            }
        }];
    }];
}

#pragma mark -依赖
- (void)addDependency{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i=0; i<3; i++) {
            sleep(3);
            NSLog(@"111---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i=0; i<3; i++) {
            sleep(3);
            NSLog(@"222---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    //op2执行完才能执行op1
    [op1 addDependency:op2];
    
    [queue addOperation:op1];
    [queue addOperation:op2];
}

#pragma mark -控制串行执行、并发执行
- (void)maxConcurrentOperationCount{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //串行
//    queue.maxConcurrentOperationCount = 1;
    //并发
    queue.maxConcurrentOperationCount = 2;
    //并发
//    queue.maxConcurrentOperationCount = 10;
    
    [queue addOperationWithBlock:^{
        for (int i=0; i<3; i++) {
            sleep(3);
            NSLog(@"111---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    [queue addOperationWithBlock:^{
        for (int i=0; i<3; i++) {
            sleep(3);
            NSLog(@"222---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    [queue addOperationWithBlock:^{
        for (int i=0; i<3; i++) {
            sleep(3);
            NSLog(@"333---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    [queue addOperationWithBlock:^{
        for (int i=0; i<3; i++) {
            sleep(3);
            NSLog(@"444---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
}

#pragma mark -任务添加到队列中
//- (void)addOperationWithBlock:(void (^)(void))block;
- (void)addOperationWithBlockToQueue{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [queue addOperationWithBlock:^{
        for (int i=0; i<3; i++) {
            sleep(3);
            NSLog(@"111---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    [queue addOperationWithBlock:^{
        for (int i=0; i<3; i++) {
            sleep(3);
            NSLog(@"222---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    [queue addOperationWithBlock:^{
        for (int i=0; i<3; i++) {
            sleep(3);
            NSLog(@"333---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    [queue addOperationWithBlock:^{
        for (int i=0; i<3; i++) {
            sleep(3);
            NSLog(@"444---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
}

//- (void)addOperation:(NSOperation *)op;
- (void)addOperationToQueue{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task01) object:nil];
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task02) object:nil];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i=0; i<3; i++) {
            sleep(3);
            NSLog(@"333---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op3 addExecutionBlock:^{
        for (int i=0; i<3; i++) {
            sleep(3);
            NSLog(@"444---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
}

- (void)task01{
    for (int i=0; i<3; i++) {
        sleep(3);
        NSLog(@"111---%@", [NSThread currentThread]); // 打印当前线程
    }
}

- (void)task02{
    for (int i=0; i<3; i++) {
        sleep(3);
        NSLog(@"222---%@", [NSThread currentThread]); // 打印当前线程
    }
}

#pragma mark -开启一个子线程
- (void)subThreadMethod{
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(useWGOperation) object:nil];
    [thread start];
}

#pragma mark -自定义WGOperation
- (void)useWGOperation{
    WGOperation *wgOp = [[WGOperation alloc] init];
    [wgOp start];
}

#pragma mark -NSBlockOperation
//在主线程执行
- (void)useBlockOperation01{
    NSLog(@"useBlockOperation01---%@", [NSThread currentThread]); // 打印当前线程
    NSBlockOperation *blockOp= [NSBlockOperation blockOperationWithBlock:^{
        for (int i=0; i<3; i++) {
            sleep(3);
            NSLog(@"111---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    [blockOp addExecutionBlock:^{
        sleep(3);
        NSLog(@"222---%@", [NSThread currentThread]);
    }];
    [blockOp addExecutionBlock:^{
        sleep(3);
        NSLog(@"333---%@", [NSThread currentThread]);
    }];
    [blockOp addExecutionBlock:^{
        sleep(3);
        NSLog(@"444---%@", [NSThread currentThread]);
    }];
    [blockOp addExecutionBlock:^{
        sleep(3);
        NSLog(@"555---%@", [NSThread currentThread]);
    }];
    [blockOp start];
}

//在子线程执行
- (void)useBlockOperation{
    NSBlockOperation *blockOp= [NSBlockOperation blockOperationWithBlock:^{
        for (int i=0; i<3; i++) {
            sleep(3);
            NSLog(@"useBlockOperation---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    [blockOp addExecutionBlock:^{
        sleep(3);
        NSLog(@"useBlockOperation---%@", [NSThread currentThread]);
    }];
    
    [blockOp start];
}

#pragma mark -NSInvocationOperation
- (void)useInvocationOperation{
    NSInvocationOperation *invocationOp = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(InvocationOperationMethod) object:nil];
    [invocationOp start];
}

- (void)InvocationOperationMethod{
    for (int i=0; i<3; i++) {
        sleep(3);
        NSLog(@"InvocationOperationMethod---%@", [NSThread currentThread]); // 打印当前线程
    }
}

@end
