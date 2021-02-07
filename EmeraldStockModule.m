#import "EmeraldStockModule.h"

@implementation EmeraldStockModule

- (EmeraldContentModule *)contentViewController {
	if (!_viewController) {
		_viewController = [[EmeraldStockModuleViewController alloc] init];
	}
	return _viewController;
}
@end
