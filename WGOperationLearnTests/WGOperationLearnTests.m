//
//  WGOperationLearnTests.m
//  WGOperationLearnTests
//
//  Created by wanggang on 2018/8/3.
//  Copyright © 2018年 wanggang. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface WGOperationLearnTests : XCTestCase

@end

@implementation WGOperationLearnTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    NSArray *array1 = @[@1];
    
    NSArray *array2 = @[@1];
    
    NSArray *array3 = array1;
    
    XCTAssertEqual(array1, array3);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
