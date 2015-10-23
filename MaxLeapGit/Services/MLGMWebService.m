//
//  MLGMWebService.m
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/9.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMWebService.h"
#import "MLGMWebService+Convenience.h"

@interface MLGMWebService()
@property (nonatomic, strong) NSManagedObjectContext *defaultContext;
@property (nonatomic, strong) NSManagedObjectContext *scratchContext;
@end

@implementation MLGMWebService

static int totalPageInHeadField(NSDictionary *responHeaderFields) {
    int totalPage = 0;
    if ([responHeaderFields.allKeys containsObject:@"Link"]) {
        NSString *linkValue = responHeaderFields[@"link"];
        NSArray *words = [linkValue componentsSeparatedByString:@","];
        NSString *lastLink = [words lastObject];
        NSRange startRange = [lastLink rangeOfString:@"<"];
        NSRange endRange = [lastLink rangeOfString:@">"];
        NSString *linkURL = [lastLink substringWithRange:NSMakeRange(startRange.location + 1, endRange.location - startRange.location - 1)];
        NSString *queryParameter = [linkURL substringFromIndex:[linkURL rangeOfString:@"?"].location + 1];
        NSDictionary *queryParameterDic = [queryParameter parametersFromQueryString];
        totalPage = [queryParameterDic[@"page"] intValue];
    }
    
    return totalPage;
}

static NSArray *supportEvent() {
    NSArray *supportEvent = @[@"ForkEvent",@"WatchEvent"];
    
    return supportEvent;
}

static NSString *repoSortMethodForType(MLGMSearchRepoSortType type) {
    NSString *sortMethodName = nil;
    switch (type) {
        case MLGMSearchRepoSortTypeStars: sortMethodName = @"stars"; break;
        case MLGMSearchRepoSortTypeForks: sortMethodName = @"forks"; break;
        case MLGMSearchRepoSortTypeRecentlyUpdated: sortMethodName = @"updated"; break;
        default: sortMethodName = @""; break;
    }
    return sortMethodName;
}

static NSString *userSortMethodForType(MLGMSearchUserSortType type) {
    NSString *sortMethodName = nil;
    switch (type) {
        case MLGMSearchUserSortTypeFollowers: sortMethodName = @"followers"; break;
        case MLGMSearchUserSortTypeRepos: sortMethodName = @"repositories"; break;
        case MLGMSearchUserSortTypeJoined: sortMethodName = @"joined"; break;
        default: sortMethodName = @""; break;
    }
    return sortMethodName;
}

+ (MLGMWebService *)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [MLGMWebService new];
    });
}

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _defaultContext = [NSManagedObjectContext MR_defaultContext];
    _scratchContext = [NSManagedObjectContext MR_newMainQueueContext];
    [_scratchContext setPersistentStoreCoordinator:[NSPersistentStoreCoordinator MR_defaultStoreCoordinator]];
    return self;
}

- (void)updateAccountProfileToDBCompletion:(void(^)(MLGMAccount *account, NSError *error))completion {
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:@"/user" parameters:nil];
    [self startRequest:urlRequest patternFile:@"userPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, id responseObject, NSError *error) {
        if (error) {
            DDLogError(@"access /user api error:%@", error.localizedDescription);
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, error);
            return;
        }
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            MLGMAccount *accountMO = [MLGMAccount MR_findFirstByAttribute:@"isOnline" withValue:@(YES) inContext:localContext];
            MLGMActorProfile *userProfileMO = accountMO.actorProfile;
            if (!userProfileMO) {
                userProfileMO = [MLGMActorProfile MR_createEntityInContext:localContext];
                accountMO.actorProfile = userProfileMO;
            }
            
            [userProfileMO fillProfile:responseObject];
        } completion:^(BOOL contextDidSave, NSError *error) {
            if (error) {
                DDLogError(@"/user api data save core data error:%@", error.localizedDescription);
            }
            
            MLGMAccount *account = [MLGMAccount MR_findFirstByAttribute:@"isOnline" withValue:@(YES)];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, account, error);
        }];
    }];
}

- (void)checkSessionTokenStatusCompletion:(void(^)(BOOL valid, NSError *error))completion {
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:@"/user" parameters:nil];
    [self startRequest:urlRequest patternFile:@"userPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, id responseObject, NSError *error) {
        if (error.code == MLGMErrorTypeBadCredentials) {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, NO, error);
        } else {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, YES, nil);
        }
    }];
}

- (void)fetchUserProfileForUserName:(NSString *)userName completion:(void(^)(MLGMActorProfile *userProfile, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/users/%@", userName];
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:nil];
    [self startRequest:urlRequest patternFile:@"userPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, id responseObject, NSError *error) {
        if (error) {
            DDLogError(@"access /users/%@ api error:%@", userName, error.localizedDescription);
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, error);
            return;
        }
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            MLGMActorProfile *userProfile = [MLGMActorProfile MR_findFirstOrCreateByAttribute:@"loginName" withValue:userName inContext:localContext];
            [userProfile fillProfile:responseObject];
        } completion:^(BOOL contextDidSave, NSError *error) {
            if (error) {
                DDLogError(@"access /users/%@ api error:%@", userName, error.localizedDescription);
            }
            
            MLGMActorProfile *userProfile = [MLGMActorProfile MR_findFirstByAttribute:@"loginName" withValue:userName];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, userProfile, error);
        }];
    }];
}

