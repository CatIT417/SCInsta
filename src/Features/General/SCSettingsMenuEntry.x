#import "../../InstagramHeaders.h"
#import "../../Manager.h"
#import "../../Controllers/SettingsViewController.h"

// Show SCInsta tweak settings by holding on the Instagram logo for ~1 second
%hook IGImageWithAccessoryButton
- (id)initWithAccessoryImage:(id)arg1 {
    self = %orig;

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress)];
    [self addGestureRecognizer:longPress];

    return self;
}

%new - (void)handleLongPress {
    NSLog(@"[SCInsta] Tweak settings gesture activated");

    UIViewController *rootController = [[UIApplication sharedApplication] delegate].window.rootViewController;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[SCISettingsViewController new]];
    
    [rootController presentViewController:navigationController animated:YES completion:nil];
}
%end