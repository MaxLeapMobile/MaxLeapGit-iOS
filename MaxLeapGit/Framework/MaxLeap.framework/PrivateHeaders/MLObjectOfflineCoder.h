//
//  MLObjectPersistanceUtils.h
//  MaxLeap
//
//  Created by Sun Jin on 11/5/14.
//  Copyright (c) 2014 iLegendsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLObjectOfflineCoder : NSObject

+ (id)encodeObject:(id)object;
+ (id)decodeObject:(id)object;

@end
