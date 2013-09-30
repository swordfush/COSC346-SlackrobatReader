//
//  LibraryItemView.m
//  SlackrobatReader
//
//  Created by Stuart Johnston on 9/26/13.
//  Copyright (c) 2013 Stuart Johnston. All rights reserved.
//

#import "LibraryItemView.h"

@implementation LibraryItemView

@synthesize selected;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    if (selected) {
        NSRect outerFrame = NSMakeRect(0, 0, 128, 128);
        NSRect selectedFrame = NSInsetRect(outerFrame, 1, 1);
        [[NSColor selectedMenuItemColor] set];
        
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:selectedFrame xRadius:6 yRadius:6];
        [path setLineWidth:2.0];
        [path stroke];
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];
    if ([theEvent clickCount] > 1) {
        [NSApplication.sharedApplication sendAction:@selector(collectionItemViewDoubleClick) to:nil from:self];
        return;
    }
}

@end
