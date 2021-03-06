//
//  HelloOpenGLAppDelegate.h
//  DoF
//
//  Created by Anthony Walker


#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    ViewController* _glView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet ViewController *glView;

@property (retain, nonatomic) IBOutlet UIImageView *outlet;

@property (retain, nonatomic) IBOutlet UILabel *label;

@end
