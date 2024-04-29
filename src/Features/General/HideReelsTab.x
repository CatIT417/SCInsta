#import "../../InstagramHeaders.h"
#import "../../Manager.h"

// Hide reels tab
%hook IGTabBar
- (void)didMoveToWindow {
    %orig;

    if ([SCIManager hideReelsTab]) {
        NSMutableArray *tabButtons = [self valueForKey:@"_tabButtons"];

        NSLog(@"[SCInsta] Hiding reels tab");

        if ([tabButtons count] == 5) {
            [tabButtons removeObjectAtIndex:3];
        }

        [self.subviews[4] setHidden:YES];
    }
}
%end