//
//  MLGMEvent.m
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/12.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMEvent.h"

@implementation MLGMEvent

- (void)fillObject:(NSDictionary *)object {
    NSString *type = object[@"type"];
    if ([type isEqualToString:@"WatchEvent"]) {
        self.type = @"WatchEvent";
        self.actorName = [object valueForKeyPath:@"actor.login"];
        self.avatarUrl = [object valueForKeyPath:@"actor.avatar_url"];
        self.sourceRepoName = [object valueForKeyPath:@"repo.name"];
        self.createdAt = [[object valueForKeyPath:@"created_at"] toDate];
    } else if ([type isEqualToString:@"ForkEvent"]) {
        self.type = @"ForkEvent";
        self.actorName = [object valueForKeyPath:@"actor.login"];
        self.avatarUrl = [object valueForKeyPath:@"actor.avatar_url"];
        self.sourceRepoName = [object valueForKeyPath:@"repo.name"];
        self.targetRepoName = [object valueForKeyPath:@"payload.forkee.full_name"];
        self.createdAt = [[object valueForKeyPath:@"created_at"] toDate];
    }
}

- (NSString *)description {
    NSString *description = [NSString stringWithFormat:@"%@: \n type=%@\n actorName=%@\n avatarUlr=%@\n sourceRepoName=%@\n targetRepoName=%@\n createAt=%@\n", NSStringFromClass(self.class), self.type, self.actorName, self.avatarUrl, self.sourceRepoName, self.targetRepoName, self.createdAt];

    return description;
}

@end
