//
//  Tools.m
//  DoF
//


#import "Tools.h"

@implementation Tools

//-(void) writeImagsToFile(UIImage*) {
//// UIImage *img = [self screenshot];
//
//// UIImage *img = [self glViewScreenshot];
////
//// NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//// NSString *dynamicFileName = [NSString stringWithFormat:@"Image%i.png", counter];
////
//// NSString *imgFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:dynamicFileName];
////
//// [UIImagePNGRepresentation(img) writeToFile:imgFilePath atomically:YES];
//// if (counter == 25) {
////     printf("there are %i images to be blended", counter);
////     exit(0);
//// }
//}

//while this is a working screenshot method, it does not obtain the glView data
//- (UIImage *) screenshot {
//    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
//    CGRect rect = [keyWindow bounds];
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [keyWindow.layer renderInContext:context];
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return img;
//}

@end
