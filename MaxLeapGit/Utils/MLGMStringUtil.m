//
//  GMStringUtil.m
//  MaxLeapGit
//
//  Created by Julie on 15/10/9.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMStringUtil.h"

@implementation MLGMStringUtil
+ (CGSize)sizeInOneLineOfText:(NSString *)text font:(UIFont *)font{
    CGSize result =CGSizeZero ;
    if (text) {
        result = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    }
    return result;
}

+ (CGSize)sizeOfText:(NSString *)text font:(UIFont *)font constrainedToSize:(CGSize)size {
    CGSize textSize = CGSizeZero;
    if (text && font) {
        CGRect frame = [text boundingRectWithSize:size
                                          options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                       attributes:@{NSFontAttributeName:font}
                                          context:nil];
        textSize = CGSizeMake(ceil(frame.size.width), ceil(frame.size.height));
    }
    
    
    return textSize;
}

@end