- (void)fetchOrganizationInfoForUserName:(NSString *)userName fromPage:(NSUInteger)page completion:(void(^)(NSArray *orgMOs, BOOL isReachEnd, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/users/%@/orgs", userName];
    NSDictionary *parameters = @{@"page" : @(page), @"per_page" : @(kPerPage)};
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:parameters];
    [self startRequest:urlRequest patternFile:@"organizationPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, NSArray *responseObject, NSError *error) {
        if (error) {
            DDLogError(@"access /user/%@/orgs api error:%@", userName, error.localizedDescription);
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, NO, error);
            return;
        }
        
        NSMutableArray *orgMOs = [NSMutableArray new];
        [responseObject enumerateObjectsUsingBlock:^(NSDictionary *oneOrgDic, NSUInteger idx, BOOL * _Nonnull stop) {
            MLGMActorProfile *oneOrgProfile = [MLGMActorProfile MR_findFirstOrCreateByAttribute:@"loginName" withValue:oneOrgDic[@"login"] inContext:self.scratchContext];
            [oneOrgProfile fillOrg:oneOrgDic];
            [orgMOs addObject:oneOrgProfile];
        }];
        
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, [orgMOs copy], [orgMOs count] < kPerPage, nil);
    }];
}

- (void)fetchOrganizationCountForUserName:(NSString *)userName completion:(void(^)(NSUInteger orgCount, NSError *error))completion; {
    NSString *endPoint = [NSString stringWithFormat:@"/users/%@/orgs", userName];
    NSDictionary *parameters = @{@"page" : @(1), @"per_page" : @(1)};
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:parameters];
    [self startRequest:urlRequest patternFile:@"organizationPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, NSArray *responseObject, NSError *error) {
        if (error) {
            DDLogError(@"access /user/%@/orgs api error:%@",userName, error.localizedDescription);
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, 0, error);
            return;
        }
        
        int orgCount = totalPageInHeadField(responHeaderFields);
        
        MLGMActorProfile *userProfile = [MLGMActorProfile MR_findFirstByAttribute:@"loginName" withValue:userName inContext:self.defaultContext];
        if (userProfile) {
            userProfile.organizationCount = @(orgCount);
        }
        [self.defaultContext MR_saveToPersistentStoreAndWait];
        
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, orgCount, nil);
    }];
}

- (void)fetchOrganizationUpdateDateForOrgName:(NSString *)orgName completion:(void(^)(NSDate *updatedAt, NSString *orgName, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/orgs/%@", orgName];
    NSURLRequest *request = [self getRequestWithEndPoint:endPoint parameters:nil];
    [self startRequest:request patternFile:@"userPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, NSDictionary *responseObject, NSError *error) {
        if (error) {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, orgName, error);
            DDLogError(@"access orgs/%@/ api error:%@", orgName, error.localizedDescription);
            return;
        }
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            MLGMActorProfile *orgProfileMO = [MLGMActorProfile MR_findFirstOrCreateByAttribute:@"loginName" withValue:orgName inContext:localContext];
            [orgProfileMO fillProfile:responseObject];
        } completion:^(BOOL contextDidSave, NSError *error) {
            if (error) {
                DDLogError(@"access /orgs/%@ api error:%@", orgName, error.localizedDescription);
            }
            
            MLGMActorProfile *orgProfile = [MLGMActorProfile MR_findFirstByAttribute:@"loginName" withValue:orgName];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, orgProfile.githubUpdateTime, orgName, error);
        }];
    }];
}

- (void)fetchStarCountForUserName:(NSString *)userName completion:(void(^)(NSUInteger starCount, NSString *userName, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/users/%@/starred", userName];
    NSDictionary *parameters = @{@"page" : @(1), @"per_page" : @(1)};
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:parameters];
    [self startRequest:urlRequest patternFile:@"reposPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, NSArray *responseObject, NSError *error) {
        if (error) {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, 0, userName, error);
            DDLogError(@"access /user/%@/starred api error:%@", userName, error.localizedDescription);
            return;
        }
        
        int starCount = totalPageInHeadField(responHeaderFields);
        
        MLGMActorProfile *userProfile = [MLGMActorProfile MR_findFirstByAttribute:@"loginName" withValue:userName inContext:self.defaultContext];
        if (userProfile) {
            userProfile.starCount = @(starCount);
        }
        [self.defaultContext MR_saveToPersistentStoreAndWait];
        
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, starCount, userName, nil);
    }];
}

