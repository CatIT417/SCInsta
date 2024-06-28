#import "../../InstagramHeaders.h"
#import "../../Manager.h"

// Direct

// Meta AI button functionality on direct search bar
%hook IGDirectInboxViewController
- (void)searchBarMetaAIButtonTappedOnSearchBar:(id)arg1 {
    if ([SCIManager hideMetaAI]) {
        NSLog(@"[SCInsta] Hiding meta ai: direct search bar functionality");

        return;
    }
    
    return %orig;
}
%end

// AI agents in direct new message view
%hook IGDirectRecipientGenAIBotsResult
- (id)initWithGenAIBots:(id)arg1 lastFetchedTimestamp:(id)arg2 {
    if ([SCIManager hideMetaAI]) {
        NSLog(@"[SCInsta] Hiding meta ai: direct recipient ai agents");

        return nil;
    }
    
    return %orig;
}
%end

// Meta AI suggested user in direct new message view
%hook IGDirectThreadCreationViewController
- (id)objectsForListAdapter:(id)arg1 {
    NSMutableArray *newObjs = [%orig mutableCopy];

    [newObjs enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        if ([obj isKindOfClass:%c(IGDirectRecipientCellViewModel)]) {

            // Meta AI suggested user
            if ([[[obj recipient] threadName] isEqualToString:@"Meta AI"]) {
                if ([SCIManager hideMetaAI]) {
                    NSLog(@"[SCInsta] Hiding meta ai: explore search results ai suggestion");

                    [newObjs removeObjectAtIndex:idx];
                }
                
            }

        }
        
    }];

    return [newObjs copy];
}
%end

// Meta AI direct search suggested topics clouds
%hook IGDirectInboxSearchAIAgentsPillsContainerCell
- (void)didMoveToWindow {
    %orig;

    if ([SCIManager hideMetaAI]) {
        NSLog(@"[SCInsta] Hiding meta ai: direct search suggested topics clouds");

        [self removeFromSuperview];
    }
}
%end

// Meta AI direct search suggested topics header
%hook IGLabelItemViewModel
- (id)initWithLabelTitle:(id)arg1
                     tag:(NSInteger)arg2
        uniqueIdentifier:(id)arg3
           configuration:(id)arg4
     accessibilityTraits:(NSUInteger)arg5
{
    self = %orig;

    if ([[self labelTitle] isEqualToString:@"Ask Meta AI"]) {

        if ([SCIManager hideMetaAI]) {
            NSLog(@"[SCInsta] Hiding meta ai: explore suggested topics header");

            return nil;
        }

    }

    return self;
}
%end

// Meta AI direct search prompt suggestions in search results
%hook IGDirectInboxSearchAIAgentsSuggestedPromptRowCell
- (void)didMoveToWindow {
    %orig;

    if ([SCIManager hideMetaAI]) {
        NSLog(@"[SCInsta] Hiding meta ai: direct search ai prompt suggestions");

        [self removeFromSuperview];
    }
}
%end

// Meta AI search bar: opening meta ai chat on return key
%hook IGDirectInboxSearchController
- (void)_presentMetaAiWithPrompt:(id)arg1 presentationCompletion:(id)arg2 entryPoint:(NSInteger)arg3 {
    if ([SCIManager hideMetaAI]) {
        NSLog(@"[SCInsta] Hiding meta ai: present meta ai thread from direct search");

        return;
    }

    return %orig;
}
%end

// Meta AI in message composer
%hook IGDirectCommandSystemListViewController
- (id)objectsForListAdapter:(id)arg1 {
    NSMutableArray *newObjs = [%orig mutableCopy];

    [newObjs enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        if ([obj isKindOfClass:%c(IGDirectCommandSystemViewModel)]) {

            IGDirectCommandSystemViewModel *typedObj = (IGDirectCommandSystemViewModel *)obj;
            IGDirectCommandSystemRow *cmdSystemRow = (IGDirectCommandSystemRow *)[typedObj row];

            IGDirectCommandSystemResult *_commandResult_command = MSHookIvar<IGDirectCommandSystemResult *>(cmdSystemRow, "_commandResult_command");

            // Meta AI
            if ([[_commandResult_command title] isEqualToString:@"Meta AI"]) {
                if ([SCIManager hideMetaAI]) {
                    NSLog(@"[SCInsta] Hiding meta ai: direct message composer suggestion");

                    [newObjs removeObjectAtIndex:idx];
                }
                
            }

            // Meta AI (Imagine)
            if ([[_commandResult_command commandString] isEqualToString:@"/imagine"]) {
                if ([SCIManager hideMetaAI]) {
                    NSLog(@"[SCInsta] Hiding meta ai: direct message composer /imagine suggestion");

                    [newObjs removeObjectAtIndex:idx];
                }
                
            }

        }
        
    }];

    return [newObjs copy];
}
%end

/////////////////////////////////////////////////////////////////////////////

// Explore

