#import "Manager.h"
#import "InstagramHeaders.h"

@implementation SCIManager
+ (BOOL)hideAds {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"hide_ads"];
}
+ (BOOL)hideStoriesTray {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"hide_stories_tray"];
}
+ (BOOL)downloadMedia {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"dw_videos"];
}
+ (BOOL)profileImageSave {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"save_profile"];
}
+ (BOOL)removeSuggestedPost {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"no_suggested_post"];
}
+ (BOOL)removeSuggestedAccounts {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"no_suggested_account"];
}
+ (BOOL)removeSuggestedReels {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"no_suggested_reels"];
}
+ (BOOL)removeSuggestedThreads {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"no_suggested_threads"];
}
+ (BOOL)postLikeConfirmation {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"like_confirm"];
}
+ (BOOL)reelsLikeConfirmation {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"like_confirm_reels"];
}
+ (BOOL)followConfirmation {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"follow_confirm"];
}
+ (BOOL)callConfirmation {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"call_confirm"];
}
+ (BOOL)voiceMessageConfirmation {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"voice_message_confirm"];
}
+ (BOOL)stickerInteractConfirmation {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"sticker_interact_confirm"];
}
+ (BOOL)postCommentConfirmation {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"post_comment_confirm"];
}
+ (BOOL)changeDirectThemeConfirmation {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"change_direct_theme_confirm"];
}
+ (BOOL)copyDecription {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"copy_description"];
}
+ (BOOL)hideReelsTab {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"hide_reels_tab"];
}
+ (BOOL)noRecentSearches {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"no_recent_searches"];
}
+ (BOOL)hideExploreGrid {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"hide_explore_grid"];
}
+ (BOOL)hideTrendingSearches {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"hide_trending_searches"];
}
+ (BOOL)noSuggestedChats {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"no_suggested_chats"];
}
+ (BOOL)noSuggestedUsers {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"no_suggested_users"];
}
+ (BOOL)hideMetaAI {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"hide_meta_ai"];
}
+ (BOOL)Padlock {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"padlock"];
}
+ (BOOL)keepDeletedMessage {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"keep_deleted_message"];
}
+ (BOOL)hideLastSeen {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"remove_lastseen"];
}
+ (BOOL)noScreenShotAlert {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"remove_screenshot_alert"];
}
+ (BOOL)unlimitedReplay {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"unlimited_replay"];
}
+ (BOOL)noSeenReceipt {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"no_seen_receipt"];
}
+ (BOOL)FLEX {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"flex_instagram"];
}


+ (void)cleanCache {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray<NSError *> *deletionErrors = [NSMutableArray array];

    // Temp folder
    NSError *tempFolderError;
    [fileManager removeItemAtURL:[NSURL fileURLWithPath:NSTemporaryDirectory()] error:&tempFolderError];

    if (tempFolderError) [deletionErrors addObject:tempFolderError];

    // Analytics folder
    NSError *analyticsFolderError;
    NSString *analyticsFolder = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Application Support/com.burbn.instagram/analytics"];
    [fileManager removeItemAtURL:[[NSURL alloc] initFileURLWithPath:analyticsFolder] error:&analyticsFolderError];

    if (analyticsFolderError) [deletionErrors addObject:analyticsFolderError];
    
    // Caches folder
    NSString *cachesFolder = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Caches"];
    NSArray *cachesFolderContents = [fileManager contentsOfDirectoryAtURL:[[NSURL alloc] initFileURLWithPath:cachesFolder] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
    for (NSURL *fileURL in cachesFolderContents) {
        NSError *cacheItemDeletionError;
        [fileManager removeItemAtURL:fileURL error:&cacheItemDeletionError];

        if (cacheItemDeletionError) [deletionErrors addObject:cacheItemDeletionError];
    }

    // Log errors
    if (deletionErrors.count > 1) {

        for (NSError *error in deletionErrors) {
            NSLog(@"[SCInsta] File Deletion Error: %@", error);
        }

    }

}
+ (void)showSaveVC:(id)item {
    UIActivityViewController *acVC = [[UIActivityViewController alloc] initWithActivityItems:@[item] applicationActivities:nil];
    if (is_iPad()) {
        acVC.popoverPresentationController.sourceView = topMostController().view;
        acVC.popoverPresentationController.sourceRect = CGRectMake(topMostController().view.bounds.size.width / 2.0, topMostController().view.bounds.size.height / 2.0, 1.0, 1.0);
    }
    [topMostController() presentViewController:acVC animated:true completion:nil];
}
+ (NSString *)getDownloadingPersent:(float)per {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    NSNumber *number = [NSNumber numberWithFloat:per];
    return [numberFormatter stringFromNumber:number];
}
@end