//
//  MLGMGene.m
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/11.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMGene.h"
#import "MLGMActorProfile.h"

@implementation MLGMGene

- (void)fillObject:(NSDictionary *)object {
    self.language = [object valueForKeyPath:@"language"];
    self.skill = [object valueForKeyPath:@"skill"];
    self.updateTime = [object valueForKey:@"updateTime"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"language = %@, skill = %@, user.loginName = %@, updatedAt = %@", self.language, self.skill, self.userProfile.loginName, self.updateTime];
}

@end