- (void)fetchTimeLineEventsForUserName:(NSString *)userName fromPage:(NSUInteger)page completion:(void(^)(NSArray *events, BOOL isReachEnd, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/users/%@/received_events", userName];
    NSDictionary *parameters = @{@"page" : @(page), @"per_page" : @(kPerPage)};
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:parameters];
    [self startRequest:urlRequest patternFile:@"organizationPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, NSArray *responseObject, NSError *error) {
        if (error) {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, YES, error);
            DDLogError(@"access /user/%@/orgs api error:%@", userName, error.localizedDescription);
            return;
        }
        
        NSMutableArray *eventMOs = [NSMutableArray new];
        [responseObject enumerateObjectsUsingBlock:^(NSDictionary *oneEventDic, NSUInteger idx, BOOL * stop) {
            NSString *type = oneEventDic[@"type"];
            if ([supportEvent() containsObject:type]) {
                MLGMEvent *oneEventMO = [MLGMEvent MR_createEntityInContext:self.scratchContext];
                [oneEventMO fillObject:oneEventDic];
                [eventMOs addObject:oneEventMO];
            }
        }];
        
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, [eventMOs copy], [responseObject count] < kPerPage, nil);
    }];
}

- (void)checkFollowStatusForUserName:(NSString *)sourceUserName followTargetUserName:(NSString *)targetUserName completion:(void(^)(BOOL isFollow, NSString *targetUserName, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/users/%@/following/%@", sourceUserName, targetUserName];
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:nil];
    [self startRequest:urlRequest patternFile:nil completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, id responseData, NSError *error) {
        
        NSPredicate *p = [NSPredicate predicateWithFormat:@"sourceLoginName = %@ and targetLoginName = %@", sourceUserName, targetUserName];
        MLGMFollowRelation *followRecord = [MLGMFollowRelation MR_findFirstWithPredicate:p inContext:self.defaultContext];
        if (!followRecord) {
            followRecord = [MLGMFollowRelation MR_createEntityInContext:self.defaultContext];
        }
        
        if (statusCode == 204) {
            followRecord.isFollow = @(YES);
            followRecord.sourceLoginName = sourceUserName;
            followRecord.targetLoginName = targetUserName;
            [self.defaultContext MR_saveToPersistentStoreAndWait];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, YES, targetUserName, nil);
        } else if (statusCode == 404){
            followRecord.isFollow = @(NO);
            followRecord.sourceLoginName = sourceUserName;
            followRecord.targetLoginName = targetUserName;
            [self.defaultContext MR_saveToPersistentStoreAndWait];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, NO, targetUserName, nil);
        } else {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, NO, targetUserName, error);
        }
    }];
}

- (void)followTargetUserName:(NSString *)targetUserName completion:(void(^)(BOOL isFollow, NSString *targetUserName, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/user/following/%@", targetUserName];
    NSURLRequest *urlRequest = [self putRequestWithEndPoint:endPoint parameters:nil];
    [self startRequest:urlRequest patternFile:nil completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, id responseData, NSError *error) {
        
        NSPredicate *p = [NSPredicate predicateWithFormat:@"sourceLoginName = %@ and targetLoginName = %@", kOnlineUserName, targetUserName];
        MLGMFollowRelation *followRecord = [MLGMFollowRelation MR_findFirstWithPredicate:p inContext:self.defaultContext];
        if (!followRecord) {
            followRecord = [MLGMFollowRelation MR_createEntityInContext:self.defaultContext];
        }
        
        if (statusCode == 204) {
            followRecord.isFollow = @(YES);
            followRecord.sourceLoginName = kOnlineUserName;
            followRecord.targetLoginName = targetUserName;
            [self.defaultContext MR_saveToPersistentStoreAndWait];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, YES, targetUserName, nil);
        } else {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, NO, targetUserName, nil);
        }
    }];
}

- (void)unfollowTargetUserName:(NSString *)targetUserName completion:(void(^)(BOOL isUnFollow, NSString *targetUserName, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/user/following/%@", targetUserName];
    NSURLRequest *urlRequest = [self deleteRequestWithEndPoint:endPoint parameters:nil];
    [self startRequest:urlRequest patternFile:nil completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, id responseData, NSError *error) {
        NSPredicate *p = [NSPredicate predicateWithFormat:@"sourceLoginName = %@ and targetLoginName = %@", kOnlineUserName, targetUserName];
        MLGMFollowRelation *followRelation = [MLGMFollowRelation MR_findFirstWithPredicate:p inContext:self.defaultContext];
        if (!followRelation) {
            followRelation = [MLGMFollowRelation MR_createEntityInContext:self.defaultContext];
        }
        
        if (statusCode == 204) {
            followRelation.isFollow = @(NO);
            followRelation.sourceLoginName = kOnlineUserName;
            followRelation.targetLoginName = targetUserName;
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, YES, targetUserName, nil);
        } else {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, NO, targetUserName, nil);
        }
    }];
}

