//
//  Tools.m
//  DoF
//


#import "Tools.h"

@implementation Tools

+ (void) imageBlend{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *onePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image1.png"];
    NSData *oneData = [NSData dataWithContentsOfFile:onePath];
    UIImage* one    = [UIImage imageWithData:oneData];
    
    NSString *twoPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image2.png"];
    NSData *twoData = [NSData dataWithContentsOfFile:twoPath];
    UIImage* two    = [UIImage imageWithData:twoData];
    
    NSString *threePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image3.png"];
    NSData *threeData = [NSData dataWithContentsOfFile:threePath];
    UIImage* three    = [UIImage imageWithData:threeData];
    
    NSString *fourPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image4.png"];
    NSData *fourData = [NSData dataWithContentsOfFile:fourPath];
    UIImage* four    = [UIImage imageWithData:fourData];
    
    NSString *fivePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image5.png"];
    NSData *fiveData = [NSData dataWithContentsOfFile:fivePath];
    UIImage* five    = [UIImage imageWithData:fiveData];
    
    NSString *sixPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image6.png"];
    NSData *sixData = [NSData dataWithContentsOfFile:sixPath];
    UIImage* six    = [UIImage imageWithData:sixData];
    
    NSString *sevenPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image7.png"];
    NSData *sevenData = [NSData dataWithContentsOfFile:sevenPath];
    UIImage* seven    = [UIImage imageWithData:sevenData];
    
    NSString *eightPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image8.png"];
    NSData *eightData = [NSData dataWithContentsOfFile:eightPath];
    UIImage* eight    = [UIImage imageWithData:eightData];
    
    NSString *ninePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image9.png"];
    NSData *nineData = [NSData dataWithContentsOfFile:ninePath];
    UIImage* nine    = [UIImage imageWithData:nineData];
    
    NSString *tenPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image10.png"];
    NSData *tenData = [NSData dataWithContentsOfFile:tenPath];
    UIImage* ten    = [UIImage imageWithData:tenData];
    
    NSString *elevenPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image11.png"];
    NSData *elevenData = [NSData dataWithContentsOfFile:elevenPath];
    UIImage* eleven    = [UIImage imageWithData:elevenData];
    
    NSString *twelvePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image12.png"];
    NSData *twelveData = [NSData dataWithContentsOfFile:twelvePath];
    UIImage* twelve    = [UIImage imageWithData:twelveData];
    
    NSString *thirteenPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image13.png"];
    NSData *thirteenData = [NSData dataWithContentsOfFile:thirteenPath];
    UIImage* thirteen    = [UIImage imageWithData:thirteenData];
    
    NSString *fourteenPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image14.png"];
    NSData *fourteenData = [NSData dataWithContentsOfFile:fourteenPath];
    UIImage* fourteen    = [UIImage imageWithData:fourteenData];
    
    NSString *fifteenPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image15.png"];
    NSData *fifteenData = [NSData dataWithContentsOfFile:fifteenPath];
    UIImage* fifteen    = [UIImage imageWithData:fifteenData];
    
    NSString *sixteenPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image16.png"];
    NSData *sixteenData = [NSData dataWithContentsOfFile:sixteenPath];
    UIImage* sixteen    = [UIImage imageWithData:sixteenData];
    
    NSString *seventeenPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image17.png"];
    NSData *seventeenData = [NSData dataWithContentsOfFile:seventeenPath];
    UIImage* seventeen    = [UIImage imageWithData:seventeenData];
    
    NSString *eighteenPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image18.png"];
    NSData *eighteenData = [NSData dataWithContentsOfFile:eighteenPath];
    UIImage* eighteen    = [UIImage imageWithData:eighteenData];
    
    NSString *nineteenPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image19.png"];
    NSData *nineteenData = [NSData dataWithContentsOfFile:nineteenPath];
    UIImage* nineteen    = [UIImage imageWithData:nineteenData];
    
    NSString *twentyPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image20.png"];
    NSData *twentyData = [NSData dataWithContentsOfFile:twentyPath];
    UIImage* twenty    = [UIImage imageWithData:twentyData];
    
    NSString *twentyonePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image21.png"];
    NSData *twentyoneData = [NSData dataWithContentsOfFile:twentyonePath];
    UIImage* twentyone    = [UIImage imageWithData:twentyoneData];

    NSString *twentytwoPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image22.png"];
    NSData *twentytwoData = [NSData dataWithContentsOfFile:twentytwoPath];
    UIImage* twentytwo    = [UIImage imageWithData:twentytwoData];
    
    NSString *twentythreePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image23.png"];
    NSData *twentythreeData = [NSData dataWithContentsOfFile:twentythreePath];
    UIImage* twentythree    = [UIImage imageWithData:twentythreeData];
    
    NSString *twentyfourPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image24.png"];
    NSData *twentyfourData = [NSData dataWithContentsOfFile:twentyfourPath];
    UIImage* twentyfour    = [UIImage imageWithData:twentyfourData];
    
    NSString *twentyfivePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image25.png"];
    NSData *twentyfiveData = [NSData dataWithContentsOfFile:twentyfivePath];
    UIImage* twentyfive    = [UIImage imageWithData:twentyfiveData];
    
    UIImageView* oneView = [[UIImageView alloc] initWithImage:one];
    oneView.alpha = 1;
    
    UIImageView* twoView = [[UIImageView alloc] initWithImage:two];
    twoView.alpha = .04;
    [oneView addSubview:twoView];
    
    UIImageView* threeView   = [[UIImageView alloc] initWithImage:three];
    threeView.alpha = .04;
    [oneView addSubview:threeView];
    
    UIImageView* fourView   = [[UIImageView alloc] initWithImage:four];
    fourView.alpha = .04;
    [oneView addSubview:fourView];

    UIImageView* fiveView   = [[UIImageView alloc] initWithImage:five];
    fiveView.alpha = .04;
    [oneView addSubview:fiveView];
    
    UIImageView* sixView   = [[UIImageView alloc] initWithImage:six];
    sixView.alpha = .04;
    [oneView addSubview:sixView];
    
    UIImageView* sevenView   = [[UIImageView alloc] initWithImage:seven];
    sevenView.alpha = .04;
    [oneView addSubview:sevenView];
    
    UIImageView* eightView   = [[UIImageView alloc] initWithImage:eight];
    eightView.alpha = .04;
    [oneView addSubview:eightView];
    
    UIImageView* nineView   = [[UIImageView alloc] initWithImage:nine];
    nineView.alpha = .04;
    [oneView addSubview:nineView];
    
    UIImageView* tenView   = [[UIImageView alloc] initWithImage:ten];
    tenView.alpha = .04;
    [oneView addSubview:tenView];
    
    UIImageView* elevenView   = [[UIImageView alloc] initWithImage:eleven];
    elevenView.alpha = .04;
    [oneView addSubview:elevenView];
    
    UIImageView* twelveView   = [[UIImageView alloc] initWithImage:twelve];
    twelveView.alpha = .04;
    [oneView addSubview:twelveView];
    
    UIImageView* thirteenView = [[UIImageView alloc] initWithImage:thirteen];
    thirteenView.alpha = .04;
    [oneView addSubview:thirteenView];
    
    UIImageView* fourteenView   = [[UIImageView alloc] initWithImage:fourteen];
    fourteenView.alpha = .04;
    [oneView addSubview:fourteenView];
    
    UIImageView* fifteenView = [[UIImageView alloc] initWithImage:fifteen];
    fifteenView.alpha = .04;
    [oneView addSubview:fifteenView];
    
    UIImageView* sixteenView   = [[UIImageView alloc] initWithImage:sixteen];
    sixteenView.alpha = .04;
    [oneView addSubview:sixteenView];
    
    UIImageView* seventeenView = [[UIImageView alloc] initWithImage:seventeen];
    seventeenView.alpha = .04;
    [oneView addSubview:seventeenView];
    
    UIImageView* eightteenView   = [[UIImageView alloc] initWithImage:eighteen];
    eightteenView.alpha = .04;
    [oneView addSubview:eightteenView];
    
    UIImageView* nineteenView = [[UIImageView alloc] initWithImage:nineteen];
    nineteenView.alpha = .04;
    [oneView addSubview:nineteenView];
    
    UIImageView* twentyView   = [[UIImageView alloc] initWithImage:twenty];
    twentyView.alpha = .04;
    [oneView addSubview:twentyView];
    
    UIImageView* twentyoneView = [[UIImageView alloc] initWithImage:twentyone];
    twentyoneView.alpha = .04;
    [oneView addSubview:twentyoneView];
    
    UIImageView* twentytwoView   = [[UIImageView alloc] initWithImage:twentytwo];
    twentytwoView.alpha = .04;
    [oneView addSubview:twentytwoView];
    
    UIImageView* twentythreeView = [[UIImageView alloc] initWithImage:twentythree];
    twentythreeView.alpha = .04;
    [oneView addSubview:twentythreeView];
    
    UIImageView* twentyfourView   = [[UIImageView alloc] initWithImage:twentyfour];
    twentyfourView.alpha = .04;
    [oneView addSubview:twentyfourView];
    
    UIImageView* twentyfiveView = [[UIImageView alloc] initWithImage:twentyfive];
    twentyfiveView.alpha = .04;
    [oneView addSubview:twentyfiveView];
    
    UIGraphicsBeginImageContext(oneView.frame.size);
    [oneView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* blendedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //            [subView release];
    //            [imageView release];
    
    NSString *mergedImage = [NSString stringWithFormat:@"Blend.png"];
    
    NSString *newImgFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:mergedImage];
    [UIImagePNGRepresentation(blendedImage) writeToFile:newImgFilePath atomically:YES];
}

@end
