//
//  PageNumberFormatter.m
//  SlackrobatReader
//
//  Created by Stuart Johnston on 9/27/13.
//  Copyright (c) 2013 Stuart Johnston. All rights reserved.
//

#import "PageNumberFormatter.h"

@implementation PageNumberFormatter

- (BOOL)isPartialStringValid:(NSString *)partialString newEditingString:(NSString **)newString errorDescription:(NSString **)error {
    if ([partialString length] == 0) {
        return YES;
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:partialString];
    int value;
    
    // Require that the page number is greater than 0
    if (!([scanner scanInt:&value] && [scanner isAtEnd] && value > 0)) {
        NSBeep();
        return NO;
    }
    
    return YES;
}

@end
