//
//  Dusk
//  Dusk (Messages)
//
//  Dark theme for the Messages app in iOS 12+.
//
//  ©2019 Simalary (Chris)
//

#define DEBUG_PREFIX @"[DUSK MOBILEPHONE]"
#import "DebugLog.h"

// add credits

@interface MPRecentsTableViewController : UIViewController
@end

%hook MPRecentsTableViewController
-(void)setEditing:(BOOL)arg1 animated:(BOOL)arg2 {
	%orig;
	if(!arg1) {
		UIBarButtonItem* duskButton = [[UIBarButtonItem alloc] initWithTitle:@"Dusk" style:UIBarButtonItemStylePlain target:self action:@selector(duskButtonClicked:)];
		self.navigationItem.rightLeftButtonItem = duskButton;
	} else {
		self.navigationItem.rightLeftButtonItem = nil;
		%orig(arg1);
	}
}

%new
-(void)duskButtonClicked:(id)sender{
	UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Dusk"
                                 message:@"Dusk (MobileSMS) provides a dark mode for MobileSMS. This is a beta release.\n\n© Simalary (Chris) 2019"
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
		if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.mobilephone"]){
			%init;
		}	
	}
}