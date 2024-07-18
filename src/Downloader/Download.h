#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// Cyclic imports
@class JGProgressHUD;
@class SCIDownloadHandler;

@interface SCIDownload : NSObject

@property (nonatomic, strong) JGProgressHUD *hud;
@property (nonatomic, strong) SCIDownloadHandler *dlHandler;

- (instancetype)init;
- (void)downloadFileWithURL:(NSURL *)url fileExtension:(NSString *)fileExtension;

// Handler events
- (void)downloadProgress:(float)progress;
- (void)downloadDidFinish:(NSURL *)filePath;
- (void)downloadDidFailureWithError:(NSError *)error;

@end