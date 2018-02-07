//
//  ImageDownloader.m
//  SharkFeed
//
//  Created by mike oh on 2018-02-05.
//  Copyright © 2018 mike oh. All rights reserved.
//

#import "ApiFetcher.h"

static NSString * const kApiKey = @"949e98778755d1982f537d56236bbb42";
static NSString * const kAPIUrl = @"https://api.flickr.com/";
static NSString * const kAPIEndPoint = @"services/rest/";

@interface ApiFetcher()

@property(nonatomic, strong) NSURLSession *imageSession;
@property(nonatomic, strong) NSOperationQueue *netOperationQueue;

@end

@implementation ApiFetcher
- (id)init {
    self = [super init];
    if (self) {
        _netOperationQueue = [[NSOperationQueue alloc] init];
        _netOperationQueue.maxConcurrentOperationCount = 3;
        _netOperationQueue.name = @"image Operations";
        
        NSURLSessionConfiguration *sessionImageConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionImageConfiguration.timeoutIntervalForResource = 6;
        sessionImageConfiguration.HTTPMaximumConnectionsPerHost = 2;
        sessionImageConfiguration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        _imageSession = [NSURLSession sessionWithConfiguration:sessionImageConfiguration delegate:nil delegateQueue:_netOperationQueue];
    }
    return self;
}

- (NSURLSessionTask *)imageListWithText:(NSString *)searchText withPage:(NSInteger)page
                           success:(void (^)(NSDictionary *dic))success
                           failure:(void (^)(NSError *error))failure {
    NSDictionary *dic = @{
                          @"text":searchText,
                          @"page":@(page).stringValue,
                          @"extras":@"url_t,url_c,url_l,url_o"
    };
    
    NSURL *url = [self parameters:@"flickr.photos.search" withDictionary:dic];
    __weak typeof(self) weakSelf = self;
    
    NSURLSessionTask *task = [_imageSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [weakSelf responseHandler:data response:response error:error success:success failure:failure];
    }];
    
    [task resume];
    return task;
}

- (NSURLSessionTask *)imageWithId:(NSString *)photoId
                           success:(void (^)(NSDictionary *dic))success
                           failure:(void (^)(NSError *error))failure {
    NSDictionary *dic = @{@"photo_id":photoId};
    NSURL *url = [self parameters:@"flickr.photos.getInfo" withDictionary:dic];
    __weak typeof(self) weakSelf = self;
    
    NSURLSessionTask *task = [_imageSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [weakSelf responseHandler:data response:response error:error success:success failure:failure];
    }];
    
    [task resume];
    return task;
}

#pragma mark helpers

- (NSURL *)apiURL {
    NSString *endPoint = [self apiURLString];
    
    return [NSURL URLWithString:endPoint];
}

- (NSString *)apiURLString {
    return [NSString stringWithFormat:@"%@%@", kAPIUrl, kAPIEndPoint];
}

- (NSURL *)parameters:(NSString *)method withDictionary:(NSDictionary *)dic {
    NSURLComponents *components = [NSURLComponents componentsWithString:[self apiURLString]];
    NSURLQueryItem *methodItem = [NSURLQueryItem queryItemWithName:@"method" value:method];
    NSURLQueryItem *apikey = [NSURLQueryItem queryItemWithName:@"api_key" value:kApiKey];
    NSURLQueryItem *format = [NSURLQueryItem queryItemWithName:@"format" value:@"json"];
    NSURLQueryItem *nojson = [NSURLQueryItem queryItemWithName:@"nojsoncallback" value:@"1"];
    NSMutableArray *array = [@[methodItem, apikey, format, nojson] mutableCopy];

    for (id key in [dic allKeys]) {
        [array addObject:[NSURLQueryItem queryItemWithName:key value:dic[key]]];
    }
    
    components.queryItems = array;
    return components.URL;
}

- (void)responseHandler:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error success:(void (^)(NSDictionary *dic))success
                failure:(void (^)(NSError *error))failure {
    
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
        return;
    }
    if (response) {
        //More error handling can be done such as there are no JSON.
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *arr = [weakSelf parseData:data];
            if (arr) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(arr);
                });
            } else {
                // Custom error used in case the return object is not kind of nsdictionary.
                NSError *error = [NSError errorWithDomain:kAPIUrl code:-1 userInfo:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(error);
                });
            }
        });
    }
}

- (NSDictionary *)parseData:(NSData *)data {
    NSError *parseError = nil;
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                         options:0
                                                           error:&parseError];
    
    if (!parseError) {
        return jsonArray;
    } else {
        NSLog(@"Encountered error parsing: %@", [parseError localizedDescription]);
        return @{};
    }
}

@end
