//
//  AppDelegate.m
//  MaxLeapGit
//
//  Created by Jun Xia on 15/9/22.
//  Copyright (c) 2015年 MaxLeapMobile. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () <BITHockeyManagerDelegate>
@property (nonatomic) DDFileLogger *fileLogger;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configureGlobalAppearance];
    [self configureFlurry];
	[self configureLeapCloud];
    [self configureMagicalRecord];
    [self configureHoceyApp];
    [self configureCocoaLumberjack];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = UIColorFromRGB(0xffffff);
    self.window.rootViewController = self.tabBarController = [[MLGMCustomTabBarController alloc] init];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

#pragma Private Method
- (void)configureGlobalAppearance {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIImage *barLineImage = [UIImage imageWithColor:[UIColor clearColor]];
    UIImage *barBGImage = [UIImage imageWithColor:ThemeNavigationBarColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xffffff),
                                                           NSFontAttributeName : [UIFont boldSystemFontOfSize:17]}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xffffff),
                                                           NSFontAttributeName : [UIFont boldSystemFontOfSize:15]}
                                                forState:UIControlStateNormal];
    [[UINavigationBar appearance] setBackgroundImage:barBGImage forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:barLineImage];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

- (void)configureFlurry {
    [Flurry setAppVersion:kAppVersion];
    [Flurry startSession:CONFIGURE(@"3cce3f30d1c88bef1cb54f4caa09abeb64863112")];
}

- (void)configureLeapCloud {
    [MLLogger setLogLevel:MLLogLevelError];
    [MaxLeap setApplicationId:kMaxLeap_Application_ID clientKey:kMaxLeap_REST_API_Key site:MLSiteUS];
}

- (void)configureMagicalRecord {
#ifdef DEBUG
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelWarn];
#endif
    [MagicalRecord setupCoreDataStack];
}

- (void)configureHoceyApp {
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:kHockeyApp_Identifier delegate:self];
    [[BITHockeyManager sharedHockeyManager] setDelegate: self];
    [[BITHockeyManager sharedHockeyManager].crashManager setCrashManagerStatus: BITCrashManagerStatusAutoSend];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
}

- (void)configureCocoaLumberjack {
    _fileLogger = [[DDFileLogger alloc] init];
    
    [_fileLogger setMaximumFileSize:(1024 * 1024)];
    [_fileLogger setRollingFrequency:(3600.0 * 24.0)];
    [[_fileLogger logFileManager] setMaximumNumberOfLogFiles:7];
    [DDLog addLogger:_fileLogger];
    
    if (![[BITHockeyManager sharedHockeyManager] isAppStoreEnvironment]) {
        [DDLog addLogger:[DDASLLogger sharedInstance]];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
    }
}

- (NSString *)getLogFilesContentWithMaxSize:(NSInteger)maxSize {
    NSMutableString *description = [NSMutableString string];
    
    NSArray *sortedLogFileInfos = [[_fileLogger logFileManager] sortedLogFileInfos];
    NSInteger count = [sortedLogFileInfos count];
    
    // we start from the last one
    for (NSInteger index = count - 1; index >= 0; index--) {
        DDLogFileInfo *logFileInfo = [sortedLogFileInfos objectAtIndex:index];
        
        NSData *logData = [[NSFileManager defaultManager] contentsAtPath:[logFileInfo filePath]];
        if ([logData length] > 0) {
            NSString *result = [[NSString alloc] initWithBytes:[logData bytes]
                                                        length:[logData length]
                                                      encoding: NSUTF8StringEncoding];
            
            [description appendString:result];
        }
    }
    
    if ([description length] > maxSize) {
        description = (NSMutableString *)[description substringWithRange:NSMakeRange([description length]-maxSize-1, maxSize)];
    }
    
    return description;
}

#pragma mark - BITCrashManagerDelegate
- (NSString *)applicationLogForCrashManager:(BITCrashManager *)crashManager {
    NSString *description = [self getLogFilesContentWithMaxSize:5000]; // 5000 bytes should be enough!
    if ([description length] == 0) {
        return nil;
    } else {
        return description;
    }
}

@end
