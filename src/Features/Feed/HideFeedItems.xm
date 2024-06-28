#import "../../InstagramHeaders.h"
#import "../../Manager.h"

static NSArray *removeAdsItemsInList(NSArray *list, BOOL isFeed) {
    NSMutableArray *orig = [list mutableCopy];

    [orig enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        // Remove suggested posts
        if (isFeed && [SCIManager removeSuggestedPost]) {
            if (
                ([obj respondsToSelector:@selector(explorePostInFeed)] && [obj performSelector:@selector(explorePostInFeed)])
                || ([obj isKindOfClass:%c(IGFeedGroupHeaderViewModel)] && [[obj title] isEqualToString:@"Suggested Posts"])
            ) {
                NSLog(@"[SCInsta] Removing suggested posts");

                [orig removeObjectAtIndex:idx];
            }
        }

        // Remove suggested reels (carousel)
        if (isFeed && [SCIManager removeSuggestedReels]) {
            if ([obj isKindOfClass:%c(IGFeedScrollableClipsModel)]) {
                NSLog(@"[SCInsta] Hiding suggested reels: reels carousel");

                [orig removeObjectAtIndex:idx];
            }
        }
        
        // Remove suggested stories (carousel)
        if (isFeed && [SCIManager removeSuggestedReels]) {
            if ([obj isKindOfClass:%c(IGInFeedStoriesTrayModel)]) {
                NSLog(@"[SCInsta] Hiding suggested reels: stories carousel");

                [orig removeObjectAtIndex:idx];
            }
        }
        
        // Remove suggested for you (accounts)
        if (isFeed && [SCIManager removeSuggestedAccounts]) {
            if ([obj isKindOfClass:%c(IGHScrollAYMFModel)]) {
                NSLog(@"[SCInsta] Hiding suggested for you");

                [orig removeObjectAtIndex:idx];
            }
        }

        // Remove suggested threads posts (carousel)
        if (isFeed && [SCIManager removeSuggestedThreads]) {
            if ([obj isKindOfClass:%c(IGBloksFeedUnitModel)] || [obj isKindOfClass:objc_getClass("IGThreadsInFeedModels.IGThreadsInFeedModel")]) {
                NSLog(@"[SCInsta] Hiding threads posts");

                [orig removeObjectAtIndex:idx];
            }
        }

        // Remove ads
        if (([obj isKindOfClass:%c(IGFeedItem)] && ([obj isSponsored] || [obj isSponsoredApp])) || [obj isKindOfClass:%c(IGAdItem)]) {
            NSLog(@"[SCInsta] Removing ads");

            [orig removeObjectAtIndex:idx];
        }
    }];

    return [orig copy];
}

// Suggested posts
%hook IGMainFeedListAdapterDataSource
- (NSArray *)objectsForListAdapter:(id)arg1 {
    if ([SCIManager hideAds]) {
        return removeAdsItemsInList(%orig, YES);
    }

    return %orig;
}
%end
%hook IGContextualFeedViewController
- (NSArray *)objectsForListAdapter:(id)arg1 {
    if ([SCIManager hideAds]) {
        return removeAdsItemsInList(%orig, NO);
    }

    return %orig;
}
%end
%hook IGVideoFeedViewController
- (NSArray *)objectsForListAdapter:(id)arg1 {
    if ([SCIManager hideAds]) {
        return removeAdsItemsInList(%orig, NO);
    }

    return %orig;
}
%end
%hook IGChainingFeedViewController
- (NSArray *)objectsForListAdapter:(id)arg1 {
    if ([SCIManager hideAds]) {
        return removeAdsItemsInList(%orig, NO);
    }

    return %orig;
}
%end
%hook IGStoryAdPool
- (id)initWithUserSession:(id)arg1 {
    if ([SCIManager hideAds]) {
        NSLog(@"[SCInsta] Removing ads");

        return nil;
    }

    return %orig;
}
%end
%hook IGStoryAdsManager
- (id)initWithUserSession:(id)arg1 storyViewerLoggingContext:(id)arg2 storyFullscreenSectionLoggingContext:(id)arg3 viewController:(id)arg4 {
    if ([SCIManager hideAds]) {
        NSLog(@"[SCInsta] Removing ads");

        return nil;
    }

    return %orig;
}
%end
%hook IGStoryAdsFetcher
- (id)initWithUserSession:(id)arg1 delegate:(id)arg2 {
    if ([SCIManager hideAds]) {
        NSLog(@"[SCInsta] Removing ads");

        return nil;
    }

    return %orig;
}
%end
// IG 148.0
%hook IGStoryAdsResponseParser
- (id)parsedObjectFromResponse:(id)arg1 {
    if ([SCIManager hideAds]) {
        NSLog(@"[SCInsta] Removing ads");

        return nil;
    }

    return %orig;
}
- (id)initWithReelStore:(id)arg1 {
    if ([SCIManager hideAds]) {
        NSLog(@"[SCInsta] Removing ads");

        return nil;
    }

    return %orig;
}
%end
%hook IGStoryAdsOptInTextView
- (id)initWithBrandedContentStyledString:(id)arg1 sponsoredPostLabel:(id)arg2 {
    if ([SCIManager hideAds]) {
        NSLog(@"[SCInsta] Removing ads");

        return nil;
    }

    return %orig;
}
%end
%hook IGSundialAdsResponseParser
- (id)parsedObjectFromResponse:(id)arg1 {
    if ([SCIManager hideAds]) {
        NSLog(@"[SCInsta] Removing ads");

        return nil;
    }

    return %orig;
}
- (id)initWithMediaStore:(id)arg1 userStore:(id)arg2 {
    if ([SCIManager hideAds]) {
        NSLog(@"[SCInsta] Removing ads");
        
        return nil;
    }
    
    return %orig;
}
%end

// Hide "suggested for you" text at end of feed
%hook IGEndOfFeedDemarcatorCellTopOfFeed
- (void)configureWithViewConfig:(id)arg1 {
    %orig;

    if ([SCIManager removeSuggestedPost]) {
        NSLog(@"[SCInsta] Hiding end of feed message");

        // Hide suggested for you text
        UILabel *_titleLabel = MSHookIvar<UILabel *>(self, "_titleLabel");
        [_titleLabel setText:@""];
    }

    return;
}
%end