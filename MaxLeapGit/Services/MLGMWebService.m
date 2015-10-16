//
//  MLGMWebService.m
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/9.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import <LeapCloud/LeapCloud.h>
#import "MLGMWebService.h"
#import "MLGMWebService+Convenience.h"
#import "MLGMAccount.h"
#import "MLGMActorProfile.h"
#import "MLGMEvent.h"
#import "MLGMRepo.h"
#import "MLGMGene.h"

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

- (void)updateAccountProfileCompletion:(void(^)(MLGMAccount *account, NSError *error))completion {
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:@"/user" parameters:nil];
    [self startRquest:urlRequest patternFile:@"userPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, id responseObject, NSError *error) {
        if (error) {
            DDLogError(@"access /user api error:%@", error.localizedDescription);
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, error);
            return;
        }
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            MLGMAccount *accountMOC = [MLGMAccount MR_findFirstByAttribute:@"isOnline" withValue:@(YES) inContext:localContext];
            MLGMActorProfile *userProfileMOC = accountMOC.actorProfile;
            if (!userProfileMOC) {
                userProfileMOC = [MLGMActorProfile MR_createEntityInContext:localContext];
                accountMOC.actorProfile = userProfileMOC;
            }
            
            [userProfileMOC fillProfile:responseObject];
        } completion:^(BOOL contextDidSave, NSError *error) {
            if (error) {
                DDLogError(@"/user api data save core data error:%@", error.localizedDescription);
            }
            
            MLGMAccount *account = [MLGMAccount MR_findFirstByAttribute:@"isOnline" withValue:@(YES)];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, account, error);
        }];
    }];
}

- (void)userProfileForUserName:(NSString *)userName completion:(void(^)(MLGMActorProfile *userProfile, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/users/%@", userName];
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:nil];
    [self startRquest:urlRequest patternFile:@"userPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, id responseObject, NSError *error) {
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

- (void)organizationsForUserName:(NSString *)userName fromPage:(NSUInteger)page completion:(void(^)(NSArray *orgMOCs, BOOL isRechEnd, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/users/%@/orgs", userName];
    NSDictionary *parameters = @{@"page" : @(page), @"per_page" : @(kPerPage)};
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:parameters];
    [self startRquest:urlRequest patternFile:@"organizationPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, NSArray *responseObject, NSError *error) {
        if (error) {
            DDLogError(@"access /user/%@/orgs api error:%@", userName, error.localizedDescription);
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, NO, error);
            return;
        }
        
        NSMutableArray *orgMOCs = [NSMutableArray new];
        [responseObject enumerateObjectsUsingBlock:^(NSDictionary *oneOrgDic, NSUInteger idx, BOOL * _Nonnull stop) {
            MLGMActorProfile *oneOrgProfile = [MLGMActorProfile MR_findFirstOrCreateByAttribute:@"loginName" withValue:oneOrgDic[@"login"] inContext:self.scratchContext];
            [oneOrgProfile fillOrg:oneOrgDic];
            [orgMOCs addObject:oneOrgProfile];
        }];
        
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, [orgMOCs copy], [orgMOCs count] < kPerPage, nil);
    }];
}

- (void)organizationCountForUserName:(NSString *)userName completion:(void(^)(NSUInteger orgCount, NSError *error))completion; {
    NSString *endPoint = [NSString stringWithFormat:@"/users/%@/orgs", userName];
    NSDictionary *parameters = @{@"page" : @(1), @"per_page" : @(1)};
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:parameters];
    [self startRquest:urlRequest patternFile:@"organizationPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, NSArray *responseObject, NSError *error) {
        if (error) {
            DDLogError(@"access /user/%@/orgs api error:%@",userName, error.localizedDescription);
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, 0, error);
            return;
        }
        
        int orgCount = totalPageInHeadField(responHeaderFields);
        
        MLGMActorProfile *userProfile = [MLGMActorProfile MR_findFirstByAttribute:@"loginName" withValue:userName inContext:self.defaultContext];
        if (userProfile) {
            userProfile.organizations = @(orgCount);
        }
        [self.defaultContext MR_saveToPersistentStoreAndWait];
        
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, orgCount, nil);
    }];
}

