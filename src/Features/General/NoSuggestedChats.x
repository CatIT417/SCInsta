#import "../../InstagramHeaders.h"
#import "../../Manager.h"

// Channels dms tab (header)
%hook IGDirectInboxHeaderSectionController
- (id)viewModel {
    if ([[%orig title] isEqualToString:@"Suggested"]) {

        if ([SCIManager noSuggestedChats]) {
            NSLog(@"[SCInsta] Hiding suggested chats");

            return nil;
        }

    }

    return %orig;
}
%end

// Channels dms tab (recipients)
%hook IGDirectInboxSuggestedThreadSectionController
- (id)initWithUserSession:(id)arg1 analyticsModule:(id)arg2 delegate:(id)arg3 igvpController:(id)arg4 viewPointActionBlock:(id)arg5 entryPointProvider:(id)arg6 {
    if ([SCIManager noSuggestedChats]) {
        NSLog(@"[SCInsta] Hiding suggested chats");

        return nil;
    }

    return %orig;
}
%end