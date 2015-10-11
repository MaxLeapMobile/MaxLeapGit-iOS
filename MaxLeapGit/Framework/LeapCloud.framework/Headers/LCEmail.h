//
//  LCEmail.h
//  LeapCloud
//
//  Created by Sun Jin on 15/4/21.
//  Copyright (c) 2015年 ilegendsoft. All rights reserved.
//

#ifdef EXTENSION_IOS
    #import <LeapCloudExt/LCConstants.h>
#else
    #import <LeapCloud/LCConstants.h>
#endif


@interface LCEmail : NSObject

@property (nonatomic, strong) NSString *templateName;
@property (nonatomic, strong) NSString *locale; // charset ???

// provider
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSArray *to;
@property (nonatomic, strong) NSDictionary *subjectArgs;
@property (nonatomic, strong) NSDictionary *textArgs;
@property (nonatomic, strong) NSDictionary *htmlArgs;

- (instancetype)initWithTemplateName:(NSString *)templateName;

- (void)sendInBackgroundWithBlock:(LCBooleanResultBlock)block;

@end
