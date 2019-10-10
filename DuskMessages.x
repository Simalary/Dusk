//
//  Dusk
//  Dusk (Messages)
//
//  Dark theme for the Messages app in iOS 12+.
//
//  ©2019 Simalary (Chris)
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

@interface CNContactView : UITableView
@end

%hook CNContactView
-(void)setBackgroundColor:(UIColor *)arg1{
	%orig([UIColor blackColor]);
}
%end

@interface CNContactContentViewController : UIViewController
@end

%hook CNContactContentViewController
-(void)viewDidLoad{
	%orig;
	if ([self valueForKey:@"_view"]) {
		UIView *view = (UIView *)[self valueForKey:@"_view"];
		view.backgroundColor = [UIColor blackColor];
	}
}
%end

@interface CNContactGroupPickerViewController : UIViewController
@end

%hook CNContactGroupPickerViewController
-(void)viewDidLoad{
	%orig;
	//self.view.backgroundColor = [UIColor blackColor];
	self.view.backgroundColor = [UIColor blackColor];
	if ([self valueForKey:@"_tableView"]) {
		UITableView *tableView = (UITableView *)[self valueForKey:@"_tableView"];
		tableView.backgroundColor = [UIColor blackColor];
	}
}
%end

//fix conversation edit color

@interface CKConversationListStandardCell : UITableViewCell
@end

%hook CKConversationListStandardCell
-(void)layoutSubviews{
	%orig;
	if ([self valueForKey:@"_contentView"]) {
		UIView *contentView = (UIView *)[self valueForKey:@"_contentView"];
		contentView.backgroundColor = [UIColor clearColor];
	}
	if ([self valueForKey:@"_avatarView"]) {
		UIView *avatarView = (UIView *)[self valueForKey:@"_avatarView"];
		avatarView.backgroundColor = [UIColor clearColor];
		if ([self valueForKey:@"_avatarView"]) {
			UIImageView *imageView = (UIImageView *)[self valueForKey:@"_imageView"];
			imageView.backgroundColor = [UIColor clearColor];
		}
	}
}
%end

// add credits

@interface CKConversationListController : UIViewController
@end

%hook CKConversationListController
-(void)setEditing:(BOOL)arg1 animated:(BOOL)arg2 {
	%orig;
	if(arg1) {
		UIBarButtonItem* duskButton = [[UIBarButtonItem alloc] initWithTitle:@"Dusk" style:UIBarButtonItemStylePlain target:self action:@selector(duskButtonClicked:)];
		self.navigationItem.rightBarButtonItem = duskButton;
	} else {
		UIBarButtonItem* composeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeButtonClicked:)];
		self.navigationItem.rightBarButtonItem = composeButton;
	}
}

%new
-(void)duskButtonClicked:(id)sender{
	UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Dusk"
                                 message:@"Dusk (Messages) provides a dark mode for Messages. This is a beta release.\n\n© Simalary (Chris) 2019"
                                 preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* dismissButton = [UIAlertAction
                               actionWithTitle:@"Dismiss"
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {

                               }];

    [alert addAction:dismissButton];

    [self presentViewController:alert animated:YES completion:nil];
}
%end

%ctor {
	@autoreleasepool {
		if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.MobileSMS"]){
			darkTheme = [[%c(CKUIThemeDark) alloc] init];
			%init;
		}	
	}
}