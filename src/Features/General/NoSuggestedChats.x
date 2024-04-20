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
        else {
            return %orig;
        }

    } else {
        return %orig;
    }
}
%end

// Channels dms tab (recipients)
%hook IGDirectInboxSuggestedThreadSectionController
- (id)initWithUserSession:(id)arg1 analyticsModule:(id)arg2 delegate:(id)arg3 igvpController:(id)arg4 viewPointActionBlock:(id)arg5 entryPointProvider:(id)arg6 {
    if ([SCIManager noSuggestedChats]) {
        NSLog(@"[SCInsta] Hiding suggested chats");

        return nil;
    }
    else {
        return %orig;
    }
}
%end

// Dms search (sponsored section)
%hook IGDirectInboxSearchListAdapterDataSource
- (id)objectsForListAdapter:(id)arg1 {
    if ([SCIManager noSuggestedChats]) {

        NSMutableArray *newObjs = [%orig mutableCopy];

        [newObjs enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

            // Section header 
            if ([obj isKindOfClass:%c(IGLabelItemViewModel)]) {
                if ([[obj labelTitle] isEqualToString:@"Suggested channels"]) {
                    NSLog(@"[SCInsta] Hiding suggested chats (header)");

                    [newObjs removeObjectAtIndex:idx];
                }
            }

            // Broadcast channel recipient
            else if ([obj isKindOfClass:%c(IGDirectRecipientCellViewModel)]) {
                if ([[obj recipient] isBroadcastChannel]) {
                    NSLog(@"[SCInsta] Hiding suggested chats (recipients)");

                    [newObjs removeObjectAtIndex:idx];
                }
            }

        }];

        return [newObjs copy];

    }
    else {
        return %orig;
    }
}
%end