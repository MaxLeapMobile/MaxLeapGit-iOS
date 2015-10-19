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

- (BOOL)isEqualToGene:(MLGMGene *)gene {
    BOOL isEqualDateString = [[NSString stringWithFormat:@"%@",self.updateTime] isEqualToString:[NSString stringWithFormat:@"%@",gene.updateTime]];
    if ([self.language isEqualToString:gene.language] && [self.skill isEqualToString:gene.skill] && isEqualDateString) {
        return YES;
    }
    return NO;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"language = %@, skill = %@, user.loginName = %@, updatedAt = %@", self.language, self.skill, self.userProfile.loginName, self.updateTime];
}

@end

@implementation NSSet (GeneComparison)

- (BOOL)containsGene:(MLGMGene *)gene {
    __block BOOL containsGene = NO;
    if ([gene isKindOfClass:[MLGMGene class]]) {
        [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[MLGMGene class]] && [obj isEqualToGene:gene]) {
                containsGene = YES;
            }
        }];
    }
    return containsGene;
}

@end