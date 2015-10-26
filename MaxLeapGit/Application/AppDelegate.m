//
//  AppDelegate.m
//  MaxLeapGit
//
//  Created by Michael on 15/9/22.
//  Copyright (c) 2015年 MaxLeapMobile. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () <BITHockeyManagerDelegate>
@property (nonatomic) DDFileLogger *fileLogger;
@property (nonatomic, strong) NSTimer *credentialsMonitor;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configureGlobalAppearance];
	[self configureLeapCloud];
    [self configureMagicalRecord];
    [self configureHoceyApp];
    [self configureFlurry];
    [self configureCocoaLumberjack];
    [self configureCredentialMonitor];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = UIColorFromRGB(0xffffff);
    self.window.rootViewController = [[MLGMCustomTabBarController alloc] init];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

#pragma mark - Public Method

#pragma mark - Private Method

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

- (void)configureFlurry {
    [Flurry setAppVersion:kAppVersion];
    [Flurry startSession:kFlurryAPIKey];
}

- (void)configureCocoaLumberjack {
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    
    [fileLogger setMaximumFileSize:(1024 * 1024)];
    [fileLogger setRollingFrequency:(3600.0 * 24.0)];
    [[fileLogger logFileManager] setMaximumNumberOfLogFiles:7];
    [DDLog addLogger:fileLogger];
    
    self.fileLogger = fileLogger;
    
    if (![[BITHockeyManager sharedHockeyManager] isAppStoreEnvironment]) {
        [DDLog addLogger:[DDASLLogger sharedInstance]];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
    }
}

- (void)configureCredentialMonitor {
    self.credentialsMonitor = [NSTimer scheduledTimerWithTimeInterval:10
                                                               target:self
                                                             selector:@selector(checkCredentials:)
                                                             userInfo:nil
                                                              repeats:YES];
    [self.credentialsMonitor fire];
}

- (void)checkCredentials:(id)sender {
    [kWebService checkSessionTokenStatusCompletion:^(BOOL valid, NSError *error) {
        if (!valid && kOnlineAccount) {
            [self logout];
        }
    }];
}

- (void)logout {
    [kSharedNetworkClient cancelAllDataTasksCompletion:^{
        [kOnlineAccount MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        self.window.rootViewController = [[MLGMCustomTabBarController alloc] init];
    }];
}

- (NSString *)getLogFilesContentWithMaxSize:(NSInteger)maxSize {
    NSMutableString *description = [NSMutableString string];
    
    NSArray *sortedLogFileInfos = [[self.fileLogger logFileManager] sortedLogFileInfos];
    NSInteger count = [sortedLogFileInfos count];
    
    for (NSInteger index = count - 1; index >= 0; index--) {
        DDLogFileInfo *logFileInfo = [sortedLogFileInfos objectAtIndex:index];
        
        NSData *logData = [[NSFileManager defaultManager] contentsAtPath:[logFileInfo filePath]];
        if ([logData length] > 0) {
            NSString *result = [[NSString alloc] initWithBytes:[logData bytes] length:[logData length] encoding: NSUTF8StringEncoding];
            [description appendString:result];
        }
    }
    
    if ([description length] > maxSize) {
        description = (NSMutableString *)[description substringWithRange:NSMakeRange([description length] - maxSize - 1, maxSize)];
    }
    
    return description;
}

#pragma mark - BITCrashManagerDelegate
- (NSString *)applicationLogForCrashManager:(BITCrashManager *)crashManager {
    NSString *description = [self getLogFilesContentWithMaxSize:5000];
    if ([description length] == 0) {
        return nil;
    }
    
    return description;
}

@end