- (void)organizationUpdateDateForOrgName:(NSString *)orgName completion:(void(^)(NSDate *updatedAt, NSString *orgName, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/orgs/%@", orgName];
    NSURLRequest *request = [self getRequestWithEndPoint:endPoint parameters:nil];
    [self startRquest:request patternFile:@"userPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, NSDictionary *responseObject, NSError *error) {
        if (error) {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, orgName, error);
            DDLogError(@"access orgs/%@/ api error:%@", orgName, error.localizedDescription);
            return;
        }
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            MLGMActorProfile *orgProfileMOC = [MLGMActorProfile MR_findFirstOrCreateByAttribute:@"loginName" withValue:orgName inContext:localContext];
            [orgProfileMOC fillProfile:responseObject];
        } completion:^(BOOL contextDidSave, NSError *error) {
            if (error) {
                DDLogError(@"access /orgs/%@ api error:%@", orgName, error.localizedDescription);
            }
            
            MLGMActorProfile *orgProfile = [MLGMActorProfile MR_findFirstByAttribute:@"loginName" withValue:orgName];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, orgProfile.githubUpdatedAt, orgName, error);
        }];
    }];
}

- (void)starCountForUserName:(NSString *)userName completion:(void(^)(NSUInteger starCount, NSString *userName, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/users/%@/starred", userName];
    NSDictionary *parameters = @{@"page" : @(1), @"per_page" : @(1)};
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:parameters];
    [self startRquest:urlRequest patternFile:@"reposPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, NSArray *responseObject, NSError *error) {
        if (error) {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, 0, userName, error);
            DDLogError(@"access /user/%@/starred api error:%@", userName, error.localizedDescription);
            return;
        }
        
        int starCount = totalPageInHeadField(responHeaderFields);
        
        MLGMActorProfile *userProfile = [MLGMActorProfile MR_findFirstByAttribute:@"loginName" withValue:userName inContext:self.defaultContext];
        if (userProfile) {
            userProfile.starts = @(starCount);
        }
        [self.defaultContext MR_saveToPersistentStoreAndWait];
        
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, starCount, userName, nil);
    }];
}

- (void)timeLineForUserName:(NSString *)userName fromPage:(NSUInteger)page completion:(void(^)(NSArray *events, BOOL isRechEnd, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/users/%@/received_events", userName];
    NSDictionary *parameters = @{@"page" : @(page), @"per_page" : @(kPerPage)};
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:parameters];
    [self startRquest:urlRequest patternFile:@"organizationPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, NSArray *responseObject, NSError *error) {
        if (error) {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, YES, error);
            DDLogError(@"access /user/%@/orgs api error:%@", userName, error.localizedDescription);
            return;
        }
        
        NSMutableArray *eventMOCs = [NSMutableArray new];
        [responseObject enumerateObjectsUsingBlock:^(NSDictionary *oneEventDic, NSUInteger idx, BOOL * stop) {
            NSString *type = oneEventDic[@"type"];
            if ([supportEvent() containsObject:type]) {
                MLGMEvent *oneEventMOC = [MLGMEvent MR_createEntityInContext:self.scratchContext];
                [oneEventMOC fillObject:oneEventDic];
                [eventMOCs addObject:oneEventMOC];
            }
        }];
        
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, [eventMOCs copy], [responseObject count] < kPerPage, nil);
    }];
}

