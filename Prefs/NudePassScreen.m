#import <Preferences/Preferences.h>
#import <libcolorpicker.h>

#define NudePSPath @"/User/Library/Preferences/com.imkpatil.nudepassscreen.plist"

@interface NudePassScreenListController : PSListController
- (void)respring;
@end

@implementation NudePassScreenListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"NudePassScreen" target:self] retain];
	}
	return _specifiers;
}

-(id) readPreferenceValue:(PSSpecifier*)specifier {
    NSDictionary *NudePassScreensettings = [NSDictionary dictionaryWithContentsOfFile:NudePSPath];
    if (!NudePassScreensettings[specifier.properties[@"key"]]) {
        return specifier.properties[@"default"];
    }
    return NudePassScreensettings[specifier.properties[@"key"]];
}

-(void) setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:NudePSPath]];
    [defaults setObject:value forKey:specifier.properties[@"key"]];
    [defaults writeToFile:NudePSPath atomically:YES];
    //  NSDictionary *powercolorSettings = [NSDictionary dictionaryWithContentsOfFile:powercolorPath];
    CFStringRef toPost = (CFStringRef)specifier.properties[@"PostNotification"];
    if(toPost) CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
}

- (void)respring {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.imkpatil.nudepassscreen.respring"), NULL, NULL, YES);
		//[(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
		// #pragma GCC diagnostic push
		// #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    // system("cd /var/mobile/Library/Caches/com.apple.UIStatusBar; rm -R -f images; rm -f version; killall -9 SpringBoard");  //clears status bar cache + respring.
		// #pragma GCC diagnostic pop
}

@end



// vim:ft=objc
