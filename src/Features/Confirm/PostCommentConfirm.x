#import "../../Manager.h"
#import "../../Utils.h"

%hook IGCommentComposer.IGCommentComposerController
- (void)onSendButtonTap {
    if ([SCIManager postCommentConfirmation]) {
        NSLog(@"[SCInsta] Confirm post comment triggered");

        [SCIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
%end