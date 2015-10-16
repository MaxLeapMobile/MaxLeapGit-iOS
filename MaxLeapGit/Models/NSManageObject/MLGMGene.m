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
}

@end
