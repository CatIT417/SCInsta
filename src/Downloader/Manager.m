#import "Manager.h"

@implementation SCIDownloadManager

- (instancetype)initWithDelegate:(id<SCIDownloadDelegateProtocol>)downloadDelegate {
    self = [super init];
    
    if (self) {
        self.delegate = downloadDelegate;
    }

    return self;
}

- (void)downloadFileWithURL:(NSURL *)url fileExtension:(NSString *)fileExtension {
    // Properties
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    self.task = [self.session downloadTaskWithURL:url];
    self.fileExtension = fileExtension;

    [self.task resume];
    [self.delegate downloadDidStart];
}

// URLSession methods
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSLog(@"Task wrote %lld bytes of %lld bytes", bytesWritten, totalBytesExpectedToWrite);
    
    float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
    [self.delegate downloadDidProgress:progress];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {    
    // Move downloaded file to cache directory
    NSURL *finalLocation = [self moveFileToCacheDir:location];

    [self.delegate downloadDidFinishWithFileURL:finalLocation];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"Task completed with error: %@", error);
    
    [self.delegate downloadDidFinishWithError:error];
}

// Rename downloaded file & move from documents dir -> cache dir
- (NSURL *)moveFileToCacheDir:(NSURL *)oldPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Verify oldPath exists
    /* if (![fileManager fileExistsAtPath:oldPath.path]) {
        NSLog(@"[SCInsta] Download Handler: File does not exist at path: %@", oldPath.absoluteString);

        NSError *error = [NSError errorWithDomain:@"com.socuul.scinsta" code:1 userInfo:@{NSLocalizedDescriptionKey: @"File does not exist at requested path"}];
        [self.delegate downloadDidFinishWithError:error];

        return nil;
    } */

    NSString *cacheDirectoryPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSURL *newPath = [[NSURL fileURLWithPath:cacheDirectoryPath] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", NSUUID.UUID.UUIDString, self.fileExtension]];
    
    NSLog(@"[SCInsta] Download Handler: Moving file from: %@ to: %@", oldPath.absoluteString, newPath.absoluteString);

    // Move file to cache directory
    NSError *fileMoveError;
    [fileManager moveItemAtURL:oldPath toURL:newPath error:&fileMoveError];

    if (fileMoveError) {
        NSLog(@"[SCInsta] Download Handler: Error while moving file: %@", oldPath.absoluteString);
        NSLog(@"[SCInsta] Download Handler: %@", fileMoveError);
    }

    return newPath;
}

@end