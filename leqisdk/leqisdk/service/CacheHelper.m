//
//  CacheUtils.m
//  leqisdk
//
//  Created by zhangkai on 2018/1/23.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "CacheHelper.h"
#import "YYCache.h"

#define USERS_KEYS @"users_key"
#define CURRENT_USER_KEY @"current_user_key"
#define AUTO_LOGIN_KEY @"auto_login_key"
#define INIT_KEY_INFO @"init_info_key"

@interface CacheHelper()

@property (nonatomic, strong) YYDiskCache *diskCache;

@end

@implementation CacheHelper

static CacheHelper* instance = nil;

+ (instancetype) shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject];
    instance.diskCache = [[YYDiskCache alloc] initWithPath:[basePath stringByAppendingPathComponent:@"sdk"]];
    return instance;
}

- (NSMutableArray *)getUsers {
    id users =  [self.diskCache objectForKey:USERS_KEYS];
    if(users && [users isKindOfClass:[NSMutableArray class]]){
        return users;
    }
    return nil;
}

- (void)setUser:(nonnull NSMutableDictionary *)data mainKey:(int)mainkey {
    id users =  [self.diskCache objectForKey:USERS_KEYS];
    if(!users || ![users isKindOfClass:[NSMutableArray class]]){
        users = [NSMutableArray new];
    }
    [data setObject:[NSNumber numberWithInt:mainkey] forKey:MAIN_KEY];
    for(NSMutableDictionary *info in users){
        //int value = [[info objectForKey:MAIN_KEY] intValue];
        if([[data objectForKey:@"user_id"] isEqual:[info objectForKey:@"user_id"]]){
            [users removeObject:info];
            break;
        }
    }
    [self setCurrentUser:data];
    [users insertObject:data atIndex:0];
    [self.diskCache setObject:users forKey:USERS_KEYS];
}

- (void)setUsers:(nonnull NSArray *)users {
    [self.diskCache setObject:users forKey:USERS_KEYS];
}
- (void)setCurrentUser:(NSDictionary *)user {
    [self.diskCache setObject:user forKey:CURRENT_USER_KEY];
}

- (NSMutableDictionary *)getCurrentUser {
    return (NSMutableDictionary *)[self.diskCache objectForKey:CURRENT_USER_KEY];
}

- (BOOL)getAutoLogin {
    NSNumber *number = (NSNumber *)[self.diskCache objectForKey:AUTO_LOGIN_KEY];
    return [number boolValue];
}

- (void)setAutoLogin:(BOOL)autologin {
    [self.diskCache setObject:[NSNumber numberWithBool:autologin] forKey:AUTO_LOGIN_KEY];
}

- (NSDictionary *)getInitInfo {
    return (NSDictionary *)[self.diskCache objectForKey:INIT_KEY_INFO];
}

- (void)setInitInfo:(NSDictionary *)initinfo {
    [self.diskCache setObject:initinfo forKey:INIT_KEY_INFO];
}


@end
