#import "Download.h"
#import "Handler.h"
#import "../InstagramHeaders.h"

@implementation SCIDownload

- (instancetype)init {
    self = [super init];
    
    if (self) {
        // Properties
        self.hud = [[JGProgressHUD alloc] init];
        self.dlHandler = [[SCIDownloadHandler alloc] initWithDelegate:self];
    }

    return self;
}
- (void)downloadFileWithURL:(NSURL *)url fileExtension:(NSString *)fileExtension {
    // Show progress gui
    self.hud = [[JGProgressHUD alloc] init];
    self.hud.textLabel.text = @"Downloading";

    [self.hud showInView:topMostController().view];

    NSLog(@"[SCInsta] Download: Sending url \"%@\" with file extension: \".%@\" to download handler", url, fileExtension);

    // Start download via handler
    [self.dlHandler downloadFileWithURL:url fileExtension:fileExtension];
}

// Handler events
- (void)downloadProgress:(float)progress {
    [self.hud setProgress:progress animated:true];
}
- (void)downloadDidFinish:(NSURL *)filePath {
    [self.hud dismiss];

    NSLog(@"[SCInsta] Download: Displaying save dialog");

    [SCIManager showSaveVC:filePath];
}
- (void)downloadDidFailureWithError:(NSError *)error {
    // Get rid of downloading gui
    [self.hud dismiss];

    // Display error hud
    self.hud = [[JGProgressHUD alloc] init];
    self.hud.textLabel.text = error ? error.localizedDescription : @"Error, try again later";
    self.hud.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];

    [self.hud showInView:topMostController().view];
    [self.hud dismissAfterDelay:4.0];
}

@end