#import "EmeraldStockModuleViewController.h"

@interface EmeraldPillContainerViewController : UIViewController
@property (nonatomic, retain) _UIBackdropView *pillBackdropView;
@property (nonatomic, retain) UIView *containerView;
@property (nonatomic, retain) NSString *primaryPillIdentifier;
@property (nonatomic, retain) NSString *temporaryPillIdentifier;
@property (nonatomic, assign) BOOL editing;
+(id)sharedInstance;
-(void)updatePillForChangeOfIdentifier;
-(void)presentPillsForSelection;
-(void)requestPillForIdentifier:(NSString *)identifier;
-(void)sacrificePillForIdentifier:(NSString *)identifier;
-(UIColor *)textColor;
@end

@interface SpringBoard : UIApplication
+(id)sharedAppplication;
@end

@interface UILabel (Private)
-(void)setMarqueeEnabled:(BOOL)arg1;
-(void)setMarqueeRunning:(BOOL)arg1;
@end

BOOL configured;

@implementation EmeraldStockModuleViewController
- (id)init {
	self = [super init];

	if (self) {
		self.tickerLabel = [[UILabel alloc] init];
		self.tickerLabel.textAlignment = NSTextAlignmentCenter;
		self.tickerLabel.alpha = 0.7;
		self.tickerLabel.textColor = [[NSClassFromString(@"EmeraldPillContainerViewController") sharedInstance] textColor];
		self.tickerLabel.font = [UIFont systemFontOfSize:8 weight:UIFontWeightLight];
		[self.view addSubview:self.tickerLabel];

		self.priceLabel = [[UILabel alloc] init];
		self.priceLabel.textAlignment = NSTextAlignmentCenter;
		self.priceLabel.textColor = [[NSClassFromString(@"EmeraldPillContainerViewController") sharedInstance] textColor];
		self.priceLabel.font = [UIFont systemFontOfSize:8 weight:UIFontWeightSemibold];
		[self.view addSubview:self.priceLabel];
	}

	[self updatePillData];

	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)arg1 {
}

- (void)viewWillLayoutSubviews {
	if(configured) {
		[self.tickerLabel sizeToFit];
		self.tickerLabel.frame = CGRectMake(self.view.frame.size.height/5, 0, self.tickerLabel.frame.size.width, self.view.frame.size.height);
	} else {
		self.tickerLabel.frame = CGRectMake(10,0,self.view.frame.size.width - 20, self.view.frame.size.height);
	}

	CGFloat priceWidth = self.view.frame.size.width - self.tickerLabel.frame.size.width - (self.view.frame.size.height/5*2) - 6; 
	
	self.priceLabel.frame = CGRectMake(self.view.frame.size.width - (self.view.frame.size.height/5) - priceWidth, 0, priceWidth, self.view.frame.size.height);
	[self.priceLabel setMarqueeEnabled:TRUE];
	[self.priceLabel setMarqueeRunning:TRUE];
}

-(BOOL)_canShowWhileLocked {
	return TRUE;
}

-(void)setDarkModeEnabled:(BOOL)enabled {
	[super setDarkModeEnabled:enabled];
	self.tickerLabel.textColor = enabled ? [UIColor whiteColor] : [UIColor blackColor];
	self.priceLabel.textColor = enabled ? [UIColor whiteColor] : [UIColor blackColor];
}

-(void)updatePillData {
	NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.laughingquoll.EmeraldPrefs.plist"];
	
	NSString *ticker = [settings objectForKey:@"stonksTicket"];
	NSString *apiKey = @"N8I4FBGUOGNFWL5D"; //[settings objectForKey:@"alphaVantageCode"];

	if(ticker && apiKey.length > 1){
		configured = true;
		NSString *path = [NSString stringWithFormat:@"https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=%@&apikey=%@", ticker, apiKey];
		NSURL *url = [NSURL URLWithString:path];
		NSData *data = [[NSData alloc] initWithContentsOfURL:url];
		if(data){
			NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];

			NSDictionary *quoteDictonary = [jsonDictionary objectForKey:@"Global Quote"];
			if([quoteDictonary valueForKey:@"05. price"]){
				NSString *price = [quoteDictonary valueForKey:@"05. price"];
				self.priceLabel.text = [NSString stringWithFormat:@"$%@", [price substringToIndex:[price length]-5]];
			} else {
				self.priceLabel.text = @"Error";
			}
		} else {
			self.priceLabel.text = @"Error";
		}
		self.tickerLabel.text = ticker;

		[self performSelector:@selector(updatePillData) withObject:nil afterDelay:300.0];
	} else {
		self.tickerLabel.text = @"Configure Stock Pill Settings";
		[self.tickerLabel setMarqueeEnabled:TRUE];
		[self.tickerLabel setMarqueeRunning:TRUE];
		[self.priceLabel setMarqueeEnabled:FALSE];
		[self.priceLabel setMarqueeRunning:FALSE];
	}
}
@end