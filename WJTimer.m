

#import "WJTimer.h"

@interface WJTimer ()

@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic) SEL selector;
@property(nonatomic,weak) id target;

@end

@implementation WJTimer

+ (WJTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo {
    WJTimer *timer = [[WJTimer alloc] init];
    timer.timer = [NSTimer scheduledTimerWithTimeInterval:ti target:timer selector:@selector(timerAction:) userInfo:userInfo repeats:yesOrNo];
    timer.selector = aSelector;
    timer.target = aTarget;
    return timer;
}


+ (WJTimer *)timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {
    WJTimer *timer = [[WJTimer alloc] init];
    timer.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:timer selector:@selector(blockAction:) userInfo:block repeats:repeats];
    return timer;
}

+ (void)blockAction:(NSTimer *)timer {
    void (^block)(NSTimer *timer) = timer.userInfo;
    if (block) {
        block(timer);
    }
}

- (void)invalidate {
    [self.timer invalidate];
    self.target = nil;
    self.selector = nil;
}

- (void)timerAction:(id)sender {
    if (self.target) {
        if (self.selector) {
            if ([self.target respondsToSelector:self.selector]) {
                //屏蔽警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self.target performSelector:self.selector withObject:self];
#pragma clang diagnostic pop
            }
        }
    } else {
        [self invalidate];
    }
}

@end
