//
//  GMLoginViewController.h
//  MaxLeapGit
//
//  Created by julie on 15/10/8.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMLoginViewController : UIViewController
- (instancetype)initWithCompletionBlock:(void(^)(BOOL succeeded))completionBlock;
@end

@interface NSDictionary (UrlEncoding)

-(NSString*) urlEncodedString;

@end