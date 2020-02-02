#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <AVFoundation/AVFoundation.h>

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    NSError *sessionError = nil;
    NSError *activationError = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&sessionError];
    [[AVAudioSession sharedInstance] setActive: TRUE error: &activationError];
  
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
