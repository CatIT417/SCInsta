#import "../../Manager.h"
#import "../../Utils.h"
#import "../../InstagramHeaders.h"

// Follow button on profile page
%hook IGFollowController
- (void)_didPressFollowButton {
    // Get user follow status (check if already following user)
    NSInteger UserFollowStatus = self.user.followStatus;

    if ([SCIManager followConfirmation]) {
        NSLog(@"[SCInsta] Confirm follow triggered");

        // Only show confirm dialog if user is not already following
        if (UserFollowStatus == 2) {
            [SCIUtils showConfirmation:^(void) { %orig; }];
        }
        else {
            return %orig;
        }
    } else {
        return %orig;
    }
}
%end

// Follow button on discover people page
%hook IGDiscoverPeopleButtonGroupView
- (void)_onFollowButtonTapped:(id)arg1 {
    if ([SCIManager followConfirmation]) {
        NSLog(@"[SCInsta] Confirm follow triggered");

        [SCIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
- (void)_onFollowingButtonTapped:(id)arg1 {
    if ([SCIManager followConfirmation]) {
        NSLog(@"[SCInsta] Confirm follow triggered");

        [SCIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
%end

// Suggested for you (home feed & profile) follow button
%hook IGHScrollAYMFCell
- (void)_didTapAYMFActionButton {
    if ([SCIManager followConfirmation]) {
        NSLog(@"[SCInsta] Confirm follow triggered");

        [SCIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
%end
%hook IGHScrollAYMFActionButton
- (void)_didTapTextActionButton {
    if ([SCIManager followConfirmation]) {
        NSLog(@"[SCInsta] Confirm follow triggered");

        [SCIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
%end

// Follow button on reels
%hook IGUnifiedVideoFollowButton
- (void)_hackilyHandleOurOwnButtonTaps:(id)arg1 {
    if ([SCIManager followConfirmation]) {
        NSLog(@"[SCInsta] Confirm follow triggered");

        [SCIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
%end

// Follow text on profile (when collapsed into top bar) 
%hook IGProfileViewController
- (void)navigationItemsControllerDidTapHeaderFollowButton:(id)arg1 {
    if ([SCIManager followConfirmation]) {
        NSLog(@"[SCInsta] Confirm follow triggered");
        
        [SCIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
%end

// Follow button on suggested friends (in story section)
%hook IGStorySectionController
- (void)followButtonTapped:(id)arg1 cell:(id)arg2 {
    if ([SCIManager followConfirmation]) {
        NSLog(@"[SCInsta] Confirm follow triggered");
        
        [SCIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
%end