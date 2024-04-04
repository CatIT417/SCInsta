#import "../../InstagramHeaders.h"
#import "../../Manager.h"

%hook IGExploreGridViewController
- (void)viewDidLoad {
    if ([BHIManager hideExploreGrid]) {
        NSLog(@"[BHInsta] Hiding explore grid");

        [[self view] removeFromSuperview];

        return;
    }
    return %orig;
}
%end

%hook IGExploreViewController
- (void)viewDidLoad {
    %orig;

    if ([BHIManager hideExploreGrid]) {
        NSLog(@"[BHInsta] Hiding explore grid");

        IGShimmeringGridView *shimmeringGridView = MSHookIvar<IGShimmeringGridView *>(self, "_shimmeringGridView");
        [shimmeringGridView removeFromSuperview];
    }
}
%end