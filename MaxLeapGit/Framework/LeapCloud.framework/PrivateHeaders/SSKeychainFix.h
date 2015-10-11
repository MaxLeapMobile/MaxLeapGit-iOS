//
//  SSKeychainFix.h
//  LeapCloud
//
//  Created by Sun Jin on 11/5/14.
//  Copyright (c) 2014 iLegendsoft. All rights reserved.
//

#import "LC_SSKeychain.h"

#ifndef LC_SSKeychainFix_h
#define LC_SSKeychainFix_h

typedef LC_SSKeychain                           SSKeychain;
typedef LC_SSKeychainQuery                      SSKeychainQuery;

typedef LC_SSKeychainErrorCode                  SSKeychainErrorCode;
#define SSKeychainErrorBadArguments             LC_SSKeychainErrorBadArguments

typedef LC_SSKeychainQuerySynchronizationMode   SSKeychainQuerySynchronizationMode;
#define SSKeychainQuerySynchronizationModeAny   LC_SSKeychainQuerySynchronizationModeAny
#define SSKeychainQuerySynchronizationModeNo    LC_SSKeychainQuerySynchronizationModeNo
#define SSKeychainQuerySynchronizationModeYes   LC_SSKeychainQuerySynchronizationModeYes

#define kSSKeychainErrorDomain                  LC_kSSKeychainErrorDomain
#define kSSKeychainAccountKey                   LC_kSSKeychainAccountKey
#define kSSKeychainCreatedAtKey                 LC_kSSKeychainCreatedAtKey
#define kSSKeychainClassKey                     LC_kSSKeychainClassKey
#define kSSKeychainDescriptionKey               LC_kSSKeychainDescriptionKey
#define kSSKeychainLabelKey                     LC_kSSKeychainLabelKey
#define kSSKeychainLastModifiedKey              LC_kSSKeychainLastModifiedKey
#define kSSKeychainWhereKey                     LC_kSSKeychainWhereKey

#endif
