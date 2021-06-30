//
//  KeyCenter.m
//  OpenLive
//
//  Created by GongYuhua on 2016/9/12.
//  Copyright © 2016 Agora. All rights reserved.
//

#import "KeyCenter.h"

@implementation KeyCenter
+ (NSString *)AppId {
    return @"5b51eb9d1472436bba3040b2714801aa";
}

// assign token to nil if you have not enabled app certificate
+ (NSString *)Token {
    return nil;
}
@end
