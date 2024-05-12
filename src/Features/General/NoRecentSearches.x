#import "../../InstagramHeaders.h"
#import "../../Manager.h"

// Most in-app search bars
%hook IGRecentSearchStore
- (id)initWithDiskManager:(id)arg1 recentSearchStoreConfiguration:(id)arg2 {
    if ([SCIManager noRecentSearches]) {
        NSLog(@"[SCInsta] Disabling recent searches");

        return nil;
    }

    return %orig;
}
- (BOOL)addItem:(id)arg1 {
    if ([SCIManager noRecentSearches]) {
        NSLog(@"[SCInsta] Disabling recent searches");

        return nil;
    }

    return %orig;
}
%end

// Recent dm message recipients search bar
%hook IGDirectRecipientRecentSearchStorage
- (id)initWithDiskManager:(id)arg1 directCache:(id)arg2 userStore:(id)arg3 currentUser:(id)arg4 featureSets:(id)arg5 {
    if ([SCIManager noRecentSearches]) {
        NSLog(@"[SCInsta] Disabling recent searches");

        return nil;
    }

    return %orig;
}
%end