//
//  DocumentWindowController.m
//  SlackrobatReader
//
//  Created by Stuart Johnston on 9/26/13.
//  Copyright (c) 2013 Stuart Johnston. All rights reserved.
//

#import "DocumentWindowController.h"


@interface DocumentWindowController ()

@end

@implementation DocumentWindowController

- (id)initWithDocument:(LibraryItemModel *)documentModel {
    self = [super initWithWindowNibName:@"DocumentWindow"];
    if (self) {
        [[self window] setTitle:[NSString stringWithFormat:@"%@ - %@", [documentModel documentFileName], [documentModel documentURL]]];
        [[self documentView] setDocument:[documentModel document]];
        [[self documentThumbnailView] setPDFView:[self documentView]];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
