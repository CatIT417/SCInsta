#import "../../InstagramHeaders.h"
#import "../../Manager.h"

%hook IGStorySeenStateUploader
- (id)initWithUserSessionPK:(id)arg1 networker:(id)arg2 {
    if ([SCIManager noSeenReceipt]) {
        NSLog(@"[SCInsta] Prevented seen receipt from being sent");

        return nil;
    }
    
    return %orig;
}

- (id)networker {
    if ([SCIManager noSeenReceipt]) {
        NSLog(@"[SCInsta] Prevented seen receipt from being sent");

        return nil;
    }
    
    return %orig;
}
%end