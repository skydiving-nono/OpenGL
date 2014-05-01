//
//  HelloOpenGLAppDelegate.m
//  HelloOpenGL
//


#import "AppDelegate.h"
#import "JCRBlurView.h"
#import "UIImage+StackBlur.h"

@implementation AppDelegate

@synthesize glView=_glView;

@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.glView = [[[ViewController alloc] initWithFrame:screenBounds] autorelease];
    [self.window addSubview:_glView];
    [self.window makeKeyAndVisible];
    
    JCRBlurView *blurView = [JCRBlurView new];
    [blurView setFrame:CGRectMake(0.0f,19.0f,320.0f,568.0f-19.0f)];
    [self.glView addSubview:blurView];
    
    UIGraphicsBeginImageContext(screenBounds.size);
    [self.glView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *newImage = [viewImage stackBlur:8];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.glView.bounds];
    imgView.image = newImage;
    [self.glView addSubview:imgView];
    
//    NSLog(@"blur capture");
//    UIGraphicsBeginImageContext(self.glView.bounds.size);
//    [self.glView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    //Blur the UIImage
//    CIImage *imageToBlur = [CIImage imageWithCGImage:viewImage.CGImage];
//    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
//    [gaussianBlurFilter setValue:imageToBlur forKey: @"inputImage"];
//    [gaussianBlurFilter setValue:[NSNumber numberWithFloat: 10] forKey: @"inputRadius"]; //change number to increase/decrease blur
//    CIImage *resultImage = [gaussianBlurFilter valueForKey: @"outputImage"];
//    
//    //create UIImage from filtered image
//    UIImage *blurrredImage = [[UIImage alloc] initWithCIImage:resultImage];
//    
//    //Place the UIImage in a UIImageView
//    UIImageView *newView = [[UIImageView alloc] initWithFrame:self.glView.bounds];
//    newView.image = blurrredImage;
//    
//    //insert blur UIImageView below transparent view inside the blur image container
////    [self.glView insertSubview:newView belowSubview:self.glView];
//    [self.glView addSubview:newView];
    
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        printf("Hello");
//        self.viewController = [[UIViewController alloc] initWithNibName:@"iPhone" bundle:nil];
//    } else {
//        self.viewController = [[UIViewController alloc] initWithNibName:@"iPad" bundle:nil];
//    }
//    
//    self.window.rootViewController = self.viewController;
    
    return YES;
}

- (UIImage*) blur:(UIImage*)image{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return returnImage;
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