// Meta AI search bar: explore/user search results data
%hook IGSearchListKitDataSource
- (id)objectsForListAdapter:(id)arg1 {
    NSMutableArray *newObjs = [%orig mutableCopy];

    [newObjs enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        // Section header 
        if ([obj isKindOfClass:%c(IGLabelItemViewModel)]) {

            // "Ask Meta AI" search results header
            if ([[obj labelTitle] isEqualToString:@"Ask Meta AI"]) {

                if ([SCIManager hideMetaAI]) {
                    NSLog(@"[SCInsta] Hiding meta ai: explore search results header");

                    [newObjs removeObjectAtIndex:idx];
                }
                
            }

        }

        // Meta AI suggested search results
        if ([obj isKindOfClass:%c(IGSearchResultViewModel)]) {

            // itemType 6 is meta ai suggestions
            if ([obj itemType] == 6) {
                if ([SCIManager hideMetaAI]) {
                    NSLog(@"[SCInsta] Hiding meta ai: explore search results ai suggestion");

                    [newObjs removeObjectAtIndex:idx];
                }
                
            }

            // Meta AI user account in search results
            else if ([[[obj title] string] isEqualToString:@"meta.ai"]) {
                if ([SCIManager hideMetaAI]) {
                    NSLog(@"[SCInsta] Hiding meta ai: explore search results meta ai user account suggestion");

                    [newObjs removeObjectAtIndex:idx];
                }
            }

        }
        
    }];

    return [newObjs copy];
}
%end
// Meta AI explore suggested topics clouds
%hook IGSearchResultCloudSectionController
- (id)initWithUserSession:(id)arg1 analyticsModule:(id)arg2 loggingProvider:(id)arg3 {
    if ([SCIManager hideMetaAI]) {
        NSLog(@"[SCInsta] Hiding meta ai: explore suggested topics clouds");

        return nil;
    }
   
    return %orig;
}
%end

/////////////////////////////////////////////////////////////////////////////

// Search / Buttons

// In-app search bars
%hook IGSearchBar
- (void)didMoveToWindow {
    %orig;

    if ([SCIManager hideMetaAI]) {

        // Right meta ai button (in direct search)
        UIView *_secondaryRightButton = MSHookIvar<UIView *>(self, "_secondaryRightButton");
        if (_secondaryRightButton) {
            NSLog(@"[SCInsta] Hiding meta ai: secondary right search bar icon");

            [_secondaryRightButton removeFromSuperview];
        }

    }
}

- (void)_didTapDirectSendButton {
    if ([SCIManager hideMetaAI]) {
        NSLog(@"[SCInsta] Hiding meta ai: tap on direct send button");

        return;
    }

    return %orig;
}

- (void)_didTapMetaAIButton {
    if ([SCIManager hideMetaAI]) {
        NSLog(@"[SCInsta] Hiding meta ai: tap on meta ai button");

        return;
    }

    return %orig;
}

// This removes the padding added to the placeholder text, for the meta ai button
- (CGFloat)_getTextFieldOrginXForSearchBarWithLeftIcon {
    if ([SCIManager hideMetaAI]) {
        NSLog(@"[SCInsta] Hiding meta ai: search bar padding for meta ai button");

        // 43 (orig width) - 22 (meta ai button width) = 21
        return 21;
    }

    return %orig;
}
%end

// Search bar donut button
%hook IGSearchBarDonutButton
- (void)didMoveToWindow {
    %orig;

    if ([SCIManager hideMetaAI]) {
        NSLog(@"[SCInsta] Hiding meta ai: search bar donut button");

        [self removeFromSuperview];
    }
}
%end

// Search typeahead
%hook IGSearchTypeaheadViewController
- (void)_presentMetaAIThreadWithDirectEntryPoint:(NSInteger)arg1 searchEntryPoint:(NSInteger)arg2 prompt:(id)arg3 {
    
    if ([SCIManager hideMetaAI]) {
        NSLog(@"[SCInsta] Hiding meta ai: present meta ai thread from search");

        return;
    }

    return %orig;
}
%end

// Themed in-app buttons
%hook IGTapButton
- (void)didMoveToWindow {
    %orig;

    if ([SCIManager hideMetaAI]) {

        // Hide buttons that are associated with meta ai
        if ([self.accessibilityIdentifier containsString:@"meta_ai"]) {
            NSLog(@"[SCInsta] Hiding meta ai: meta ai associated button");

            [self removeFromSuperview];
        }

    }
}
%end

// Animated spinning icon
%hook IGKeyframeAnimationViewController
- (id)initWithUserSession:(id)arg1 assetURL:(id)assetURL cacheKey:(id)arg3 {
    if ([SCIManager hideMetaAI]) {

        if ([[assetURL absoluteString] isEqualToString:@"https://lookaside.facebook.com/ras/v2/?id=AQABh50YCM9z"]) {
            NSLog(@"[SCInsta] Hiding meta ai: animated spining icon");

            return nil;
        }

        else if ([[assetURL absoluteString] isEqualToString:@"https://lookaside.facebook.com/ras/v2/?id=AQAGo_cgnUHA"]) {
            NSLog(@"[SCInsta] Hiding meta ai: animated spinning icon");

            return nil;
        }

    }

    return %orig;
}
%end