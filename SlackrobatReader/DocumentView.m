//
//  DocumentView.m
//  SlackrobatReader
//
//  Created by Stuart Johnston on 10/3/13.
//  Copyright (c) 2013 Stuart Johnston. All rights reserved.
//

#import "DocumentView.h"

@implementation DocumentView

- (void)keyDown:(NSEvent *)theEvent
{
    NSString *chars = [theEvent charactersIgnoringModifiers];
    
    // Pass left and right arrow button presses down the responder chain
    if ([chars length] > 0) {
        unichar code = [chars characterAtIndex:0];
        
        switch (code)
        {
            case NSLeftArrowFunctionKey:
            case NSRightArrowFunctionKey:
            {
                [[self nextResponder] keyDown:theEvent];
                return;
            }
        }
    }
    
    // Otherwise we will just use the standard behaviour
    [super keyDown:theEvent];    
}

@end
