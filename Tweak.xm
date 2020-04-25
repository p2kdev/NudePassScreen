#import <libcolorpicker.h>

@interface FBSystemService : NSObject
  +(id)sharedInstance;
  -(void)exitAndRelaunch:(BOOL)arg1;
@end

@interface SBUIPasscodeLockViewSimpleFixedDigitKeypad : UIView
    @property (nonatomic, copy, readwrite) UIColor *backgroundColor;
@end

NSDictionary *pref = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.imkpatil.nudepassscreen.plist"];
static BOOL isEnabled = YES;
static BOOL isCustColLS = YES;
static BOOL isCustColRings = YES;
static BOOL isDisableRings = NO;
//static BOOL isHighlighted = NO;

%hook TPNumberPadLightStyleButton

  // -(id)defaultColor
  // {
  //   if (isEnabled && !isDisableRings && isCustColRings)
  //   {
  //     return LCPParseColorString([pref objectForKey:@"RingCustCol"], @"#6d6666");
  //   }
  //   return %orig;
  // }
  //
  // -(id)buttonColor
  // {
  //   if (isEnabled && !isDisableRings && isCustColRings)
  //   {
  //     return LCPParseColorString([pref objectForKey:@"RingCustCol"], @"#6d6666");
  //   }
  //   return %orig;
  // }

  // +(double)unhighlightedCircleViewAlpha
  // {
  //   if (isEnabled && !isDisableRings && isCustColRings)
  //   {
  //     return 0;
  //   }
  //   return %orig;
  // }

%end

%hook TPNumberPadDarkStyleButton

  // -(id)defaultColor
  // {
  //   if (isEnabled && !isDisableRings && isCustColRings)
  //   {
  //     return LCPParseColorString([pref objectForKey:@"RingCustCol"], @"#6d6666");
  //   }
  //   return %orig;
  // }

  -(id)buttonColor
  {
    if (isEnabled && !isDisableRings && isCustColRings)
    {
      return LCPParseColorString([pref objectForKey:@"RingCustCol"], @"#6d6666");
    }
    return %orig;
  }

  +(double)unhighlightedCircleViewAlpha
  {
    if (isEnabled && !isDisableRings && isCustColRings)
    {
      return 1;
    }
    return %orig;
  }

  +(double)highlightedCircleViewAlpha
  {
    if (isEnabled && !isDisableRings && isCustColRings)
    {
      return 0.2;
    }
    return %orig;
  }


%end

%hook TPNumberPadButton

+(double)outerCircleDiameter
{
  if (isEnabled && isDisableRings)
  {
    return 0;
  }
  return %orig;
}


// -(void)setHighlighted:(BOOL)arg1
// {
//   isHighlighted = arg1;
//   %orig(arg1);
// }

// +(double)unhighlightedCircleViewAlpha
// {
//   if (isEnabled && !isDisableRings && isCustColRings)
//   {
//     return 1;
//   }
//   return %orig;
// }
//
// +(double)highlightedCircleViewAlpha
// {
//   if (isEnabled && !isDisableRings && isCustColRings)
//   {
//     return 1;
//   }
//   return %orig;
// }

// -(void)setCircleView:(UIView *)arg1
// {
//   if (isEnabled && isDisableRings)
//   {
//     arg1 = nil;
//   }
//   %orig(arg1);
// }
//
// -(UIView *)circleView
// {
//   if (isEnabled && isDisableRings)
//   {
//     return nil;
//   }
//
//   return %orig;
// }

// -(UIColor *)buttonColor
// {
//   if (isEnabled && !isDisableRings && isCustColRings)
//   {
//     return LCPParseColorString([pref objectForKey:@"RingHighlightCustCol"], @"#c94c4c");
//   }
//   return %orig;
// }
//
// -(UIColor *)color
// {
//   if (isEnabled && !isDisableRings && isCustColRings)
//   {
//     return LCPParseColorString([pref objectForKey:@"RingHighlightCustCol"], @"#c94c4c");
//   }
//   return %orig;
// }
//
// -(id)defaultColor
// {
//   if (isEnabled && !isDisableRings && isCustColRings)
//   {
//     return LCPParseColorString([pref objectForKey:@"RingHighlightCustCol"], @"#c94c4c");
//   }
//   return %orig;
// }
//
// -(void)setColor:(UIColor *)arg1
// {
//   if (isEnabled && !isDisableRings && isCustColRings)
//   {
//     if (isHighlighted)
//     {
//       arg1 = LCPParseColorString([pref objectForKey:@"RingHighlightCustCol"], @"#c94c4c");
//     }
//     else
//     {
//       arg1 = LCPParseColorString([pref objectForKey:@"RingCustCol"], @"#6d6666");
//     }
//   }
//   %orig(arg1);
// }
// }
%end

%hook SBUIPasscodeLockViewSimpleFixedDigitKeypad

  -(double)_entryFieldBottomYDistanceFromNumberPadTopButton
  {
    if (isEnabled && isCustColLS)
    {
      self.backgroundColor = LCPParseColorString([pref objectForKey:@"LSCustCol"], @"#000000");;
    }
    return %orig;
  }


%end

static void reloadSettings() {

  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.imkpatil.nudepassscreen.plist"];
  if(prefs)
  {
      isEnabled = [prefs objectForKey:@"TwkEnabled"] ? [[prefs objectForKey:@"TwkEnabled"] boolValue] : isEnabled;
      isCustColLS = [prefs objectForKey:@"LSColEnabled"] ? [[prefs objectForKey:@"LSColEnabled"] boolValue] : isCustColLS;
      isCustColRings = [prefs objectForKey:@"RingColEnabled"] ? [[prefs objectForKey:@"RingColEnabled"] boolValue] : isCustColRings;
      isDisableRings = [prefs objectForKey:@"DisableRings"] ? [[prefs objectForKey:@"DisableRings"] boolValue] : isDisableRings;
  }
  [prefs release];}

static void respring(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  //reloadSettings();
  [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}

%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadSettings, CFSTR("com.imkpatil.nudepassscreen.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, respring, CFSTR("com.imkpatil.nudepassscreen.respring"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  reloadSettings();
}
