#import "../../InstagramHeaders.h"
#import "../../Manager.h"

// Disable story data source
%hook IGMainStoryTrayDataSource
- (id)initWithUserSession:(id)arg1 {
    if ([SCIManager hideStoriesTray]) {
        NSLog(@"[SCInsta] Hiding story tray");

        return nil;
    }
    
    return %orig;
}
%end

// Hide story tray (above feed)
%hook IGStoryTraySectionController
- (id)initWithUserSession:(id)arg1
                 dataController:(id)arg2
                     dataSource:(id)arg3
                 loggingContext:(id)arg4
                     entryPoint:(NSInteger)arg5
       traySectionConfiguration:(id)arg6
       storyViewerConfiguration:(id)arg7
       netegoImpressionStrategy:(id)arg8
              isImmersiveNetego:(BOOL)arg9
isForcedDarkModeImmersiveNetEgo:(BOOL)arg10
 immersiveAccessibilityExpanded:(BOOL)arg11
           supportsVerticalTray:(BOOL)arg12
{
    if ([SCIManager hideStoriesTray]) {
        NSLog(@"[SCInsta] Hiding story tray");

        return nil;
    }
    
    return %orig;
}
%end