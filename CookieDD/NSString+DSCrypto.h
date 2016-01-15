//
//  NSString+DSCrypto.h
//  TheHeroTimes
//
//  Created by Ben Stahlhood on 9/8/11.
//  Copyright (c) 2011 DS Media Labs, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DSCrypto)

- (NSString *)stringDigestUsingHmacSha256WithKey:(NSString *)key;

@end
