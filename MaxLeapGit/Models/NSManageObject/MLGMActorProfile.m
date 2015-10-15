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
    self.followers = [object valueForKey:@"followers"];
    self.following = [object valueForKey:@"following"];
    self.githubCreatedAt = [[object valueForKey:@"created_at"] toDate];
    self.githubUpdatedAt = [[object valueForKey:@"updated_at"] toDate];
    self.publicRepos = [object valueForKey:@"public_repos"];
    
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

- (NSString *)description {
    NSString *description = [NSString stringWithFormat:@"%@:\n githubID=%@\n loginName=%@\n nickName=%@\n hireable=%@\n avatarUrl=%@\n stars=%@\n organizations=%@\n followers=%@\n following=%@\n publicRepos=%@\n githubCreateAt=%@\n githubUpdatedAt=%@\n company=%@\n email=%@\n blog=%@\n location=%@\n introduction=%@\n", NSStringFromClass(self.class), self.githubId, self.loginName, self.nickName, self.hireable, self.avatarUrl, self.starts, self.organizations, self.followers, self.following, self.publicRepos, self.githubCreatedAt, self.githubUpdatedAt, self.company, self.email, self.blog, self.location, self.introduction];
    return description;
}

@end
