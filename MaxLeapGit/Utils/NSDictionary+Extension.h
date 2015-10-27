//
//  NSDictionary+QueryParameters.h
//  BSNShareCenter
//
//  Created by Michael on 15/5/20.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extension)
- (NSString *)queryParameter;
- (NSString *)jsonParameter;
- (NSDictionary *)dictionaryByReplacingNullsWithStrings;
@end
