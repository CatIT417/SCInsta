#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// Cyclic imports
@class SCIDownload;

@interface SCIDownloadHandler : NSObject
{
   SCIDownload *delegate;
}

@property (nonatomic, strong) NSString *fileExtension;

- (instancetype)initWithDelegate:(SCIDownload *)downloadDelegate;

- (void)downloadFileWithURL:(NSURL *)url fileExtension:(NSString *)fileExtension;

- (NSURL *)moveFileToCacheDir:(NSURL *)oldPath;

@end

@interface SCIDownloadHandler () <NSURLSessionDelegate>
@property (nonatomic, strong) NSURLSession *Session;
@end