- (void)isUserName:(NSString *)sourceUserName followTargetUserName:(NSString *)targetUserName completion:(void(^)(BOOL isFollow, NSString *targetUserName, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/users/%@/following/%@", sourceUserName, targetUserName];
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:nil];
    [self startRquest:urlRequest patternFile:nil completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, id responseData, NSError *error) {
        
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
    [self startRquest:urlRequest patternFile:nil completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, id responseData, NSError *error) {
        
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
    [self startRquest:urlRequest patternFile:nil completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, id responseData, NSError *error) {
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

- (void)followerListForUserName:(NSString *)userName fromPage:(NSUInteger)page completion:(void(^)(NSArray *userProfiles, BOOL isRechEnd, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/users/%@/followers", userName];
    NSDictionary *parameters = @{@"page" : @(page), @"per_page" : @(kPerPage)};
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:parameters];
    [self startRquest:urlRequest patternFile:@"followerPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, NSArray *responseObject, NSError *error) {
        if (error) {
            DDLogError(@"access /user/%@/orgs api error:%@", userName, error.localizedDescription);
            
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, NO, error);
            return;
        }
        
        NSMutableArray *followMOCs = [NSMutableArray new];
        [responseObject enumerateObjectsUsingBlock:^(NSDictionary *oneFollowDic, NSUInteger idx, BOOL * stop) {
            MLGMActorProfile *oneFollowMOC = [MLGMActorProfile MR_createEntityInContext:self.scratchContext];
            [oneFollowMOC fillFollow:oneFollowDic];
            [followMOCs addObject:oneFollowMOC];
        }];
        
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, [followMOCs copy], [responseObject count] < kPerPage, nil);
    }];
}

- (void)followingListForUserName:(NSString *)userName fromPage:(NSUInteger)page completion:(void(^)(NSArray *userProfile, BOOL isRechEnd, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/users/%@/following", userName];
    NSDictionary *parameters = @{@"page" : @(page), @"per_page" : @(kPerPage)};
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:parameters];
    [self startRquest:urlRequest patternFile:@"followerPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, NSArray *responseObject, NSError *error) {
        if (error) {
            DDLogError(@"access /user/%@/received_events api error:%@", userName, error.localizedDescription);
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, NO, error);
            return;
        }
        
        NSMutableArray *followMOCs = [NSMutableArray new];
        [responseObject enumerateObjectsUsingBlock:^(NSDictionary *oneFollowDic, NSUInteger idx, BOOL * stop) {
            MLGMActorProfile *oneUsrProfileMOC = [MLGMActorProfile MR_findFirstOrCreateByAttribute:@"loginName" withValue:oneFollowDic[@"login"] inContext:self.scratchContext];
            [oneUsrProfileMOC fillFollow:oneFollowDic];
            [followMOCs addObject:oneUsrProfileMOC];
        }];
        
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, [followMOCs copy], [followMOCs count] < kPerPage, nil);
    }];
}

- (void)staredReposForUserName:(NSString *)userName fromPage:(NSUInteger)page completion:(void(^)(NSArray *repos, BOOL isRechEnd, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/users/%@/starred", userName];
    NSDictionary *parameters = @{@"page" : @(page), @"per_page" : @(kPerPage)};
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:parameters];
    [self startRquest:urlRequest patternFile:@"reposPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, NSArray *responseObject, NSError *error) {
        if (error) {
            DDLogError(@"access /user/%@/starred api error:%@", userName, error.localizedDescription);
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, NO, error);
            return;
        }
        
        NSMutableArray *repoMOCs = [NSMutableArray new];
        [responseObject enumerateObjectsUsingBlock:^(NSDictionary *oneRepoDic, NSUInteger idx, BOOL * _Nonnull stop) {
            MLGMRepo *oneRepoMOC = [MLGMRepo MR_createEntityInContext:self.scratchContext];
            [oneRepoMOC fillObject:oneRepoDic];
            [repoMOCs addObject:oneRepoMOC];
        }];
        
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, [repoMOCs copy], [repoMOCs count] < kPerPage, nil);
    }];
}

