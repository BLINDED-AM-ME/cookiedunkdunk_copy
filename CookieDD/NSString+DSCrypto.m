//
//  NSString+DSCrypto.m
//  DS Common
//
//  Created by Ben Stahlhood on 9/8/11.
//  Copyright (c) 2011-2013 DS Media Labs, Inc. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "NSString+DSCrypto.h"


@implementation NSString (DSCrypto)

- (NSString *)stringDigestUsingHmacSha256WithKey:(NSString *)key {
    const char *s = [self cStringUsingEncoding:NSUTF8StringEncoding];
    const char *k = [key cStringUsingEncoding:NSUTF8StringEncoding];
        
    // This is the destination
    unsigned char digest[CC_SHA256_DIGEST_LENGTH] = {0};
    
    CCHmac(kCCHmacAlgSHA256, k, strlen(k), s, strlen(s), digest);
    
    NSString *hash = nil;
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    hash = output;

    return hash;
}

@end
