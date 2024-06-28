#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SCIUtils : NSObject

// Colours
+ (UIColor *)SCIColour_Primary;

// Functions
+ (NSString *)IGVersionString;
+ (BOOL)isNotch;
+ (BOOL)showConfirmation:(void(^)(void))okHandler;
+ (void)prepareAlertPopoverIfNeeded:(UIAlertController*)alert inView:(UIView*)view;

@end