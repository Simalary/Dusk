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

// fix plugin bar
%hook CKBrowserSwitcherFooterView
-(void)setBackgroundColor:(id)arg1{
	%orig([UIColor blackColor]);
}
%end

// fix contact background
@interface CNContactViewController : UIViewController
@end

%hook CNContactViewController
-(void)viewDidLoad{
	%orig;
	self.view.backgroundColor = [UIColor blackColor];
}
%end

@interface CNContactGroupPickerViewController : UIViewController
@end

%hook CNContactGroupPickerViewController
-(void)viewDidLoad{
	%orig;
	self.view.backgroundColor = [UIColor blackColor];
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