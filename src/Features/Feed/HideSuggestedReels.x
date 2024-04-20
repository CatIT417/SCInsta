#import "../../InstagramHeaders.h"
#import "../../Manager.h"

// Remove suggested reels (carousel, under suggested posts in feed)
%hook IGFeedScrollableClipsSectionController
- (id)initWithUserSession:(id)arg1
analyticsModule:(id)arg2
sourceModule:(id)arg3
config:(id)arg4
forceDarkMode:(BOOL)arg5
netegoImpressionStrategy:(id)arg6 {
    if ([SCIManager removeSuggestedReels]) {
        NSLog(@"[SCInsta] Hiding suggested reels");

        return nil;
    }
    
    return %orig;
}
%end