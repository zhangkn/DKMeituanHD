
#import "UIBarButtonItem+Extension.h"

#import "UIView+Extension.h"


#ifdef DEBUG
# define NSLog(...) NSLog(__VA_ARGS__)
#else
# define NSLog(...) {}
#endif


#define DKColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define DkGlobalBg DKColor(230, 230, 230)

