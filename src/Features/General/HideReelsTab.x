#import "../../InstagramHeaders.h"
#import "../../Manager.h"

// Hide reels tab
%hook IGTabBar
- (void)didMoveToWindow {
    %orig;

    if ([BHIManager hideReelsTab]) { // !! change to "hideReelsTab" before commit
        NSMutableArray *tabButtons = [self valueForKey:@"_tabButtons"];

        NSLog(@"[BHInsta] Hiding reels tab");

        if ([tabButtons count] == 5) {
            [tabButtons removeObjectAtIndex:3];
        }

        [self.subviews[4] setHidden:YES];
    }
}
%end