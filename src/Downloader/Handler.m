#import "Handler.h"
#import "Download.h"
#import "../Utils.h"

@implementation SCIDownloadHandler

- (instancetype)initWithDelegate:(SCIDownload *)downloadDelegate {
    self = [super init];
    
    if (self) {
        // Properties
        self.Session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        // Ivars
        delegate = downloadDelegate;
    }

    return self;
}

// Create download
- (void)downloadFileWithURL:(NSURL *)url fileExtension:(NSString *)fileExtension {
    // Check if required parameters are missing
    if (!url || !fileExtension) {

        [delegate downloadDidFailureWithError:[SCIUtils errorWithDescription:@"Required parameters are missing"]];

        return;
    }

    // Set class properties
    self.fileExtension = fileExtension;

    NSLog(@"[SCInsta] Download Handler: Starting download of url: %@", url);

    // Create & start download
    NSURLSessionDownloadTask *downloadTask = [self.Session downloadTaskWithURL:(NSURL *)url];
    [downloadTask resume];
}

// Download Progress
- (void)URLSession:(NSURLSession *)session
                 downloadTask:(NSURLSessionDownloadTask *)downloadTask
                 didWriteData:(int64_t)bytesWritten
            totalBytesWritten:(int64_t)totalBytesWritten
    totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    float prog = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;

    [delegate downloadProgress:prog];
}

// Success
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location
{
    NSLog(@"[SCInsta] Download Handler: Finished download for url: \"%@\"", downloadTask.currentRequest.URL.absoluteString);
    
    // Move downloaded file to cache directory
    NSURL *filePath = [self moveFileToCacheDir:location];

    [delegate downloadDidFinish:filePath];
}

// Failure
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
    NSLog(@"[SCInsta] Download Handler: Download aborted: %@", error);
    
    [delegate downloadDidFailureWithError:error];
}


// Rename downloaded file & move from documents dir -> cache dir
- (NSURL *)moveFileToCacheDir:(NSURL *)oldPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Verify oldPath exists
    if (![fileManager fileExistsAtPath:oldPath.path]) {
        NSLog(@"[SCInsta] Download Handler: File does not exist at path: %@", oldPath.absoluteString);

        [delegate downloadDidFailureWithError:[SCIUtils errorWithDescription:@"File does not exist at requested path"]];

        return nil;
    }

    NSString *cachesFolder = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Caches"];

    NSError *fileMoveError;
    NSURL *newPath = [[NSURL fileURLWithPath:cachesFolder] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", NSUUID.UUID.UUIDString, self.fileExtension]];
    
    NSLog(@"[SCInsta] Download Handler: Moving file from: %@ to: %@", oldPath.absoluteString, newPath.absoluteString);

    // Move file to cache directory
    [fileManager moveItemAtURL:oldPath toURL:newPath error:&fileMoveError];

    if (fileMoveError) {
        NSLog(@"[SCInsta] Download Handler: Error while moving file: %@", oldPath.absoluteString);
        NSLog(@"[SCInsta] Download Handler: %@", fileMoveError);
    }

    return newPath;
}

@end