//
//  MLGMRepo.m
//  MaxLeapGit
//
//  Created by Michael on 15/10/12.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMRepo.h"

@implementation MLGMRepo

- (void)fillObject:(NSDictionary *)object {
    self.author = [object valueForKeyPath:@"owner.login"];
    self.avatarUrl = [object valueForKeyPath:@"owner.avatar_url"];
    self.htmlPageUrl = [object valueForKeyPath:@"html_url"];
    self.introduction = NULL_TO_NIL([object valueForKeyPath:@"description"]);
    self.name = [object valueForKeyPath:@"full_name"];
}

- (void)fillRecommendationObject:(NSDictionary *)object {
    self.author = [object valueForKeyPath:@"ownerLogin"];
    self.htmlPageUrl = [object valueForKeyPath:@"htmlUrl"];
    NSString *repoName = [object valueForKeyPath:@"name"];
    self.name = [NSString stringWithFormat:@"%@/%@", self.author, repoName];
}

- (NSString *)description {
    NSString *description = [NSString stringWithFormat:@"%@: author=%@\n avatarUrl=%@\n htmlPageUrl=%@\n introduction=%@\n name=%@\n", NSStringFromClass(self.class), self.author, self.avatarUrl, self.htmlPageUrl, self.introduction, self.name];
    
    return description;
}

@end
