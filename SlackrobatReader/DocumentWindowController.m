//
//  DocumentWindowController.m
//  SlackrobatReader
//
//  Created by Stuart Johnston on 9/26/13.
//  Copyright (c) 2013 Stuart Johnston. All rights reserved.
//

#import "DocumentWindowController.h"

#import "PageNumberFormatter.h"

#import "AppDelegate.h"


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
    
    // Set default display mode
    [[self documentView] setDisplayMode:kPDFDisplaySinglePageContinuous];
    
    [[self documentView] setAutoScales:YES];
    
    // Hide thumbnail view
    [[self splitView] setPosition:0 ofDividerAtIndex:0];
}

- (void)windowDidBecomeKey:(NSNotification *)notification {
    // Cheap way to reset the check boxes
    [self setCaseInsensitiveSearch:[self caseInsensitiveSearch]];
    [self setSearchLiteral:[self searchLiteral]];
    [self setSearchBackwards:[self searchBackwards]];
}


- (void)keyDown:(NSEvent *)theEvent
{
    NSString *chars = [theEvent charactersIgnoringModifiers];
    
    if ([chars length] > 0) {
        unichar code = [chars characterAtIndex:0];
        
        switch (code)
        {
            case NSLeftArrowFunctionKey:
            {
                [self previousPage:nil];
                break;
            }
            case NSRightArrowFunctionKey:
            {
                [self nextPage:nil];
                break;
            }
        }
    }
}


// Hide the toolbar when entering fullscreen
- (NSApplicationPresentationOptions)window:(NSWindow *)window willUseFullScreenPresentationOptions:(NSApplicationPresentationOptions)proposedOptions {
    return NSApplicationPresentationAutoHideToolbar | proposedOptions;
}

- (void)windowWillEnterFullScreen:(NSNotification *)notification {
    isFullScreen = YES;
    
    BOOL isCollapsed = [[self splitView] isSubviewCollapsed:[[[self splitView] subviews] objectAtIndex:0]];
    if (!isCollapsed) {
        // Hide the thumbnail view
        [[self splitView] setPosition:0 ofDividerAtIndex:0];
    }
}

- (void)windowDidEnterFullScreen:(NSNotification *)notification {
    [self zoomToFitVertically:self];
}

- (void)windowWillExitFullScreen:(NSNotification *)notification {
    isFullScreen = NO;
    [[self splitView] setPosition:1 ofDividerAtIndex:0];
}

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview
{
    // Allow the left subview to be collapsed
    return subview == [[splitView subviews] objectAtIndex:0];
}

- (BOOL)splitView:(NSSplitView *)splitView shouldHideDividerAtIndex:(NSInteger)dividerIndex
{
    return dividerIndex == 0 && isFullScreen;
}


// Called when the page being displayed changes, unfortunately it cannot be key-value observed
- (void)pageChanged:(NSNotification *)notification {
    PDFPage *newPage = [[self documentView] currentPage];
    NSUInteger pageIndex = [[[self documentView] document] indexForPage:newPage];
    [self setCurrentPageNumber:pageIndex + 1];
}

- (IBAction)nextPage:(id)sender {
    [[self documentView] goToNextPage:nil];
    [[navigationUndoManager prepareWithInvocationTarget: self] previousPage:sender];
}

- (IBAction)previousPage:(id)sender {
    [[self documentView] goToPreviousPage:nil];
    [[navigationUndoManager prepareWithInvocationTarget: self] nextPage:sender];
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
        [self nextPage:sender];
    }
}

- (IBAction)navigateBackward:(id)sender {
    if ([navigationUndoManager canUndo]) {
        [navigationUndoManager undo];
    } else {
        [self previousPage:sender];
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


- (IBAction)zoomIn:(id)sender {
    [[self documentView] zoomIn:sender];
}

- (IBAction)zoomOut:(id)sender {
    [[self documentView] zoomOut:sender];
}

- (IBAction)zoomToFit:(id)sender {
    // This forces a fit, and is better than manually doing it
    [[self documentView] setAutoScales:YES];
//    CGFloat viewWidth = [[self documentView] frame].size.width;
//    CGFloat docWidth = [[[self documentView] currentPage] boundsForBox:kPDFDisplayBoxMediaBox].size.width;
//    [[self documentView] setScaleFactor:viewWidth / docWidth];
}

- (IBAction)zoomToFitVertically:(id)sender {
    CGFloat viewHeight = [[self documentView] frame].size.height;
    CGFloat docHeight = [[[self documentView] currentPage] boundsForBox:kPDFDisplayBoxMediaBox].size.height;
    [[self documentView] setScaleFactor:viewHeight / docHeight];
}


- (IBAction)displaySinglePage:(id)sender {
    [[self documentView] setDisplayMode:kPDFDisplaySinglePage];
}

- (IBAction)displaySinglePageContinuous:(id)sender {
    [[self documentView] setDisplayMode:kPDFDisplaySinglePageContinuous];
}

- (IBAction)displayTwoPage:(id)sender {
    [[self documentView] setDisplayMode:kPDFDisplayTwoUp];
}

- (IBAction)displayTwoPageContinuous:(id)sender {
    [[self documentView] setDisplayMode:kPDFDisplayTwoUpContinuous];
}


- (IBAction)toggleSearchBackwards:(id)sender {
    [self setSearchBackwards:![self searchBackwards]];
}

- (IBAction)toggleIgnoreCase:(id)sender {
    [self setCaseInsensitiveSearch:![self caseInsensitiveSearch]];
}

- (IBAction)toggleSearchLiteral:(id)sender {
    [self setSearchLiteral:![self searchLiteral]];
}

- (BOOL)searchBackwards {
    return _searchBackwards;
}

- (void)setSearchBackwards:(BOOL)searchBackwards {
    _searchBackwards = searchBackwards;
    NSInteger state = searchBackwards ? NSOnState : NSOffState;
    [[(AppDelegate *)[NSApp delegate] searchBackwardsMenuItem] setState:state];;
}

- (BOOL)searchLiteral {
    return _searchLiteral;
}

- (void)setSearchLiteral:(BOOL)searchLiteral {
    _searchLiteral = searchLiteral;
    NSInteger state = searchLiteral ? NSOnState : NSOffState;
    [[(AppDelegate *)[NSApp delegate] matchLiteralMenuItem] setState:state];;
}

- (BOOL)caseInsensitiveSearch {
    return _caseInsensitiveSearch;
}

- (void)setCaseInsensitiveSearch:(BOOL)caseInsensitiveSearch {
    _caseInsensitiveSearch = caseInsensitiveSearch;
    NSInteger state = caseInsensitiveSearch ? NSOnState : NSOffState;
    [[(AppDelegate *)[NSApp delegate] matchCaseMenuItem] setState:state];;
}


- (IBAction)search:(id)sender {
    NSTextField *searchBox = sender;
    NSString *searchString = [searchBox stringValue];
    
    // If the search string is empty then clear the current search
    if ([searchString length] == 0) {
        [[self documentView] setCurrentSelection:nil];
        return;
    }

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
