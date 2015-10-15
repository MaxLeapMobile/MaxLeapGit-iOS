//
//  MLGMRepo.m
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/12.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMRepo.h"

@implementation MLGMRepo

- (void)fillObject:(NSDictionary *)object {
    self.author = [object valueForKeyPath:@"owner.login"];
    self.avatarUrl = [object valueForKeyPath:@"owner.avatar_url"];
    self.htmlPageUrl = [object valueForKeyPath:@"html_url"];
    self.introduction = NULL_TO_NIL([object valueForKeyPath:@"description"]);
    self.isFork = [object valueForKeyPath:@"fork"];
    self.name = [object valueForKeyPath:@"full_name"];
}

- (NSString *)description {
    NSString *description = [NSString stringWithFormat:@"%@: author=%@\n avatarUrl=%@\n htmlPageUrl=%@\n introduction=%@\n isFork=%@\n name=%@\n", NSStringFromClass(self.class), self.author, self.avatarUrl, self.htmlPageUrl, self.introduction, self.isFork, self.name];
    
    return description;
}

@end
