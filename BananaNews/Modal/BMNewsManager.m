//
//  BMNewsManager.m
//  BananaNews
//
//  Created by 龚涛 on 1/3/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMNewsManager.h"

@interface BMNewsManager ()
{
    AFHTTPRequestOperationManager *_manager;
}

@end

@implementation BMNewsManager

+ (BMNewsManager *)sharedManager
{
    static BMNewsManager *sharedManagerInstance = nil;
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        sharedManagerInstance = [[BMNewsManager alloc] init];
    });
    
    return sharedManagerInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:kBaseURL];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
        [_manager.operationQueue setMaxConcurrentOperationCount:3];
        
        NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:8 * 1024 * 1024
                                                             diskCapacity:40 * 1024 * 1024
                                                                 diskPath:nil];
        [NSURLCache setSharedURLCache:URLCache];
    }
    return self;
}

- (AFHTTPRequestOperation *)getDownloadList:(NSUInteger)type
                                       page:(NSUInteger)page
                                    success:(void (^)(NSArray *array))success
                                    failure:(void (^)(NSError *error))failure
{
    void (^requestSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != [NSNull null]) {
            NSLog(@"%@", responseObject);
        }
        if (success) {
            success(nil);
        }
    };
    
    void (^requestFailure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failure) {
            failure(error);
        }
    };
    
    AFHTTPRequestOperation *op = [_manager GET:@"posts" parameters:nil success:requestSuccess failure:requestFailure];
    NSLog(@"request: %@", op.request.URL.absoluteString);
    return op;
}

@end