- (void)fetchFollowerListForUserName:(NSString *)userName fromPage:(NSUInteger)page completion:(void(^)(NSArray *userProfiles, BOOL isReachEnd, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/users/%@/followers", userName];
    NSDictionary *parameters = @{@"page" : @(page), @"per_page" : @(kPerPage)};
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:parameters];
    [self startRequest:urlRequest patternFile:@"followerPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, NSArray *responseObject, NSError *error) {
        if (error) {
            DDLogError(@"access /user/%@/orgs api error:%@", userName, error.localizedDescription);
            
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, NO, error);
            return;
        }
        
        NSMutableArray *followMOs = [NSMutableArray new];
        [responseObject enumerateObjectsUsingBlock:^(NSDictionary *oneFollowDic, NSUInteger idx, BOOL * stop) {
            MLGMActorProfile *oneFollowMO = [MLGMActorProfile MR_createEntityInContext:self.scratchContext];
            [oneFollowMO fillFollow:oneFollowDic];
            [followMOs addObject:oneFollowMO];
        }];
        
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, [followMOs copy], [responseObject count] < kPerPage, nil);
    }];
}

- (void)fetchFollowingListForUserName:(NSString *)userName fromPage:(NSUInteger)page completion:(void(^)(NSArray *userProfile, BOOL isReachEnd, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/users/%@/following", userName];
    NSDictionary *parameters = @{@"page" : @(page), @"per_page" : @(kPerPage)};
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:parameters];
    [self startRequest:urlRequest patternFile:@"followerPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, NSArray *responseObject, NSError *error) {
        if (error) {
            DDLogError(@"access /user/%@/received_events api error:%@", userName, error.localizedDescription);
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, NO, error);
            return;
        }
        
        NSMutableArray *followMOs = [NSMutableArray new];
        [responseObject enumerateObjectsUsingBlock:^(NSDictionary *oneFollowDic, NSUInteger idx, BOOL * stop) {
            MLGMActorProfile *oneUsrProfileMO = [MLGMActorProfile MR_findFirstOrCreateByAttribute:@"loginName" withValue:oneFollowDic[@"login"] inContext:self.scratchContext];
            [oneUsrProfileMO fillFollow:oneFollowDic];
            [followMOs addObject:oneUsrProfileMO];
        }];
        
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, [followMOs copy], [followMOs count] < kPerPage, nil);
    }];
}

- (void)fetchStarredReposForUserName:(NSString *)userName fromPage:(NSUInteger)page completion:(void(^)(NSArray *repos, BOOL isReachEnd, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/users/%@/starred", userName];
    NSDictionary *parameters = @{@"page" : @(page), @"per_page" : @(kPerPage)};
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:parameters];
    [self startRequest:urlRequest patternFile:@"reposPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, NSArray *responseObject, NSError *error) {
        if (error) {
            DDLogError(@"access /user/%@/starred api error:%@", userName, error.localizedDescription);
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, NO, error);
            return;
        }
        
        NSMutableArray *repoMOs = [NSMutableArray new];
        [responseObject enumerateObjectsUsingBlock:^(NSDictionary *oneRepoDic, NSUInteger idx, BOOL * _Nonnull stop) {
            MLGMRepo *oneRepoMO = [MLGMRepo MR_createEntityInContext:self.scratchContext];
            [oneRepoMO fillObject:oneRepoDic];
            [repoMOs addObject:oneRepoMO];
        }];
        
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, [repoMOs copy], [repoMOs count] < kPerPage, nil);
    }];
}

- (void)fetchPublicReposForUserName:(NSString *)userName fromPage:(NSUInteger)page completion:(void(^)(NSArray *repos, BOOL isReachEnd, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/users/%@/repos", userName];
    NSDictionary *parameters = @{@"page" : @(page), @"per_page" : @(kPerPage)};
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:parameters];
    [self startRequest:urlRequest patternFile:@"reposPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, NSArray *responseObject, NSError *error) {
        if (error) {
            DDLogError(@"access /users/%@/repos api error:%@", userName, error.localizedDescription);
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, NO, error);
            return;
        }
        
        NSMutableArray *repoMOs = [NSMutableArray new];
        [responseObject enumerateObjectsUsingBlock:^(NSDictionary *oneRepoDic, NSUInteger idx, BOOL * _Nonnull stop) {
            MLGMRepo *oneRepoMO = [MLGMRepo MR_createEntityInContext:self.scratchContext];
            [oneRepoMO fillObject:oneRepoDic];
            [repoMOs addObject:oneRepoMO];
        }];
        
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, [repoMOs copy], [repoMOs count] < kPerPage, nil);
    }];
}

