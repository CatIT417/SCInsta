#import "../../InstagramHeaders.h"
#import "../../Manager.h"

%hook IGKeywordSearchModel
- (id)initWithPk:(id)arg1 name:(id)arg2 score:(id)arg3 subtitle:(id)arg4 isPopular:(BOOL)arg5 isMetaAISuggestion:(BOOL)arg6 {
    if ([BHIManager hideTrendingSearches]) {
        NSLog(@"[BHInsta] Hiding trending searches");

        return nil;
    }
    
    return %orig;
}
- (id)initWithDictionary:(id)arg1 {
    if ([BHIManager hideTrendingSearches]) {
        NSLog(@"[BHInsta] Hiding trending searches");

        return nil;
    }
    
    return %orig;
}
%end

// Maybe try something like this to hide reccomended search text?
/* %hook IGAnimatablePlaceholderModel
- (id)initWithId:(id)arg1 placeholderText:(id)arg2 placeholderName:(id)arg3 placeholderType:(id)arg4 {
    if ([BHIManager hideTrendingSearches]) {
        NSLog(@"[BHInsta] Hiding trending searches");

        return nil;
    }
    
    return %orig;
}
%end */