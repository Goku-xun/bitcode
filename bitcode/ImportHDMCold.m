#import "ImportHDMCold.h"
#import "BTHDMKeychain.h"
#import "KeyUtil.h"
#import "BTBIP39.h"


@interface ImportHDMCold ()
@property(nonatomic, strong) NSString *passwrod;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, readwrite) ImportHDSeedType importHDSeedType;
@property(nonatomic, weak) UIViewController *controller;
@property(nonatomic, strong) NSArray *worldList;
@end

@implementation ImportHDMCold {

}

- (instancetype)initWithController:(UIViewController *)controller content:(NSString *)content worldList:(NSArray *)array passwrod:(NSString *)passwrod importHDSeedType:(ImportHDSeedType)importHDSeedType {
    self = [super init];
    if (self) {
        self.passwrod = passwrod;
        self.content = content;
        self.importHDSeedType = importHDSeedType;
        self.controller = controller;
        self.worldList = array;
    }
    return self;
}

- (void)importHDSeed {}

- (void)showMsg:(NSString *)msg {
    if ([self.controller respondsToSelector:@selector(showMsg:)]) {
        [self.controller performSelector:@selector(showMsg:) withObject:msg];
    }

}

- (void)exit {}


@end