- (void)checkStarStatusForRepo:(NSString *)repoName completion:(void(^)(BOOL isStar, NSString *repoName, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/user/starred/%@", repoName];
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:nil];
    [self startRequest:urlRequest patternFile:nil completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, id responseData, NSError *error) {
        NSPredicate *p = [NSPredicate predicateWithFormat:@"loginName = %@ and repoName = %@", kOnlineUserName, repoName];
        MLGMTagRelation *tagRelation = [MLGMTagRelation MR_findFirstWithPredicate:p inContext:self.defaultContext];
        if (!tagRelation) {
            tagRelation = [MLGMTagRelation MR_createEntityInContext:self.defaultContext];
        }
        
        if (statusCode == 204) {
            tagRelation.loginName = kOnlineUserName;
            tagRelation.repoName = repoName;
            tagRelation.isStarred = @YES;
            tagRelation.isTagged = @YES;//if the repo is starred already, tag it (to exclude from recommendation list)
            [self.defaultContext MR_saveToPersistentStoreAndWait];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, YES, repoName, nil);
        } else if (statusCode == 404) {
            tagRelation.loginName = kOnlineUserName;
            tagRelation.repoName = repoName;
            tagRelation.isStarred = @NO;
            [self.defaultContext MR_saveToPersistentStoreAndWait];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, NO, repoName, nil);
        } else {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, NO, repoName, error);
        }
    }];
}

- (void)starRepo:(NSString *)repoName completion:(void(^)(BOOL succeeded, NSString *repoName, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/user/starred/%@", repoName];
    NSURLRequest *urlRequest = [self putRequestWithEndPoint:endPoint parameters:nil];
    [self startRequest:urlRequest patternFile:nil completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, id responseData, NSError *error) {
        if (statusCode == 204) {
            NSPredicate *p = [NSPredicate predicateWithFormat:@"loginName = %@ and repoName = %@", kOnlineUserName, repoName];
            MLGMTagRelation *tagRelation = [MLGMTagRelation MR_findFirstWithPredicate:p inContext:self.defaultContext];
            if (!tagRelation) {
                tagRelation = [MLGMTagRelation MR_createEntityInContext:self.defaultContext];
            }
            tagRelation.loginName = kOnlineUserName;
            tagRelation.repoName = repoName;
            tagRelation.isStarred = @YES;
            tagRelation.isTagged = @YES;
            [self.defaultContext MR_saveToPersistentStoreAndWait];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, YES, repoName, nil);
        } else {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, NO, repoName, nil);
        }
    }];
}

- (void)unstarRepo:(NSString *)repoName completion:(void(^)(BOOL succeeded, NSString *repoName, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/user/starred/%@", repoName];
    NSURLRequest *urlRequest = [self deleteRequestWithEndPoint:endPoint parameters:nil];
    [self startRequest:urlRequest patternFile:nil completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, id responseData, NSError *error) {
        if (statusCode == 204) {
            NSPredicate *p = [NSPredicate predicateWithFormat:@"loginName = %@ and repoName = %@", kOnlineUserName, repoName];
            MLGMTagRelation *tagRelation = [MLGMTagRelation MR_findFirstWithPredicate:p inContext:self.defaultContext];
            if (!tagRelation) {
                tagRelation = [MLGMTagRelation MR_createEntityInContext:self.defaultContext];
            }
            tagRelation.loginName = kOnlineUserName;
            tagRelation.repoName = repoName;
            tagRelation.isStarred = @NO;
            tagRelation.isTagged = @YES;
            [self.defaultContext MR_saveToPersistentStoreAndWait];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, YES, repoName, nil);
        } else {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, NO, repoName, nil);
        }
    }];
}

- (void)forkRepo:(NSString *)repoName completion:(void(^)(BOOL succeeded, NSString *repoName, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/repos/%@/forks", repoName];
    NSURLRequest *urlRequest = [self postRequestWithEndPoint:endPoint parameters:nil];
    [self startRequest:urlRequest patternFile:nil completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, id responseData, NSError *error) {
        if (statusCode == 202) {
            NSPredicate *p = [NSPredicate predicateWithFormat:@"loginName = %@ and repoName = %@", kOnlineUserName, repoName];
            MLGMTagRelation *tagRelation = [MLGMTagRelation MR_findFirstWithPredicate:p inContext:self.defaultContext];
            if (!tagRelation) {
                tagRelation = [MLGMTagRelation MR_createEntityInContext:self.defaultContext];
            }
            tagRelation.loginName = kOnlineUserName;
            tagRelation.repoName = repoName;
            tagRelation.isTagged = @YES;
            [self.defaultContext MR_saveToPersistentStoreAndWait];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, YES, repoName, nil);
        } else {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, NO, repoName, nil);
        }
    }];
}

