//
//  FeedDataSource.m
//  SharkFeed
//
//  Created by mike oh on 2018-02-05.
//  Copyright © 2018 mike oh. All rights reserved.
//

#import "FeedDataSource.h"
#import "ApiFetcher.h"

@interface FeedDataSource() {
    NSInteger page;
}

@property(nonatomic) NSMutableArray *dataSource;
@property(nonatomic) ApiFetcher *apiFetcher;

@end

@implementation FeedDataSource

- (instancetype)init {
    if (self = [super init]) {
        _apiFetcher = [ApiFetcher.alloc init];
        page = 1;
    }
    return self;
}

- (void)reset {
    page = 1;
    [self imageList];
}

- (void)readMore {
    page++;
    [self imageList];
}

- (void)imageList {
    __weak typeof(self) weakSelf = self;
    
    [self.apiFetcher imageListWithText:@"shark" withPage:page success:^(NSDictionary *dic) {
        [weakSelf appendList:dic];
    } failure:^(NSError *error) {
        // do error handling
    }];
}

- (void)appendList:(NSDictionary *)dic {
    if (dic[@"photos"] && dic[@"photos"][@"photo"]) {
        NSMutableArray *array = [dic[@"photos"][@"photo"] mutableCopy];
        if (page > 1) {
            [_dataSource addObjectsFromArray:array];
        } else {
            _dataSource = array;
        }
        [self.delegate dataLoaded:self.delegate];
    }
}

#pragma mark - setters && getters

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

@end