- (void)publicRepoForUserName:(NSString *)userName fromPage:(NSUInteger)page completion:(void(^)(NSArray *repos, BOOL isRechEnd, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/users/%@/repos", userName];
    NSDictionary *parameters = @{@"page" : @(page), @"per_page" : @(kPerPage)};
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:parameters];
    [self startRquest:urlRequest patternFile:@"reposPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, NSArray *responseObject, NSError *error) {
        if (error) {
            DDLogError(@"access /users/%@/repos api error:%@", userName, error.localizedDescription);
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, NO, error);
            return;
        }
        
        NSMutableArray *repoMOCs = [NSMutableArray new];
        [responseObject enumerateObjectsUsingBlock:^(NSDictionary *oneRepoDic, NSUInteger idx, BOOL * _Nonnull stop) {
            MLGMRepo *oneRepoMOC = [MLGMRepo MR_createEntityInContext:self.scratchContext];
            [oneRepoMOC fillObject:oneRepoDic];
            [repoMOCs addObject:oneRepoMOC];
        }];
        
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, [repoMOCs copy], [repoMOCs count] < kPerPage, nil);
    }];
}

- (void)isStarRepo:(NSString *)repoName completion:(void(^)(BOOL isStar, NSString *repoName, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/user/starred/%@", repoName];
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:nil];
    [self startRquest:urlRequest patternFile:nil completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, id responseData, NSError *error) {
        NSPredicate *p = [NSPredicate predicateWithFormat:@"loginName = %@ and repoName = %@", kOnlineUserName, repoName];
        MLGMStarRelation *starRelation = [MLGMStarRelation MR_findFirstWithPredicate:p inContext:self.defaultContext];
        if (!starRelation) {
            starRelation = [MLGMStarRelation MR_createEntityInContext:self.defaultContext];
        }
        
        if (statusCode == 204) {
            starRelation.loginName = kOnlineUserName;
            starRelation.repoName = repoName;
            starRelation.isStar = @YES;
            [self.defaultContext MR_saveToPersistentStoreAndWait];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, YES, repoName, nil);
        } else if (statusCode == 404) {
            starRelation.loginName = kOnlineUserName;
            starRelation.repoName = repoName;
            starRelation.isStar = @NO;
            [self.defaultContext MR_saveToPersistentStoreAndWait];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, NO, repoName, nil);
        } else {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, NO, repoName, error);
        }
    }];
}

- (void)starRepo:(NSString *)repoName completion:(void(^)(BOOL success, NSString *repoName, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/user/starred/%@", repoName];
    NSURLRequest *urlRequest = [self putRequestWithEndPoint:endPoint parameters:nil];
    [self startRquest:urlRequest patternFile:nil completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, id responseData, NSError *error) {
        NSPredicate *p = [NSPredicate predicateWithFormat:@"loginName = %@ and repoName = %@", kOnlineUserName, repoName];
        MLGMStarRelation *starRelation = [MLGMStarRelation MR_findFirstWithPredicate:p inContext:self.defaultContext];
        if (!starRelation) {
            starRelation = [MLGMStarRelation MR_createEntityInContext:self.defaultContext];
        }
        
        if (statusCode == 204) {
            starRelation.loginName = kOnlineUserName;
            starRelation.repoName = repoName;
            starRelation.isStar = @YES;
            [self.defaultContext MR_saveToPersistentStoreAndWait];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, YES, repoName, nil);
        } else {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, NO, repoName, nil);
        }
    }];
}

- (void)unstarRepo:(NSString *)repoName completion:(void(^)(BOOL success, NSString *repoName, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/user/starred/%@", repoName];
    NSURLRequest *urlRequest = [self deleteRequestWithEndPoint:endPoint parameters:nil];
    [self startRquest:urlRequest patternFile:nil completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, id responseData, NSError *error) {
        NSPredicate *p = [NSPredicate predicateWithFormat:@"loginName = %@ and repoName = %@", kOnlineUserName, repoName];
        MLGMStarRelation *starRelation = [MLGMStarRelation MR_findFirstWithPredicate:p inContext:self.defaultContext];
        if (!starRelation) {
            starRelation = [MLGMStarRelation MR_createEntityInContext:self.defaultContext];
        }
        
        if (statusCode == 204) {
            starRelation.loginName = kOnlineUserName;
            starRelation.repoName = repoName;
            starRelation.isStar = @NO;
            [self.defaultContext MR_saveToPersistentStoreAndWait];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, YES, repoName, nil);
        } else {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, NO, repoName, nil);
        }
    }];
}