#pragma mark - Search
- (void)searchByRepoName:(NSString *)repoName sortType:(MLGMSearchRepoSortType)sortType fromPage:(NSUInteger)page completion:(void(^)(NSArray *repos, BOOL isReachEnd, NSError *error))completion {
    NSString *endPoint = @"/search/repositories";
    NSDictionary *parameters = @{@"q":SAFE_STRING(repoName),@"sort":repoSortMethodForType(sortType), @"page" : @(page), @"per_page" : @(kPerPage)};
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:parameters];
    [self startRequest:urlRequest patternFile:@"searchReposPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, id responseData, NSError *error) {
        if (error) {
            DDLogError(@"access /search/repositories api error:%@", error.localizedDescription);
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, NO, error);
            return;
        }
        
        if (responseData && [responseData isKindOfClass:[NSDictionary class]]) {
            NSArray *items = responseData[@"items"];
            NSMutableArray *repoMOs = [NSMutableArray new];
            [items enumerateObjectsUsingBlock:^(NSDictionary *oneRepoDic, NSUInteger idx, BOOL * _Nonnull stop) {
                MLGMRepo *oneRepoMO = [MLGMRepo MR_createEntityInContext:self.scratchContext];
                [oneRepoMO fillObject:oneRepoDic];
                [repoMOs addObject:oneRepoMO];
            }];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, [repoMOs copy], [repoMOs count] < kPerPage, nil);
        }
    }];
}

- (void)searchByUserName:(NSString *)userName sortType:(MLGMSearchUserSortType)sortType fromPage:(NSUInteger)page completion:(void(^)(NSArray *users, BOOL isReachEnd, NSError *error))completion {
    NSString *endPoint = @"/search/users";
    NSDictionary *parameters = @{@"q":userName, @"sort":userSortMethodForType(sortType), @"type":@"user", @"page" : @(page), @"per_page" : @(kPerPage)};
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:parameters];
    [self startRequest:urlRequest patternFile:@"searchUsersPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, id responseData, NSError *error) {
        if (error) {
            DDLogError(@"access /search/users api error:%@", error.localizedDescription);
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, NO, error);
            return;
        }
        
        if (responseData && [responseData isKindOfClass:[NSDictionary class]]) {
            NSArray *items = responseData[@"items"];
            NSMutableArray *userMOs = [NSMutableArray new];
            [items enumerateObjectsUsingBlock:^(NSDictionary *oneUserDic, NSUInteger idx, BOOL * _Nonnull stop) {
                MLGMActorProfile *oneUserMO = [MLGMActorProfile MR_createEntityInContext:self.scratchContext];
                [oneUserMO fillSearchResult:oneUserDic];
                [userMOs addObject:oneUserMO];
            }];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, [userMOs copy], [userMOs count] < kPerPage, nil);
        }
    }];
}

- (void)fetchRecommendationReposFromPage:(NSUInteger)page completion:(void(^)(NSArray *repos, BOOL isReachEnd, NSError *error))completion {
    NSString *userid = kOnlineUserName ?: @"";
    NSSet *userGenes = kOnlineAccountProfile.genes;
    if (userGenes.count == 0) {
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, YES, nil);
        return;
    }
    
    NSMutableArray *genes = [NSMutableArray array];
    [userGenes enumerateObjectsUsingBlock:^(MLGMGene *gene, BOOL * _Nonnull stop) {
        NSDictionary *geneDict = @{@"language":gene.language, @"skill":gene.skill};
        [genes addObject:geneDict];
    }];
    
    NSString *type = page == 0 ? @"trending" : @"search";
 
    NSDictionary *parameters = @{@"userid":userid,
                                 @"genes":genes,
                                 @"page":@(page), //"page" and "per_page" are only valid for "search"
                                 @"per_page":@(kPerPage),
                                 @"type":type
                                 };
    
    [MLCloudCode callFunctionInBackground:@"repositories" withParameters:parameters block:^(NSArray *cloudObjects, NSError *error) {
        BOOL isReachEnd = [type isEqualToString:@"trending"] ? NO : cloudObjects.count < kPerPage * genes.count;
        if (error) {
            DDLogError(@"fetch %@ data error:%@", type, error.localizedDescription);
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, isReachEnd, error);
            return;
        }
        
        id pattern = [[NSBundle mainBundle] jsonFromResource:@"recommendReposPattern.json"];
        BOOL valid = [self.jsonValidation verifyJSON:cloudObjects pattern:pattern];
        if (!valid) {
            NSString *errorMessage = [NSString stringWithFormat:@"server data formate invalid,content: <%@>", cloudObjects];
            error = [MLGMError errorWithCode:MLGMErrorTypeServerDataFormateError message:errorMessage];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, isReachEnd, error);
            return;
        }
        
        NSMutableArray *repoMOs = [NSMutableArray new];
        [cloudObjects enumerateObjectsUsingBlock:^(NSDictionary *oneRepoDic, NSUInteger idx, BOOL * _Nonnull stop) {
            MLGMRepo *oneRepoMO = [MLGMRepo MR_createEntityInContext:self.scratchContext];
            [oneRepoMO fillRecommendationObject:oneRepoDic];
            [repoMOs addObject:oneRepoMO];
        }];
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, [repoMOs copy], isReachEnd, nil);
    }];

}

