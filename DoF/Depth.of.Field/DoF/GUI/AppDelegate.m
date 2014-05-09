//
//  HelloOpenGLAppDelegate.m
//  HelloOpenGL
//


#import "AppDelegate.h"

@implementation AppDelegate

@synthesize glView=_glView;

@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.glView = [[[ViewController alloc] initWithFrame:screenBounds] autorelease];
    [self.window addSubview:_glView];
//    [self.window makeKeyAndVisible];
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    
//    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Blend.png"];
//    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
//    
//    UIImage* file    = [UIImage imageWithData:fileData];
//    
//    UIImageView* imageView = [[UIImageView alloc] initWithImage:file];

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

- (void)dealloc
{
    [_glView release];
    [_window release];
    [super dealloc];
}

@end
