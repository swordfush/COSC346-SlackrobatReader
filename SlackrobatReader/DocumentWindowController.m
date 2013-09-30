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
        // Set the document model
        [self setDocumentModel:document];
        
        // Set default search options
        [self setCaseInsensitiveSearch:YES];
        [self setSearchBackwards:NO];
        [self setSearchLiteral:NO];
        
        // Initialize the undo manager used for navigation
        navigationUndoManager = [[NSUndoManager alloc] init];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Hook up the document and thumbnail view
    [[self documentView] setDocument:[[self documentModel] document]];
    [[self documentThumbnailView] setPDFView:[self documentView]];
    
    // Observe page changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageChanged:) name:PDFViewPageChangedNotification object:nil];
    [self pageChanged:nil];
}


// Called when the page being displayed changes, unfortunately it cannot be key-value observed
- (void)pageChanged:(NSNotification *)notification {
    PDFPage *newPage = [[self documentView] currentPage];
    NSUInteger pageIndex = [[[self documentView] document] indexForPage:newPage];
    [self setCurrentPageNumber:pageIndex + 1];
}


- (void)nextPage {
    [[self documentView] goToNextPage:nil];
    [[navigationUndoManager prepareWithInvocationTarget: self] previousPage];
}

- (void)previousPage {
    [[self documentView] goToPreviousPage:nil];
    [[navigationUndoManager prepareWithInvocationTarget: self] nextPage];
}
    
- (void)goToPageNumber:(NSUInteger)pageNumber {
    NSUInteger previousPage = [[[self documentModel] document] indexForPage:[[self documentView] currentPage]];
    PDFPage *page = [[documentModel document] pageAtIndex:pageNumber];
    [[self documentView] goToPage:page];
    [[navigationUndoManager prepareWithInvocationTarget:self] goToPageNumber:previousPage];
}


- (IBAction)navigateForward:(id)sender {
    if ([navigationUndoManager canRedo]) {
        // Attempt to redo
        [navigationUndoManager redo];
    } else {
        // Attempt to go forward
        [self nextPage];
    }
}

- (IBAction)navigateBackward:(id)sender {
    if ([navigationUndoManager canUndo]) {
        [navigationUndoManager undo];
    } else {
        [self previousPage];
    }
}

- (IBAction)navigateGoTo:(id)sender {
    // Prompt the user for a page number
    NSAlert *alert = [NSAlert alertWithMessageText:@"Go To Page: "
                                     defaultButton:@"Go"
                                   alternateButton:@"Cancel"
                                       otherButton:nil
                         informativeTextWithFormat:@""];

    
    NSTextField *input = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 120, 24)];
    PageNumberFormatter *formatter = [[PageNumberFormatter alloc] init];
    [input setFormatter:formatter];
    
    [alert setAccessoryView:input];
    NSInteger button = [alert runModal];
    
    if (button == NSAlertDefaultReturn && [[input stringValue] length] > 0 && [input integerValue] <= [[documentModel document] pageCount]) {
        NSUInteger pageNumber = [input integerValue] - 1; // Pages are 1-indexed
        [self goToPageNumber:pageNumber];
    }
}

- (IBAction)search:(id)sender {
    NSTextField *searchBox = sender;
    NSString *searchString = [searchBox stringValue];

    // Set up the search options
    int searchOptions = 0;
    if ([self caseInsensitiveSearch]) {
        searchOptions |= NSCaseInsensitiveSearch;
    }
    if ([self searchLiteral]) {
        searchOptions |= NSLiteralSearch;
    }
    if ([self searchBackwards]) {
        searchOptions |= NSBackwardsSearch;
    }
    
    PDFSelection *currentSearchSelection = [[self documentView] currentSelection];

    // Perform a new search
    currentSearchSelection = [[[self documentView] document] findString:searchString fromSelection:currentSearchSelection withOptions:searchOptions];
    
    BOOL wrappedAround = NO;
    if (currentSearchSelection == nil) {
        // Attempt to wrap around the document to find a result
        currentSearchSelection = [[[self documentView] document] findString:searchString fromSelection:nil withOptions:searchOptions];
        
        wrappedAround = YES;
    }
    
    if (currentSearchSelection == nil) {
        // If the search selection is still nil then we did not find the string
        NSString *failNotification = [NSString stringWithFormat:@"Failed to find any occurences of \"%@\"", searchString];
        NSAlert *alert = [NSAlert alertWithMessageText:failNotification
                                         defaultButton:nil
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat:@""];
        
        [alert runModal];
        
        [[self documentView] setCurrentSelection:nil];
    } else {
        if (wrappedAround) {
            NSString *wrapNotification = [NSString stringWithFormat:@"Reached the %@ of the document.", [self searchBackwards] ? @"beginning" : @"end"];
            NSAlert *alert = [NSAlert alertWithMessageText:wrapNotification
                                             defaultButton:nil
                                           alternateButton:nil
                                               otherButton:nil
                                 informativeTextWithFormat:@""];
            
            [alert runModal];
        }
        
        // Highlight and move to the new selection
        [[self documentView] setCurrentSelection:currentSearchSelection];
        [[self documentView] scrollSelectionToVisible:nil];
    }
}


@end