- (void)initializeGenesFromGitHubAndMaxLeapToLocalDBComletion:(void(^)(BOOL succeeded, NSError *error))completion {
    if (kOnlineAccount.isInitializeGene.boolValue) {
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, YES, nil);
        return;
    }
    
    [self genesFromGitHubCompletion:^(NSArray *allGeneMOs, NSError *error) {
        if (error) {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, NO, error);
            return;
        }
        
        [self genesFromMaxLeapCompletion:^(NSArray *allGeneMLOs, NSError *error) {
            if (error) {
                BLOCK_SAFE_ASY_RUN_MainQueue(completion, NO, error);
                return;
            }
            
            [allGeneMLOs enumerateObjectsUsingBlock:^(MLObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *language = obj[@"language"];;
                NSString *skill = obj[@"skill"];
                NSPredicate *p = [NSPredicate predicateWithFormat:@"language = %@ and skill = %@", language, skill];
                NSArray *filtedArray = [MLGMGene MR_findAllWithPredicate:p];
                if ([filtedArray count] == 0) {
                    MLGMGene *geneMO = [MLGMGene MR_createEntity];
                    geneMO.language = obj[@"language"];
                    geneMO.skill = obj[@"skill"];
                    geneMO.updateTime = obj[@"updateTime"];
                    geneMO.userProfile = kOnlineAccountProfile;
                    [self.defaultContext MR_saveToPersistentStoreAndWait];
                }
            }];
            
            kOnlineAccount.isInitializeGene = @YES;
            [self.defaultContext MR_saveToPersistentStoreAndWait];
            
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, YES, nil);
        }];
    }];
}

- (void)genesFromMaxLeapCompletion:(void(^)(NSArray *allGeneMLOs, NSError *error))completion {
    MLQuery *query = [MLQuery queryWithClassName:@"Gene"];
    [query whereKey:@"githubName" equalTo:kOnlineUserName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *allGeneMLOs, NSError *error) {
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, allGeneMLOs, error);
    }];
}

/**
 * 从github返回本地没有的gene
 */
- (void)genesFromGitHubCompletion:(void(^)(NSArray *allGeneMOs, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/users/%@/repos", kOnlineUserName];
    NSDictionary *parameters = @{@"page" : @(1), @"per_page" : @(kPerPage)};
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:parameters];
    [self startRequest:urlRequest patternFile:@"reposPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, NSArray *responseObjects, NSError *error) {
        if (error) {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, error);
            DDLogError(@"access /users/%@/repos api error:%@", kOnlineUserName, error.localizedDescription);
            return;
        }
        
        NSMutableArray *allGeneMOs = [NSMutableArray new];
        [responseObjects enumerateObjectsUsingBlock:^(NSDictionary *oneRepoDic, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *language = oneRepoDic[@"language"];
            if ([language isKindOfClass:[NSNull class]]) {
                return;
            }
            
            MLGMGene *existedGene = [MLGMGene MR_findFirstByAttribute:@"language" withValue:language];
            if (existedGene) {
                return;
            }
            
            NSArray *inBuildGenes = [[NSBundle mainBundle] plistObjectFromResource:@"GeneInBuild.plist"];
            [inBuildGenes enumerateObjectsUsingBlock:^(NSDictionary *oneKindOfGenes, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *oneLanguage = [oneKindOfGenes.allKeys firstObject];
                if ([oneLanguage isEqualToString:language]) {
                    NSArray *kills = oneKindOfGenes[oneLanguage];
                    [kills enumerateObjectsUsingBlock:^(NSString *skill, NSUInteger idx, BOOL *stop) {
                        MLGMGene *gene = [MLGMGene MR_createEntity];
                        gene.language = language;
                        gene.skill = skill;
                        gene.updateTime = [NSDate date];
                        gene.userProfile = kOnlineAccountProfile;
                        [allGeneMOs addObject:gene];
                    }];
                }
            }];
        }];
        
        [self.defaultContext MR_saveToPersistentStoreAndWait];
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, allGeneMOs, nil);
    }];
}