- (void)forkRepo:(NSString *)repoName completion:(void(^)(BOOL success, NSString *repoName, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/repos/%@/forks", repoName];
    NSURLRequest *urlRequest = [self postRequestWithEndPoint:endPoint parameters:nil];
    [self startRquest:urlRequest patternFile:nil completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, id responseData, NSError *error) {
        if (statusCode == 202) {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, YES, repoName, nil);
        } else {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, NO, repoName, nil);
        }
    }];
}

- (void)clearCacheData {
    NSArray *allEntities = [NSManagedObjectModel MR_defaultManagedObjectModel].entities;
    
    [allEntities enumerateObjectsUsingBlock:^(NSEntityDescription *entityDescription, NSUInteger idx, BOOL *stop) {
        [NSClassFromString([entityDescription managedObjectClassName]) MR_truncateAll];
    }];
}

- (void)saveGeneToMaxLeap:(MLGMGene *)gene completion:(void(^)(BOOL success, NSError *error))completion {
    MLGMAccount *account = [MLGMAccount MR_findFirstByAttribute:@"isOnline" withValue:@(YES)];
    if (!account) {
        NSError *error = [MLGMError errorWithCode:MLGMErrorTypeNoOnlineAccount message:nil];
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, NO, error);
    }
    
    NSNumber *loginName = account.actorProfile.loginName;
    LCObject *lasObj = [LCObject objectWithClassName:@"Gene"
                                          dictionary:@{@"language":gene.language, @"skill": gene.skill, @"userName" : @"xdream86"}];
    [lasObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"%d", succeeded);
    }];
}

- (void)geneForUserName:(NSString *)userName completion:(void(^)())completion {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName = %@", userName];
    LCQuery *query = [LCQuery queryWithClassName:@"Gene" predicate:predicate];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [objects enumerateObjectsUsingBlock:^(LCObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *userName = [obj valueForKey:@"userName"];
            NSString *language = [obj valueForKey:@"language"];
            NSString *skill  = [obj valueForKey:@"skill"];
            NSLog(@"%@, %@, %@", userName, language, skill);
        }];
    }];
}

#pragma mark - Search
- (void)searchByRepoName:(NSString *)repoName sortType:(MLGMSearchRepoSortType)sortType fromPage:(NSUInteger)page completion:(void(^)(NSArray *repos, BOOL isRechEnd, NSError *error))completion {
    if (repoName.length == 0) {
        return;
    }
    NSString *sortString = [self repoSortMethodForType:sortType];
    NSString *endPoint = @"/search/repositories";
    NSDictionary *parameters = @{@"q":repoName,@"sort":sortString, @"page" : @(page), @"per_page" : @(kPerPage)};
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:parameters];
    [self startRquest:urlRequest patternFile:nil completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, id responseData, NSError *error) {
        if (error) {
            return;
        }
        
        if (responseData && [responseData isKindOfClass:[NSDictionary class]]) {
            NSArray *items = responseData[@"items"];
            NSMutableArray *repoMOCs = [NSMutableArray new];
            [items enumerateObjectsUsingBlock:^(NSDictionary *oneRepoDic, NSUInteger idx, BOOL * _Nonnull stop) {
                MLGMRepo *oneRepoMOC = [MLGMRepo MR_createEntityInContext:self.scratchContext];
                [oneRepoMOC fillObject:oneRepoDic];
                [repoMOCs addObject:oneRepoMOC];
            }];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, [repoMOCs copy], [repoMOCs count] < kPerPage, nil);
        }
    }];
}

