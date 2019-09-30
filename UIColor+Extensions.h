#import <UIKit/UIColor.h>

@interface UIColor (DuskMessages)
+ (UIColor *)colorFromHexString:(NSString *)hexString;
- (UIImage *)thumbnailWithSize:(CGSize)size;
- (BOOL)isLightColor;
@end