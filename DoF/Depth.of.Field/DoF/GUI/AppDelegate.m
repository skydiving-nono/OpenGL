//
//  HelloOpenGLAppDelegate.m
//  HelloOpenGL
//
//  Created by Anthony Walker


#import "AppDelegate.h"

@implementation AppDelegate

@synthesize glView=_glView;

@synthesize window=_window;

@synthesize outlet=_outlet;

@synthesize label=_label;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Creating the OpenGL Subview and preparing it for display
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.glView         = [[[ViewController alloc] initWithFrame:screenBounds] autorelease];
    
    // Should the option be chosen this will display the Blend.png file that has been produced
    // in dofRender, in ViewController.m
    NSArray  *paths     = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath  = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Blend.png"];
    NSData   *fileData  = [NSData dataWithContentsOfFile:filePath];
    UIImage  *file      = [UIImage imageWithData:fileData];
    
    // Instead of commenting and uncommenting after each run, this is a more modular approach to choosing
    // which view to display. This is in hopes of having a button or touch change these while the app
    // is running
    
    // option=0: will display "creation" of Blend.png file by showing each of its iterations frame by frame
    // option=1: will display the final product of this file, which should be a "blurred" Blend.png
    int option = 1;
    
    switch (option)
    {
        case 0:
           [self.window addSubview:_glView];
           [self.window makeKeyAndVisible];
            break;
        
        case 1:
            _label.backgroundColor = [UIColor colorWithPatternImage: file];
            break;
            
    }
    
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
    [_outlet release];
    [_label release];
    [super dealloc];
}

@end
