//
//  DocumentWindowController.m
//  SlackrobatReader
//
//  Created by Stuart Johnston on 9/26/13.
//  Copyright (c) 2013 Stuart Johnston. All rights reserved.
//

#import "DocumentWindowController.h"

#import "PageNumberFormatter.h"


@interface DocumentWindowController ()

@end

@implementation DocumentWindowController

@synthesize documentModel;

- (id)initWithDocument:(DocumentModel *)document {
    self = [super initWithWindowNibName:@"DocumentWindow"];
    if (self) {
        [self setDocumentModel:document];
        [[self window] setTitle:[NSString stringWithFormat:@"%@ - %@", [documentModel documentFileName], [documentModel documentURL]]];
        [[self documentView] setDocument:[[self documentModel] document]];
        [[self documentThumbnailView] setPDFView:[self documentView]];
        
        undoManager = [[NSUndoManager alloc] init];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}



- (void)nextPage {
    [[self documentView] goToNextPage:nil];
    [[undoManager prepareWithInvocationTarget: self] previousPage];
}

- (void)previousPage {
    [[self documentView] goToPreviousPage:nil];
    [[undoManager prepareWithInvocationTarget: self] nextPage];
}
    
- (void)goToPageNumber:(NSUInteger)pageNumber {
    NSUInteger previousPage = [[[self documentModel] document] indexForPage:[[self documentView] currentPage]];
    PDFPage *page = [[documentModel document] pageAtIndex:pageNumber];
    [[self documentView] goToPage:page];
    [[undoManager prepareWithInvocationTarget:self] goToPageNumber:previousPage];
}


- (IBAction)navigateForward:(id)sender {
    if ([undoManager canRedo]) {
        // Attempt to redo
        [undoManager redo];
    } else {
        // Attempt to go forward
        [self nextPage];
    }
}

- (IBAction)navigateBackward:(id)sender {
    if ([undoManager canUndo]) {
        [undoManager undo];
    } else {
        [self previousPage];
    }
}

- (IBAction)navigateGoTo:(id)sender {
    // Prompt the user for a page number
    NSAlert *alert = [NSAlert alertWithMessageText:@"Go To Page: "
                                     defaultButton:@"Go To"
                                   alternateButton:@"Cancel"
                                       otherButton:nil
                         informativeTextWithFormat:@""];

    
    NSTextField *input = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 120, 24)];
    PageNumberFormatter *formatter = [[PageNumberFormatter alloc] init];
    [input setFormatter:formatter];
    
    [alert setAccessoryView:input];
    NSInteger button = [alert runModal];
    
    if (button == NSAlertDefaultReturn && [[input stringValue] length] > 0 && [[input stringValue] length] <= [[documentModel document] pageCount]) {
        NSUInteger pageNumber = [input integerValue] - 1; // Pages are 1-indexed
        [self goToPageNumber:pageNumber];
    }
}



@end
