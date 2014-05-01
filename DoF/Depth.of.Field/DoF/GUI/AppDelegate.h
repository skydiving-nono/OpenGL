//
//  HelloOpenGLAppDelegate.h
//  DoF
//


#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    ViewController* _glView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet ViewController *glView;

@end
