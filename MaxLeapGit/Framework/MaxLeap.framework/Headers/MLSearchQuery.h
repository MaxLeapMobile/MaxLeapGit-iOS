//
//  MLSearchQuery.h
//  MaxLeap
//
//  Created by Sun Jin on 12/1/14.
//  Copyright (c) 2014 iLegendsoft. All rights reserved.
//

#ifdef EXTENSION_IOS
    #import <MaxLeapExt/MLConstants.h>
#else
    #import <MaxLeap/MLConstants.h>
#endif

/**
 *  An object represents an elastic search query object.
 */
@interface MLSearchQuery : NSObject

/** 
 Create SearchQuery using a `query_string` element.
 
 The structure of search query:
 
    {
        "query":{
            "query_string":queryStringElement
        },
        "from":0,
        "size":10
    }
 
 Sample for queryStringElement:
 
    @{
        @"query" : @"text to search"
     }
 
 For more infomation about `query_string`, please refer to [Query DSL - Query String Query](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-query-string-query.html#query-dsl-query-string-query)
 
 @param queryStringElement the `query_string` element
 
 @return A search query instance.
 */
+ (instancetype)queryWithQueryStringElement:(NSDictionary *)queryStringElement;

/**
 Create a SearchQuery using a `query` element.

 The search query stucture:
 
    {
        "query":queryDictionary,
        "sort":sortElement,
        "from":0,
        "size":10
    }
 
 For more infomation about `query`, please refer to [Query DSL - Queries](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-queries.html)
 
 @param queryDictionary  The query element
 @param sortElement      The sort element
 
 @return A search query instance.
 */
+ (instancetype)queryWithQueryDictionary:(NSDictionary *)queryDictionary sortElement:(NSArray *)sortElement;

/**
 *  Create a SearchQuery using a complete search `query` element.
 *
 *  For more infomation about search query, please refer to [Elastic Search Request Query](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-request-query.html)
 *
 *  @note: The from and size properties will not work for `MLSearchQuery`s created by this method.
 *
 *  @param dictionary The entire search query element. You should construct the whole search query in your app.
 *
 *  @return A MLSearchQuery instance.
 */
+ (instancetype)queryWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong) NSArray *classNames;

// Pagination of results can be done by using the from and size parameters.

// The from parameter defines the offset from the first result you want to fetch.
@property (nonatomic) NSInteger from;

// The size parameter allows you to configure the maximum amount of hits to be returned.
@property (nonatomic) NSInteger size;

- (void)findObjectsInBackgroundWithBlock:(MLDictionaryResultBlock)block;

@end
