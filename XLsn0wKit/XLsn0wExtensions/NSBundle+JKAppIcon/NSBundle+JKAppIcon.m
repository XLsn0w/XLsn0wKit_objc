
#import "NSBundle+JKAppIcon.h"

@implementation NSBundle (JKAppIcon)

- (NSString*)xl_appIconPath {
    NSString* iconFilename = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIconFile"] ;
    NSString* iconBasename = [iconFilename stringByDeletingPathExtension] ;
    NSString* iconExtension = [iconFilename pathExtension] ;
    return [[NSBundle mainBundle] pathForResource:iconBasename
                                           ofType:iconExtension] ;
}

- (UIImage*)xl_appIcon {
    UIImage*appIcon = [[UIImage alloc] initWithContentsOfFile:[self xl_appIconPath]] ;
    return appIcon;
}
@end
