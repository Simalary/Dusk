//
//  DarkMessages_CK.xm
//  DarkMessages
//
//  Dark theme for the Messages app in iOS 10.
//
//  ©2017 Sticktron
//

#define DEBUG_PREFIX @"[DUSK MESSAGES]"
#import "DebugLog.h"


#import "Dusk-Messages.h"
#import "UIColor+Extensions.h"
#import <Foundation/NSDistributedNotificationCenter.h>


static CKUIThemeDark *darkTheme;
static NSString *bundleID;

static void handleQuitMessages(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	DebugLogC(@"*** Notice: %@", name);
	
	// skip if not inside the Messages app
	if (![bundleID isEqualToString:@"com.apple.MobileSMS"]) {
		DebugLogC(@"**********   Not the Messages App, ignoring.   **********");
		return;
	}
	
	// if Messages is not open, we can terminate it
	if ([[UIApplication sharedApplication] isSuspended]) {
		DebugLogC(@"**********   Messages is not open, quitting...   **********");
		[[UIApplication sharedApplication] terminateWithSuccess];
		return;
	}
	
	// if Messages is open, let's ask the user to restart
	DebugLogC(@"**********   Messages is open, asking permission to quit !!!   **********");
	
	UIAlertController *alert = [UIAlertController
		alertControllerWithTitle:@"Dark Mode Toggled"
		message:@"Restart Messages to change mode."
		preferredStyle:UIAlertControllerStyleAlert
	];
	
	[alert addAction:[UIAlertAction
		actionWithTitle:@"Now"
		style:UIAlertActionStyleDestructive
	    handler:^(UIAlertAction *action) {
			DebugLogC(@"asking SpringBoard to restarted MobileSMS...");
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
				kRelaunchMessagesNotification, NULL, NULL, true
			);
        }]
	];
	
	[alert addAction:[UIAlertAction
		actionWithTitle:@"Later"
		style:UIAlertActionStyleCancel
		handler:nil]
	];
			
	[[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alert animated:YES completion:nil];
}


//------------------------------------------------------------------------------


%hook CKUIBehaviorPhone
- (id)theme {
	return darkTheme;
}
%end

%hook CKUIBehaviorPad
- (id)theme {
	return darkTheme;
}
%end

// fix navbar: style
%hook CKAvatarNavigationBar
- (void)_setBarStyle:(int)style {
	%orig(1);
}
%end

// fix navbar: contact names
%hook CKAvatarContactNameCollectionReusableView
- (void)setStyle:(int)style {
	%orig(3);
}
%end

// fix navbar: group names
%hook CKAvatarTitleCollectionReusableView
- (void)setStyle:(int)style {
	%orig(3);
}
%end

// fix navbar: new message label
%hook CKNavigationBarCanvasView
- (id)titleView {
	id tv = %orig;
	if (tv && [tv respondsToSelector:@selector(setTextColor:)]) {
		[(UILabel *)tv setTextColor:UIColor.whiteColor];
	}
	return tv;
}
%end

// fix group details: contact names
%hook CKDetailsContactsTableViewCell
- (UILabel *)nameLabel {
	UILabel *nl = %orig;
	nl.textColor = UIColor.whiteColor;
	return nl;
}
%end

// fix message entry inactive color
%hook CKMessageEntryView
- (UILabel *)collpasedPlaceholderLabel {
	UILabel *label = %orig;
	label.textColor = [darkTheme entryFieldDarkStyleButtonColor];
	return label;
}
%end

%ctor {
	@autoreleasepool {
		bundleID = NSBundle.mainBundle.bundleIdentifier;
		DebugLogC(@"loaded into process: %@", bundleID);		
		darkTheme = [[%c(CKUIThemeDark) alloc] init];
		%init;
	}
}