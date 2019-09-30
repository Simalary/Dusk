#import <UIKit/UIColor.h>

@interface UIColor (DM)
+ (UIColor *)colorFromHexString:(NSString *)hexString;
- (UIImage *)thumbnailWithSize:(CGSize)size;
- (BOOL)isLightColor;
@end