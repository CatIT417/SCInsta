#import <UIKit/UIKit.h>
#import "Utils.h"
#import "InstagramHeaders.h"

@implementation SCIUtils

// Colours
+ (UIColor *)SCIColour_Primary {
    return [UIColor colorWithRed:0/255.0 green:152/255.0 blue:254/255.0 alpha:1];
};

// Functions
+ (NSString *)IGVersionString {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
};
+ (BOOL)isNotch {
    return [[[UIApplication sharedApplication] keyWindow] safeAreaInsets].bottom > 0;
};
+ (BOOL)showConfirmation:(void(^)(void))okHandler {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        okHandler();
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"No!" style:UIAlertActionStyleCancel handler:nil]];

    [topMostController() presentViewController:alert animated:YES completion:nil];

    return nil;
};
+ (void)prepareAlertPopoverIfNeeded:(UIAlertController*)alert inView:(UIView*)view {
    if (alert.popoverPresentationController) {
        // UIAlertController is a popover on iPad. Display it in the center of a view.
        alert.popoverPresentationController.sourceView = view;
        alert.popoverPresentationController.sourceRect = CGRectMake(view.bounds.size.width / 2.0, view.bounds.size.height / 2.0, 1.0, 1.0);
        alert.popoverPresentationController.permittedArrowDirections = 0;
    }
};

@end