//
//  NSString+DSCrypto.h
//
//  Created by Ben Stahlhood on 9/8/11.
//

#import <Foundation/Foundation.h>

@interface NSString (DSCrypto)

- (NSString *)stringDigestUsingHmacSha256WithKey:(NSString *)key;

@end
