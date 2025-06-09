#import "SecurityViewController.h"

@implementation SCISecurityViewController

- (id)init {
    self = [super init];
    if (!self) return nil;

    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(authenticate)
        name:UIApplicationWillEnterForegroundNotification
        object:[UIApplication sharedApplication]
    ];

    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.view.bounds;
    [self.view addSubview:blurView];
    
    UIButton *authenticateButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 200, 60)];
    [authenticateButton setTitle:@"Click to unlock app" forState:UIControlStateNormal];
    authenticateButton.center = self.view.center;
    [authenticateButton addTarget:self action:@selector(authenticate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:authenticateButton];
    
    [self authenticate];
}

- (void)authenticate {
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;

    NSLog(@"[SCInsta] Padlock authentication: Prompting for unlock");

    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
        NSString *reason = @"Authenticate to unlock app";
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:reason reply:^(BOOL success, NSError *authenticationError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    [self dismissViewControllerAnimated:YES completion:nil];

                    isAuthenticationBeingShown = NO;

                    NSLog(@"[SCInsta] Padlock authentication: Unlock success");
                }
                else {
                    NSLog(@"[SCInsta] Padlock authentication: Unlock failed");
                }
            });
        }];
    }
    else {
        NSLog(@"[SCInsta] Padlock authentication: Device authentication not available");

        // Notify user
        JGProgressHUD *HUD = [[JGProgressHUD alloc] init];
        HUD.textLabel.text = @"Authentication not available";
        HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];

        [HUD showInView:topMostController().view];
        [HUD dismissAfterDelay:5.0];
    }
}

@end
