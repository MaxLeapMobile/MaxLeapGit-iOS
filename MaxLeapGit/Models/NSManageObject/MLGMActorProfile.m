//
//  MLGMUserProfile.m
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/12.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMActorProfile.h"
#import "MLGMGene.h"

@implementation MLGMActorProfile

- (void)fillProfile:(NSDictionary *)object {
    self.githubId = [object valueForKey:@"id"];
    self.loginName = [object valueForKey:@"login"];
    self.avatarUrl = [object valueForKey:@"avatar_url"];
    self.followerCount = [object valueForKey:@"followers"];
    self.followingCount = [object valueForKey:@"following"];
    self.githubCreatTime = [[object valueForKey:@"created_at"] toDate];
    self.githubUpdateTime = [[object valueForKey:@"updated_at"] toDate];
    self.publicRepoCount = [object valueForKey:@"public_repos"];
    
    self.nickName = NULL_TO_NIL([object valueForKey:@"name"]);
    self.hireable = NULL_TO_NIL([object valueForKey:@"hireable"]);
    self.company = NULL_TO_NIL([object valueForKey:@"company"]);
    self.email = NULL_TO_NIL([object valueForKey:@"email"]);
    self.blog = NULL_TO_NIL([object valueForKey:@"blog"]);
    self.location = NULL_TO_NIL([object valueForKey:@"location"]);
    self.introduction = NULL_TO_NIL([object valueForKey:@"description"]);
}

- (void)fillFollow:(NSDictionary *)object {
    self.githubId = [object valueForKey:@"id"];
    self.loginName = [object valueForKey:@"login"];
    self.avatarUrl = [object valueForKey:@"avatar_url"];
}

- (void)fillOrg:(NSDictionary *)object {
    self.githubId = [object valueForKey:@"id"];
    self.loginName = [object valueForKey:@"login"];
    self.avatarUrl = [object valueForKey:@"avatar_url"];
    self.introduction = NULL_TO_NIL([object valueForKey:@"description"]);
}

- (void)fillSearchResult:(NSDictionary *)object {
    self.githubId = [object valueForKey:@"id"];
    self.loginName = [object valueForKey:@"login"];
    self.avatarUrl = [object valueForKey:@"avatar_url"];
}

- (NSString *)description {
    NSString *description = [NSString stringWithFormat:@"%@:\n githubID=%@\n loginName=%@\n nickName=%@\n hireable=%@\n avatarUrl=%@\n stars=%@\n organizationCount=%@\n followerCount=%@\n followingCount=%@\n publicRepoCount=%@\n githubCreateTime=%@\n githubUpdatTime=%@\n company=%@\n email=%@\n blog=%@\n location=%@\n introduction=%@\n", NSStringFromClass(self.class), self.githubId, self.loginName, self.nickName, self.hireable, self.avatarUrl, self.starCount, self.organizationCount, self.followerCount, self.followingCount, self.publicRepoCount, self.githubCreatTime, self.githubUpdateTime, self.company, self.email, self.blog, self.location, self.introduction];
    return description;
}

@end
