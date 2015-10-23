//
//  MLGMAccountManager.h
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/9.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSharedWebService [MLGMAccountManager sharedInstance]

typedef NS_ENUM(NSUInteger, MLGMSearchRepoSortType) {
    MLGMSearchRepoSortTypeDefault = 0,
    MLGMSearchRepoSortTypeStars = 1,
    MLGMSearchRepoSortTypeForks = 2,
    MLGMSearchRepoSortTypeRecentlyUpdated = 3
};

typedef NS_ENUM(NSUInteger, MLGMSearchUserSortType) {
    MLGMSearchUserSortTypeDefault = 0,
    MLGMSearchUserSortTypeFollowers = 1,
    MLGMSearchUserSortTypeRepos = 2,
    MLGMSearchUserSortTypeJoined = 3
};

static NSUInteger const kPerPage = 25;

@interface MLGMAccountManager : NSObject

+ (MLGMAccountManager *)sharedInstance;

/**
 * 账号信息
 */
- (void)updateAccountProfileToDBCompletion:(void(^)(MLGMAccount *account, NSError *error))completion;

/**
 * 检查session是否过期
 */
- (void)checkSessionTokenStatusCompletion:(void(^)(BOOL valid, NSError *error))completion;

/**
 * 特定用户的资料,不包括组织信息，以及各个组织最近活动的时间,需要另外调取下面提供的接口
 */
- (void)fetchUserProfileForUserName:(NSString *)userName completion:(void(^)(MLGMActorProfile *userProfile, NSError *error))completion;

/**
 * 指定用户的加入的组织
 */
- (void)fetchOrganizationInfoForUserName:(NSString *)userName fromPage:(NSUInteger)page completion:(void(^)(NSArray *orgMOCs, BOOL isReachEnd, NSError *error))completion;

/**
 * 指定用户加入的组织总数
 */
- (void)fetchOrganizationCountForUserName:(NSString *)userName completion:(void(^)(NSUInteger orgCount, NSError *error))completion;

/**
 * 指定组织最后一次活动时间
 */
- (void)fetchOrganizationUpdateDateForOrgName:(NSString *)orgName completion:(void(^)(NSDate *updatedAt, NSString *orgName, NSError *error))completion;

/**
 * 用户的star总数
 */
- (void)fetchStarCountForUserName:(NSString *)userName completion:(void(^)(NSUInteger starCount, NSString *userName,  NSError *error))completion;

/**
 * 时间线
 */
- (void)fetchTimeLineEventsForUserName:(NSString *)userName fromPage:(NSUInteger)page completion:(void(^)(NSArray *events, BOOL isReachEnd, NSError *error))completion;

/**
 * 检查是否已经follow了指定用户
 */
- (void)checkFollowStatusForUserName:(NSString *)sourceUserName followTargetUserName:(NSString *)targetUserName completion:(void(^)(BOOL isFollow, NSString *targetUserName, NSError *error))completion;

/**
 * 关注指定的用户
 */
- (void)followTargetUserName:(NSString *)targetUserName completion:(void(^)(BOOL isFollow, NSString *targetUserName, NSError *error))completion;

/**
 * 取消关注特定用户
 */
- (void)unfollowTargetUserName:(NSString *)targetUserName completion:(void(^)(BOOL isUnFollow, NSString *targetUserName, NSError *error))completion;

/**
 * 指定用户的follower列表
 */
- (void)fetchFollowerListForUserName:(NSString *)username fromPage:(NSUInteger)page completion:(void(^)(NSArray *userProfiles, BOOL isReachEnd, NSError *error))completion;

/**
 * 指定用户的following列表
 */
- (void)fetchFollowingListForUserName:(NSString *)username fromPage:(NSUInteger)page completion:(void(^)(NSArray *userProfiles, BOOL isReachEnd, NSError *error))completion;

/**
 * 指定用户stars或fork的项目
 */
- (void)fetchStarredReposForUserName:(NSString *)userName fromPage:(NSUInteger)page completion:(void(^)(NSArray *repos, BOOL isReachEnd, NSError *error))completion;

/**
 * 指定用户拥有的public repos
 */
- (void)fetchPublicReposForUserName:(NSString *)userName fromPage:(NSUInteger)page completion:(void(^)(NSArray *repos, BOOL isReachEnd, NSError *error))completion;

/**
 * 是否star了指定的项目,仓库名称的格式是owner/reponame
 */
- (void)checkStarStatusForRepo:(NSString *)repoName completion:(void(^)(BOOL isStar, NSString *repoName, NSError *error))completion;

/**
 * star项目
 */
- (void)starRepo:(NSString *)repoName completion:(void(^)(BOOL succeeded, NSString *repoName, NSError *error))completion;

/**
 * unstar项目
 */
- (void)unstarRepo:(NSString *)repoName completion:(void(^)(BOOL succeeded, NSString *repoName, NSError *error))completion;

/**
 *  获取推荐项目 based on Genes (language, skill): 1）GitHub Trending; 2)Search
 */
- (void)fetchRecommendationReposFromPage:(NSUInteger)page completion:(void(^)(NSArray *repos, BOOL isReachEnd, NSError *error))completion;

/**
 * fork项目
 */
- (void)forkRepo:(NSString *)repoName completion:(void(^)(BOOL succeeded, NSString *repoName, NSError *error))completion;


- (void)skipRepo:(NSString *)repoName completion:(void(^)(BOOL succeeded, NSString *repoName, NSError *error))completion;

/**
 * 搜索开源项目
 */
- (void)searchByRepoName:(NSString *)repoName sortType:(MLGMSearchRepoSortType)sortType fromPage:(NSUInteger)page completion:(void(^)(NSArray *repos, BOOL isReachEnd, NSError *error))completion;

/**
 * 搜索用户
 */
- (void)searchByUserName:(NSString *)repoName sortType:(MLGMSearchUserSortType)sortType fromPage:(NSUInteger)page completion:(void(^)(NSArray *users, BOOL isReachEnd, NSError *error))completion;

/**
 * 使用github和maxleap的记录初始化用户的gene
 */
- (void)initializeGenesFromGitHubAndMaxLeapToLocalDBComletion:(void(^)(BOOL succeeded, NSError *error))completion;

/**
 * 同步本地账号基本信息到maxleap的User表
 */
- (void)syncOnlineAccountProfileToMaxLeapCompletion:(void (^)(BOOL succeeded, NSError *error))completion;

/**
 * 同步本地账号的Gene到maxleap的Gene表
 */
- (void)syncOnlineAccountGenesToMaxLeapCompletion:(void (^)(BOOL succeeded, NSError *error))completion;

@end