- (void)searchByUserName:(NSString *)userName sortType:(MLGMSearchUserSortType)sortType fromPage:(NSUInteger)page completion:(void(^)(NSArray *users, BOOL isReachEnd, NSError *error))completion {
    if (userName.length == 0) {
        return;
    }
    NSString *sortString = [self userSortMethodForType:sortType];
    NSString *endPoint = @"/search/users";
    NSDictionary *parameters = @{@"q":userName, @"sort":sortString, @"page" : @(1), @"per_page" : @(kPerPage)};
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:parameters];
    [self startRquest:urlRequest patternFile:nil completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, id responseData, NSError *error) {
        if (error) {
            return;
        }
        
        if (responseData && [responseData isKindOfClass:[NSDictionary class]]) {
            NSArray *items = responseData[@"items"];
            NSMutableArray *userMOCs = [NSMutableArray new];
            [items enumerateObjectsUsingBlock:^(NSDictionary *oneUserDic, NSUInteger idx, BOOL * _Nonnull stop) {
                MLGMActorProfile *oneUserMOC = [MLGMActorProfile MR_createEntityInContext:self.scratchContext];
                [oneUserMOC fillProfile:oneUserDic];
                [userMOCs addObject:oneUserMOC];
            }];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, [userMOCs copy], [userMOCs count] < kPerPage, nil);
        }
    }];
}

//sort=stars, forks, or updated. Default: results are sorted by best match
- (NSString *)repoSortMethodForType:(MLGMSearchRepoSortType)type {
    NSString *sortMethodName = nil;
    switch (type) {
        case MLGMSearchRepoSortTypeStars: sortMethodName = @"stars"; break;
        case MLGMSearchRepoSortTypeForks: sortMethodName = @"forks"; break;
        case MLGMSearchRepoSortTypeRecentlyUpdated: sortMethodName = @"updated"; break;
        default: sortMethodName = @""; break;
    }
    return sortMethodName;
}

//sort = followers, repositories, or joined. Default: results are sorted by best
//match.
- (NSString *)userSortMethodForType:(MLGMSearchUserSortType)type {
    NSString *sortMethodName = nil;
    switch (type) {
        case MLGMSearchUserSortTypeFollowers: sortMethodName = @"followers"; break;
        case MLGMSearchUserSortTypeRepos: sortMethodName = @"repositories"; break;
        case MLGMSearchUserSortTypeJoined: sortMethodName = @"joined"; break;
        default: sortMethodName = @""; break;
    }
    return sortMethodName;
}

#pragma mark - Genes
- (void)fetchGenesForUserName:(NSString *)userName completion:(void(^)(NSArray *genes, NSError *error))completion {
    [self fetchGenesFromMaxLeapForUsername:userName completion:^(NSSet<NSDictionary *> *maxLeapGenes, NSError *error) {

        BOOL githubGenesInitializeded = NO;
        if (githubGenesInitializeded) {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, [maxLeapGenes copy], nil);
            
        } else {
            NSLog(@"maxLeapGenes = %@", maxLeapGenes);

            __block NSSet *maxLeapGenesSet = maxLeapGenes;
            [self analyzeGitHubGenesForUserName:userName completion:^(NSSet<NSDictionary *> *githubGenes, NSError *error) {
                NSSet *mergedGenesSet = [maxLeapGenesSet setByAddingObjectsFromSet:githubGenes];
                NSLog(@"gitHubGenes = %@", githubGenes);
                NSLog(@"======= Final: genesDictSet = %@", mergedGenesSet);
                
                NSArray *genesArray = [self saveGenesToMagicalRecord:mergedGenesSet];
                
                BLOCK_SAFE_ASY_RUN_MainQueue(completion, [genesArray copy], nil);
            }];
        }
    }];
}

- (NSArray *)saveGenesToMagicalRecord:(NSSet<NSDictionary *> *)genesSet {
    NSMutableArray *genesArray = [NSMutableArray array];
    NSMutableSet *geneMOCs = [NSMutableSet set];
    [genesSet enumerateObjectsUsingBlock:^(NSDictionary *genePair, BOOL * _Nonnull stop) {
        MLGMGene *gene = [MLGMGene MR_createEntityInContext:self.defaultContext];
        [gene fillObject:genePair];
        [geneMOCs addObject:gene];
        [genesArray addObject:gene];
    }];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        MLGMAccount *accountMOC = [MLGMAccount MR_findFirstByAttribute:@"isOnline" withValue:@(YES) inContext:self.defaultContext];
        MLGMActorProfile *userProfileMOC = accountMOC.actorProfile;
        [userProfileMOC addGenes:geneMOCs];
        
    } completion:^(BOOL contextDidSave, NSError *error) {
        NSLog(@"contextDidSave = %d, error = %@", contextDidSave, error);
    }];
    
    return [NSArray arrayWithArray:genesArray];
}

