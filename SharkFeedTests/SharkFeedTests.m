//
//  SharkFeedTests.m
//  SharkFeedTests
//
//  Created by mike oh on 2018-02-05.
//  Copyright © 2018 mike oh. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ApiFetcher.h"

@interface SharkFeedTests : XCTestCase

@property(nonatomic,strong) XCTestExpectation *expectation;

@end

@implementation SharkFeedTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _expectation = [self expectationWithDescription:@"Server response"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testImageList {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSTimeInterval time = 30;
    ApiFetcher *apiFetcher = [ApiFetcher.alloc init];
    
    [apiFetcher imageListWithText:@"shark" withPage:1 success:^(NSDictionary *dic) {
        if (![dic[@"photos"] isKindOfClass: [NSDictionary class]]) {
            XCTFail(@"Failure: No photos information.");
        }
        [self.expectation fulfill];
    } failure:^(NSError *error) {
        XCTFail(@"Failure: %@",error.description);
        [self.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:time handler:^(NSError *error) {
        if (error != nil) {
            XCTFail(@"Failure: user retrieval exceeded %f seconds.", time);
        }
    }];
}

- (void)testImageWithId {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSTimeInterval time = 60;
    ApiFetcher *apiFetcher = [ApiFetcher.alloc init];
    
    [apiFetcher imageWithId:@"22337474460" success:^(NSDictionary *dic)  {
        if (![dic[@"photo"] isKindOfClass: [NSDictionary class]]) {
            XCTFail(@"Failure: No info information.");
        }
        [self.expectation fulfill];
    } failure:^(NSError *error) {
        XCTFail(@"Failure: %@",error.description);
        [self.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:time handler:^(NSError *error) {
        if (error != nil) {
            XCTFail(@"Failure: user retrieval exceeded %f seconds.", time);
        }
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
