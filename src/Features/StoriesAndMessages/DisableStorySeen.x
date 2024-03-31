#import "../../InstagramHeaders.h"
#import "../../Manager.h"

%hook IGStorySeenStateUploader
- (id)initWithUserSessionPK:(id)arg1 networker:(id)arg2 {
    if ([BHIManager noSeenReceipt]) {
        NSLog(@"[BHInsta] Prevented seen receipt from being sent");

        return nil;
    } else {
        return %orig;
    }
}

- (id)networker {
    if ([BHIManager noSeenReceipt]) {
        NSLog(@"[BHInsta] Prevented seen receipt from being sent");

        return nil;
    } else {
        return %orig;
    }
}
%end