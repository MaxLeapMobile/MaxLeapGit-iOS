//
//  MLGMWebService.h
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/9.
//  Copyright © 2015年 MaxLeap. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MLGMActorProfile;
@class MLGMAccount;
@class MLGMGene;
@class MLGMEvent;
@class MLGMRepo;


static NSUInteger const kPerPage = 30;

@interface MLGMWebService : NSObject

+ (MLGMWebService *)sharedInstance;

/**
 * 清理所有缓存的数据
 */
- (void)clearCacheData;

/**
 * 账号信息
 */
- (void)updateAccountProfileCompletion:(void(^)(MLGMAccount *account, NSError *error))completion;

/**
 * 特定用户的资料,不包括组织信息，以及各个组织最近活动的时间,需要另外调取下面提供的接口
 */
- (void)userProfileForUserName:(NSString *)userName completion:(void(^)(MLGMActorProfile *userProfile, NSError *error))completion;

/**
 * 指定用户的加入的组织
 */
- (void)organizationsForUserName:(NSString *)userName fromPage:(NSUInteger)page completion:(void(^)(NSArray *orgMOCs, BOOL isRechEnd, NSError *error))completion;

/**
 * 指定用户加入的组织总数
 */
- (void)organizationCountForUserName:(NSString *)userName completion:(void(^)(NSUInteger orgCount, NSError *error))completion;

/**
 * 指定组织最后一次活动时间
 */
- (void)organizationUpdateDateForOrgName:(NSString *)orgName completion:(void(^)(NSDate *updatedAt, NSString *orgName, NSError *error))completion;

/**
 * 用户的star总数
 */
- (void)starCountForUserName:(NSString *)userName completion:(void(^)(NSUInteger starCount, NSString *userName,  NSError *error))completion;

/**
 * 时间线
 */
- (void)timeLineForUserName:(NSString *)userName fromPage:(NSUInteger)page completion:(void(^)(NSArray *events, BOOL isRechEnd, NSError *error))completion;

/**
 * 检查是否已经follow了指定用户
 */
- (void)isUserName:(NSString *)sourceUserName followTargetUserName:(NSString *)targetUserName completion:(void(^)(BOOL isFollow, NSString *targetUserName, NSError *error))completion;

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
- (void)followerListForUserName:(NSString *)username fromPage:(NSUInteger)page completion:(void(^)(NSArray *userProfiles, BOOL isRechEnd, NSError *error))completion;

/**
 * 指定用户的following列表
 */
- (void)followingListForUserName:(NSString *)username fromPage:(NSUInteger)page completion:(void(^)(NSArray *userProfiles, BOOL isRechEnd, NSError *error))completion;

/**
 * 是否star了指定的项目,仓库名称的格式是owner/reponame
 */
- (void)isStarRepo:(NSString *)repoName completion:(void(^)(BOOL isStar, NSString *repoName, NSError *error))completion;

/**
 * 指定用户stars或fork的项目
 */
- (void)reposForUserName:(NSString *)userName fromPage:(NSUInteger)page completion:(void(^)(NSArray *repos, BOOL isRechEnd, NSError *error))completion;

/**
 * star项目
 */
- (void)starRepo:(NSString *)repoName completion:(void(^)(BOOL success, NSString *repoName, NSError *error))completion;

/**
 * fork项目
 */
- (void)forkRepo:(NSString *)repoName completion:(void(^)(BOOL success, NSString *repoName, NSError *error))completion;

/**
 * 搜索开源项目
 */
- (void)searchByRepoName:(NSString *)repoName descending:(BOOL)descending completion:(void(^)())completion;

/**
 * 搜索用户
 */
- (void)searchByUserName:(NSString *)userName completion:(void(^)())completion;

/**
 * 保存用户的基因
 */
- (void)saveGeneToMaxLeap:(MLGMGene *)gene completion:(void(^)())completion;

/**
 * 获取指定用户的基因
 */
- (void)geneForUserName:(NSString *)userName completion:(void(^)())completion;

@end
