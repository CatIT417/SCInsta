#import "../../InstagramHeaders.h"
#import "../../Manager.h"
#import "../../Utils.h"
#import "../../Downloader/Download.h"

/* * Feed * */

// Download feed images
%hook IGFeedPhotoView

static SCIDownloadDelegate *feedPhotoDownloadDelegate;

- (void)didMoveToSuperview {
    %orig;

    if ([SCIManager getPref:@"dw_feed_posts"]) {
        [self addLongPressGestureRecognizer];
    }

    return;
}
%new - (void)addLongPressGestureRecognizer {
    NSLog(@"[SCInsta] Adding feed photo download long press gesture recognizer");

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.5;
    longPress.numberOfTouchesRequired = 3;

    [self addGestureRecognizer:longPress];
}
%new - (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state != UIGestureRecognizerStateBegan) return;

    // Get photo instance
    IGPhoto *photo;

    if ([self.delegate isKindOfClass:%c(IGFeedItemPhotoCell)]) {
        IGFeedItemPhotoCellConfiguration *_configuration = MSHookIvar<IGFeedItemPhotoCellConfiguration *>(self.delegate, "_configuration");
        if (!_configuration) return;

        photo = MSHookIvar<IGPhoto *>(_configuration, "_photo");
    }
    else if ([self.delegate isKindOfClass:%c(IGFeedItemPagePhotoCell)]) {
        IGFeedItemPagePhotoCell *pagePhotoCell = self.delegate;

        photo = pagePhotoCell.pagePhotoPost.photo;
    }

    NSURL *photoUrl = [SCIUtils getPhotoUrl:photo];
    if (!photoUrl) {
        [SCIUtils showErrorHUDWithDescription:@"Could not extract photo url from post"];
        
        return;
    }

    // Download image & show in share menu
    feedPhotoDownloadDelegate = [[SCIDownloadDelegate alloc] initWithAction:quickLook showProgress:NO];
    [feedPhotoDownloadDelegate downloadFileWithURL:photoUrl
                                     fileExtension:[[photoUrl lastPathComponent]pathExtension]
                                          hudLabel:nil
                                      ];
}
%end

// Download feed videos
%hook IGModernFeedVideoCell.IGModernFeedVideoCell

static SCIDownloadDelegate *feedVideoDownloadDelegate;

- (void)didMoveToSuperview {
    %orig;

    if ([SCIManager getPref:@"dw_feed_posts"]) {
        [self addLongPressGestureRecognizer];
    }

    return;
}
%new - (void)addLongPressGestureRecognizer {
    NSLog(@"[SCInsta] Adding feed video download long press gesture recognizer");

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.5;
    longPress.numberOfTouchesRequired = 3;

    [self addGestureRecognizer:longPress];
}
%new - (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state != UIGestureRecognizerStateBegan) return;

    NSURL *videoUrl = [SCIUtils getVideoUrlForMedia:[self mediaCellFeedItem]];
    if (!videoUrl) {
        [SCIUtils showErrorHUDWithDescription:@"Could not extract video url from post"];

        return;
    }

    // Download video & show in share menu
    feedVideoDownloadDelegate = [[SCIDownloadDelegate alloc] initWithAction:share showProgress:YES];
    [feedVideoDownloadDelegate downloadFileWithURL:videoUrl
                                     fileExtension:[[videoUrl lastPathComponent] pathExtension]
                                          hudLabel:nil];
}
%end


/* * Reels * */

// Download reels (photos)
%hook IGSundialViewerPhotoView

static SCIDownloadDelegate *reelsPhotoDownloadDelegate;

- (void)didMoveToSuperview {
    %orig;

    if ([SCIManager getPref:@"dw_reels"]) {
        [self addLongPressGestureRecognizer];
    }

    return;
}
%new - (void)addLongPressGestureRecognizer {
    NSLog(@"[SCInsta] Adding reels photo download long press gesture recognizer");

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.5;
    longPress.numberOfTouchesRequired = 3;

    [self addGestureRecognizer:longPress];
}
%new - (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state != UIGestureRecognizerStateBegan) return;

    IGPhoto *_photo = MSHookIvar<IGPhoto *>(self, "_photo");

    NSURL *photoUrl = [SCIUtils getPhotoUrl:_photo];
    if (!photoUrl) {
        [SCIUtils showErrorHUDWithDescription:@"Could not extract photo url from reel"];

        return;
    }

    // Download image & show in share menu
    feedPhotoDownloadDelegate = [[SCIDownloadDelegate alloc] initWithAction:quickLook showProgress:NO];
    [feedPhotoDownloadDelegate downloadFileWithURL:photoUrl
                                     fileExtension:[[photoUrl lastPathComponent]pathExtension]
                                          hudLabel:nil
                                      ];
}
%end

// Download reels (videos)
%hook IGSundialViewerVideoCell

static SCIDownloadDelegate *reelsVideoDownloadDelegate;

