//
//  NSNumber+EqualString.m
//  web调用
//
//  Created by 郭朝顺 on 2018/5/4星期五.
//  Copyright © 2018年 乐乐. All rights reserved.
//

#import "NSNumber+EqualString.h"
#import <objc/objc.h>
#import <objc/runtime.h>
@implementation NSNumber (EqualString)

- (BOOL)isEqualToString:(NSString *)aString {
    
    return [self.description isEqualToString:aString];
}

- (NSString *)moneyDescription {
    
    //    double point = [self doubleValue] - [self integerValue] ;
    //    NSString * pointStr = [NSString stringWithFormat:@"%lf",point];
    //    if (pointStr.length > 4 && point>0) {
    //        return [NSString stringWithFormat:@"%.2lf",self.doubleValue];
    //    }
    //    return self.stringValue;
    
    NSLog(@"moneyDescription");
    double conversionValue = [self doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return decNumber.description;
    
    
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
// [NSString stringWithFormat:@"¥ %@",num] , 会调到这个方法
//- (NSString *)descriptionWithLocale:(id)locale{
//    NSLog(@"locale is %@",locale);
//    return [self description];
//}
#pragma clang diagnostic pop


// num.description直接调用才管用 ;  [NSString stringWithFormat:@"¥ %@",num] , 不管用
- (NSString *)description {
    NSLog(@"description");
    double point = [self doubleValue] - [self integerValue] ;
    NSString * pointStr = [NSString stringWithFormat:@"%lf",point];
    if (pointStr.length > 4 && point>0) {
        return [NSString stringWithFormat:@"%.2lf",self.doubleValue];
    }
    return self.stringValue;
}
// po 的时候调用
- (NSString *)debugDescription {
    NSLog(@"debugDescription");
    double point = [self doubleValue] - [self integerValue] ;
    NSString * pointStr = [NSString stringWithFormat:@"%lf",point];
    if (pointStr.length > 4 && point>0) {
        return [NSString stringWithFormat:@"%.2lf",self.doubleValue];
    }
    return self.stringValue;
}


+ (void)load{
    //    [self swizzleInstanceMethod:@selector(description) with:@selector(moneyDescription)];
}

+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;
    
    class_addMethod(self,
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
    return YES;
}







@end

