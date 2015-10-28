## MaxLeapGit-iOS
[![Build Status](https://travis-ci.org/MaxLeapMobile/MaxLeapGit-iOS.svg?branch=master)](https://travis-ci.org/MaxLeapMobile/MaxLeapGit-iOS)

GitMaster helps you find exciting projects. Simply specify your genes about your language skills，and GitMaster will tell you about new and interesting projects that you never knew existed!

## Preview
![ScreenShots](https://github.com/MaxLeapMobile/MaxLeapGit-iOS/blob/Dev/Snapshots/ScreenShots.gif?raw=true)

## Languages supported

* Html Skills: Html5, Bootstrap
* Java Skills: Android, Spring
* Javascript Skills: AngularJS, Bootstrap, jQuery, Node
* Objective-C Skills: iOS
* PHP Skills: Laravel, CodeIgniter
* Python Skills: Web Framework
* Swift Skills: iOS

## Features included

* Best daily updated project recommendations!
* Quick access to your repos
* Star, watch or fork repositories
* Search users and repositories
* See the code and recent commits of different branches, issues and forks
* Access your repos and stars
* Slide out menu for quick and efficient navigation

## Third-party Tools

[CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack)

[MagicalRecord](https://github.com/magicalpanda/MagicalRecord)

[TTTAttributedLabel](https://github.com/TTTAttributedLabel/TTTAttributedLabel)

[SVProgressHUD](https://github.com/TransitApp/SVProgressHUD)

[SVPullToRefresh](https://github.com/samvermette/SVPullToRefresh)

[WYPopoverController](https://github.com/nicolaschengdev/WYPopoverController)

[SDWebImage](https://github.com/rs/SDWebImage)

[HockeySDK](http://support.hockeyapp.net/kb/client-integration-ios-mac-os-x/hockeyapp-for-ios)

[VeriJSON](http://bitbucket.org/dcutting/verijson/)

## Support
* GitMaster is an Open Source project on Github. Star and Pull requests are welcome!
  https://github.com/MaxLeapMobile/MaxLeapGit-iOS

## Requirements
* Require at least iOS 8.0.

* Integrate frameworks: run "pod install".

* Authentication:
  GitMaster supports two variants of OAuth2 for signing in. You will need to register your OAuth application, and provide GitMaster with your client ID, client secret and callback URL in PrefixHeader.pch file before trying to authenticate: 
```objective-c
  #define kGitHub_Client_ID CONFIGURE(@"GitHub_Client_ID") 
  #define KGitHub_Client_Secret CONFIGURE(@"GitHub_Client_Secret")
  #define kGitHub_Redirect_URL CONFIGURE(@"GitHub_Redirect_URL")
```

## Release Notes

**1.0** 

## License  
MIT

GitMaster is not affiliated with GitHub in any way. GitMaster is a third-party GitHub client.