- (void)didMoveToSuperview {
    %orig;

    if ([SCIManager getPref:@"dw_reels"]) {
        [self addLongPressGestureRecognizer];
    }

    return;
}
%new - (void)addLongPressGestureRecognizer {
    NSLog(@"[SCInsta] Adding reels video download long press gesture recognizer");

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.5;
    longPress.numberOfTouchesRequired = 3;

    [self addGestureRecognizer:longPress];
}
%new - (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state != UIGestureRecognizerStateBegan) return;
    
    NSURL *videoUrl = [SCIUtils getVideoUrlForMedia:self.video];
    if (!videoUrl) {
        [SCIUtils showErrorHUDWithDescription:@"Could not extract video url from reel"];

        return;
    }

    // Download video & show in share menu
    reelsVideoDownloadDelegate = [[SCIDownloadDelegate alloc] initWithAction:share showProgress:YES];
    [reelsVideoDownloadDelegate downloadFileWithURL:videoUrl
                                     fileExtension:[[videoUrl lastPathComponent] pathExtension]
                                          hudLabel:nil];
}
%end


/* * Stories * */

// Download story (images)
%hook IGStoryPhotoView

static SCIDownloadDelegate *storyPhotoDownloadDelegate;

- (void)didMoveToSuperview {
    %orig;

    if ([SCIManager getPref:@"dw_story"]) {
        [self addLongPressGestureRecognizer];
    }

    return;
}
%new - (void)addLongPressGestureRecognizer {
    NSLog(@"[SCInsta] Adding story photo download long press gesture recognizer");

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.5;
    longPress.numberOfTouchesRequired = 3;

    [self addGestureRecognizer:longPress];
}
%new - (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state != UIGestureRecognizerStateBegan) return;

    NSURL *photoUrl = [SCIUtils getPhotoUrlForMedia:[self item]];
    if (!photoUrl) {
        [SCIUtils showErrorHUDWithDescription:@"Could not extract photo url from story"];
        
        return;
    }

    // Download image & show in share menu
    storyPhotoDownloadDelegate = [[SCIDownloadDelegate alloc] initWithAction:quickLook showProgress:NO];
    [storyPhotoDownloadDelegate downloadFileWithURL:photoUrl
                                     fileExtension:[[photoUrl lastPathComponent]pathExtension]
                                          hudLabel:nil
                                      ];
}
%end

// Download story (videos)
%hook IGStoryVideoView

static SCIDownloadDelegate *storyVideoDownloadDelegate;

- (void)didMoveToSuperview {
    %orig;

    if ([SCIManager getPref:@"dw_story"]) {
        [self addLongPressGestureRecognizer];
    }

    return;
}
%new - (void)addLongPressGestureRecognizer {
    NSLog(@"[SCInsta] Adding reels video download long press gesture recognizer");

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.5;
    longPress.numberOfTouchesRequired = 3;

    [self addGestureRecognizer:longPress];
}
%new - (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state != UIGestureRecognizerStateBegan) return;

    IGStoryFullscreenSectionController *captionDelegate = self.captionDelegate;
    if (!captionDelegate) return;
    
    NSURL *videoUrl = [SCIUtils getVideoUrlForMedia:captionDelegate.currentStoryItem];
    if (!videoUrl) {
        [SCIUtils showErrorHUDWithDescription:@"Could not extract video url from story"];

        return;
    }

    // Download video & show in share menu
    storyVideoDownloadDelegate = [[SCIDownloadDelegate alloc] initWithAction:share showProgress:YES];
    [storyVideoDownloadDelegate downloadFileWithURL:videoUrl
                                     fileExtension:[[videoUrl lastPathComponent] pathExtension]
                                          hudLabel:nil];
}
%end


/* * Profile pictures * */

%hook IGProfilePictureImageView

static SCIDownloadDelegate *pfpDownloadDelegate;

- (void)didMoveToSuperview {
    %orig;

    if ([SCIManager getPref:@"save_profile"]) {
        [self addLongPressGestureRecognizer];
    }

    return;
}
%new - (void)addLongPressGestureRecognizer {
    NSLog(@"[SCInsta] Adding profile picture long press gesture recognizer");

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self addGestureRecognizer:longPress];
}
%new - (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state != UIGestureRecognizerStateBegan) return;

    IGImageRequest *_imageRequest = MSHookIvar<IGImageRequest *>(self, "_imageRequest");
    if (!_imageRequest) return;
    
    NSURL *imageUrl = [_imageRequest url];
    if (!imageUrl) return;

    // Download image & preview in quick look
    pfpDownloadDelegate = [[SCIDownloadDelegate alloc] initWithAction:quickLook showProgress:NO];
    [pfpDownloadDelegate downloadFileWithURL:imageUrl
                            fileExtension:[[imageUrl lastPathComponent] pathExtension]
                                 hudLabel:@"Loading"];
}
%end