#pragma mark - Private Methods
- (void)fetchGenesFromMaxLeapForUsername:(NSString *)userName completion:(void(^)(NSSet<NSDictionary *> *genes, NSError *error))completion {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName = %@", userName];
    LCQuery *query = [LCQuery queryWithClassName:@"Gene" predicate:predicate];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableSet *genesSet = [NSMutableSet set];
        [objects enumerateObjectsUsingBlock:^(LCObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *userName = [obj objectForKey:@"userName"];
            NSString *language = [obj objectForKey:@"language"];
            NSString *skill  = [obj objectForKey:@"skill"];
            NSDictionary *genePair = @{@"language":language, @"skill":skill, @"userName":userName};
            [genesSet addObject:genePair];
        }];
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, [genesSet copy], nil);
    }];
}

//Analyze user genes based on GitHub repos -- Default:analyze 30 repos
- (void)analyzeGitHubGenesForUserName:(NSString *)userName completion:(void(^)(NSSet<NSDictionary *> *genes, NSError *error))completion {
    NSString *endPoint = [NSString stringWithFormat:@"/users/%@/repos", userName];
    NSDictionary *parameters = @{@"page" : @(1), @"per_page" : @(kPerPage)};
    NSURLRequest *urlRequest = [self getRequestWithEndPoint:endPoint parameters:parameters];
    [self startRquest:urlRequest patternFile:@"reposPattern.json" completion:^(NSDictionary *responHeaderFields, NSInteger statusCode, NSArray *responseObjects, NSError *error) {
        if (error) {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, error);
            return;
        }
       
        NSMutableSet *genesDictSet = [NSMutableSet set];
        [responseObjects enumerateObjectsUsingBlock:^(NSDictionary *oneRepoDic, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *language = oneRepoDic[@"language"];
            NSDictionary *supportedGenesDict = kMLGMSupportedGenesDict;
            [supportedGenesDict.allKeys enumerateObjectsUsingBlock:^(NSString *oneLanguage, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([language isKindOfClass:[NSString class]] && [[language lowercaseString] isEqualToString:[oneLanguage lowercaseString]]) {
                    NSArray *skills = supportedGenesDict[oneLanguage];
                    [skills enumerateObjectsUsingBlock:^(NSString *oneSkill, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSDictionary *genePair = @{@"language":oneLanguage, @"skill":oneSkill, @"userName":userName};
                        [genesDictSet addObject:genePair];
                    }];
                }
            }];
        }];

        BLOCK_SAFE_ASY_RUN_MainQueue(completion, [genesDictSet copy], nil);
    }];
}

- (void)saveGenesToMaxLeap:(NSArray *)genes completion:(void(^)(BOOL success, NSError *error))completion {
    MLGMAccount *account = [MLGMAccount MR_findFirstByAttribute:@"isOnline" withValue:@(YES)];
    if (!account) {
        NSError *error = [MLGMError errorWithCode:MLGMErrorTypeNoOnlineAccount message:nil];
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, NO, error);
    }
    
    NSMutableArray *lasObjs = [NSMutableArray array];
    [genes enumerateObjectsUsingBlock:^(MLGMGene *gene, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *loginName = account.actorProfile.loginName;
        LCObject *lasObj = [LCObject objectWithClassName:@"Gene"
                                              dictionary:@{@"language":gene.language, @"skill": gene.skill, @"userName" : loginName}];
        [lasObjs addObject:lasObj];
    }];
    
    [LCObject saveAllInBackground:lasObjs block:^(BOOL succeeded, NSError *error) {
        NSLog(@"save to maxLeap: objs = %@, status = %d", lasObjs, succeeded);
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, YES, error);
    }];
}

@end
