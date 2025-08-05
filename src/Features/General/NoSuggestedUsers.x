#import "../../InstagramHeaders.h"
#import "../../Manager.h"

// "Welcome to instagram" suggested users in feed
%hook IGSuggestedUnitViewModel
- (id)initWithAYMFModel:(id)arg1 headerViewModel:(id)arg2 {
    if ([SCIManager getBoolPref:@"no_suggested_users"]) {
        NSLog(@"[SCInsta] Hiding suggested users: main feed welcome section");

        return nil;
    }

    return %orig;
}
%end
%hook IGSuggestionsUnitViewModel
- (id)initWithAYMFModel:(id)arg1 headerViewModel:(id)arg2 {
    if ([SCIManager getBoolPref:@"no_suggested_users"]) {
        NSLog(@"[SCInsta] Hiding suggested users: main feed welcome section");

        return nil;
    }

    return %orig;
} 
%end

// Suggested users in profile header
%hook IGProfileHeaderView
- (id)objectsForListAdapter:(id)arg1 {
    NSArray *originalObjs = %orig();
    NSMutableArray *filteredObjs = [NSMutableArray arrayWithCapacity:[originalObjs count]];

    for (id obj in originalObjs) {
        BOOL shouldHide = NO;

        if ([SCIManager getBoolPref:@"no_suggested_users"]) {
            if ([obj isKindOfClass:%c(IGProfileChainingModel)]) {
                NSLog(@"[SCInsta] Hiding suggested users: profile header");

                shouldHide = YES;
            }
        }

        // Populate new objs array
        if (!shouldHide) {
            [filteredObjs addObject:obj];
        }
    }

    return [filteredObjs copy];
}
%end