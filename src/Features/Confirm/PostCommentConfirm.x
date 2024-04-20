#import "../../Manager.h"
#import "../../Utils.h"

%hook IGCommentComposingController
- (void)_onSendButtonTapped:(id)arg1 {
    if ([SCIManager postCommentConfirmation]) {
        NSLog(@"[SCInsta] Confirm post comment triggered");

        [SCIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
%end