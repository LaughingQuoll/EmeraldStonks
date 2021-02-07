#import "../../EmeraldFramework/EmeraldContentModuleDelegate.h"

@interface EmeraldStockModuleViewController : EmeraldContentModule
@end

@interface EmeraldStockModule : NSObject <EmeraldContentModuleDelegate> {
	EmeraldStockModuleViewController	*_viewController;
}
@property(readonly, nonatomic) EmeraldContentModule *contentViewController;
@end