- (void)syncOnlineAccountProfileToMaxLeapCompletion:(void (^)(BOOL succeeded, NSError *error))completion {
    [MLUser logInWithUsernameInBackground:kOnlineUserName password:kMaxLeapUserPassword block:^(MLUser *user, NSError *error) {
        if (user) {
            user[@"nickName"] = kOnlineAccountProfile.nickName;
            user[@"avatarUrl"] = kOnlineAccountProfile.avatarUrl;
            user[@"blog"] = kOnlineAccountProfile.blog;
            user[@"company"] = kOnlineAccountProfile.company;
            user[@"location"] = kOnlineAccountProfile.location;
            user[@"hireable"] = kOnlineAccountProfile.hireable.boolValue ? @YES : @NO;
            user[@"followerCount"] = kOnlineAccountProfile.followerCount;
            user[@"followingCount"] = kOnlineAccountProfile.followingCount;
            user[@"publicRepoCount"]  = kOnlineAccountProfile.publicRepoCount;
            user[@"githubCreateTime"] = kOnlineAccountProfile.githubCreatTime;
            user[@"githubUpdateTime"] = kOnlineAccountProfile.githubUpdateTime;
            
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    DDLogError(@"update user %@ profile to maxleap error:%@", kOnlineUserName, error.localizedDescription);
                }
                BLOCK_SAFE_ASY_RUN_MainQueue(completion, succeeded, error);
            }];
        } else if (!user && error.code == kMLErrorUserNotFound) {
            user = [MLUser user];
            user.username = kOnlineUserName;
            user.password = kMaxLeapUserPassword;
            user[@"nickName"] = kOnlineAccountProfile.nickName;
            user[@"avatarUrl"] = kOnlineAccountProfile.avatarUrl;
            user[@"blog"] = kOnlineAccountProfile.blog;
            user[@"company"] = kOnlineAccountProfile.company;
            user[@"location"] = kOnlineAccountProfile.location;
            user[@"hireable"] = kOnlineAccountProfile.hireable.boolValue ? @YES : @NO;
            user[@"followerCount"] = kOnlineAccountProfile.followerCount;
            user[@"followingCount"] = kOnlineAccountProfile.followingCount;
            user[@"publicRepoCount"]  = kOnlineAccountProfile.publicRepoCount;
            user[@"githubCreateTime"] = kOnlineAccountProfile.githubCreatTime;
            user[@"githubUpdateTime"] = kOnlineAccountProfile.githubUpdateTime;
            
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    DDLogError(@"sign up user %@ to maxleap error:%@", kOnlineUserName, error.localizedDescription);
                }
                
                BLOCK_SAFE_ASY_RUN_MainQueue(completion, succeeded, error);
            }];
        } else {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, NO, error);
        }
    }];
}

- (void)syncOnlineAccountGenesToMaxLeapCompletion:(void (^)(BOOL succeeded, NSError *error))completion {
    NSMutableArray *geneMLOsToInsertToMaxLeap = [NSMutableArray new];
    NSMutableArray *geneMLOsToDeleteFromMaxLeap = [NSMutableArray new];
    
    MLQuery *queryForGene = [MLQuery queryWithClassName:@"Gene"];
    [queryForGene whereKey:@"githubName" equalTo:kOnlineUserName];
    
    [queryForGene findObjectsInBackgroundWithBlock:^(NSArray *allGeneMLOs, NSError *error) {
        if (error) {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, NO, error);
            return;
        }
        
        [kOnlineAccountProfile.genes enumerateObjectsUsingBlock:^(MLGMGene * oneGeneMO, BOOL * stop) {
            NSPredicate *p = [NSPredicate predicateWithBlock:^BOOL(MLObject *evaluatedObject, NSDictionary<NSString *,id> * bindings) {
                return [evaluatedObject[@"language"] isEqualToString:oneGeneMO.language] && [evaluatedObject[@"skill"] isEqualToString:oneGeneMO.skill];
            }];

            NSArray *filtedArray = [allGeneMLOs filteredArrayUsingPredicate:p];
            if ([filtedArray count] == 0) {
                MLObject *oneGeneMLO = [MLObject objectWithClassName:@"Gene"];
                oneGeneMLO[@"githubName"] = kOnlineUserName;
                oneGeneMLO[@"language"] = oneGeneMO.language;
                oneGeneMLO[@"skill"] = oneGeneMO.skill;
                oneGeneMLO[@"updateTime"] = oneGeneMO.updateTime;
                
                [geneMLOsToInsertToMaxLeap addObject:oneGeneMLO];
            }
        }];
        
        [allGeneMLOs enumerateObjectsUsingBlock:^(MLObject *oneGeneMLO, NSUInteger idx, BOOL * stop) {
            NSPredicate *p = [NSPredicate predicateWithFormat:@"language = %@ and skill = %@", oneGeneMLO[@"language"], oneGeneMLO[@"skill"]];
            NSSet *filtedSet = [kOnlineAccountProfile.genes filteredSetUsingPredicate:p];
            if ([filtedSet count] == 0) {
                [geneMLOsToDeleteFromMaxLeap addObject:oneGeneMLO];
            }
        }];
        
        [MLObject saveAllInBackground:geneMLOsToInsertToMaxLeap block:^(BOOL succeeded, NSError *error) {
            if (error) {
                DDLogError(@"save new gene to maxleap occur error:%@", error.localizedDescription);
                BLOCK_SAFE_ASY_RUN_MainQueue(completion, succeeded, error);
            } else {
                [MLObject deleteAllInBackground:geneMLOsToDeleteFromMaxLeap block:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        DDLogError(@"delete new gene from maxleap occur error:%@", error.localizedDescription);
                    }
                    BLOCK_SAFE_ASY_RUN_MainQueue(completion, succeeded, error);
                }];
            }
        }];
    }];
}

@end
