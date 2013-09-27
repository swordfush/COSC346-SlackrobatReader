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

const NSString *PreviousPageToolbarItem = @"PreviousPage";
const NSString *NextPageToolbarItem = @"NextPage";


@synthesize documentModel;

- (id)initWithDocument:(DocumentModel *)document {
    self = [super initWithWindowNibName:@"DocumentWindow"];
    if (self) {
        [self setDocumentModel:document];
        [[self window] setTitle:[NSString stringWithFormat:@"%@ - %@", [documentModel documentFileName], [documentModel documentURL]]];
        [[self documentView] setDocument:[[self documentModel] document]];
        [[self documentThumbnailView] setPDFView:[self documentView]];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)nextPage:(id)sender {
    [[self documentView] goToNextPage:sender];
}

- (IBAction)previousPage:(id)sender {
    [[self documentView] goToNextPage:sender];
}



@end
