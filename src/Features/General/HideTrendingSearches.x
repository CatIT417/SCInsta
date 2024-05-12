#import "../../InstagramHeaders.h"
#import "../../Manager.h"

%hook IGDSSegmentedPillBarView
- (void)didMoveToWindow {
    %orig;

    if ([[self delegate] isKindOfClass:%c(IGSearchTypeaheadNavigationHeaderView)]) {
        if ([SCIManager hideTrendingSearches]) {
            NSLog(@"[SCInsta] Hiding trending searches");

            [self removeFromSuperview];
        }
    }
}
%end