//
//  DocumentWindowController.h
//  SlackrobatReader
//
//  Created by Stuart Johnston on 9/26/13.
//  Copyright (c) 2013 Stuart Johnston. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

#import "DocumentModel.h"

@interface DocumentWindowController : NSWindowController <NSWindowDelegate, NSSplitViewDelegate> {
    NSUndoManager *navigationUndoManager;
    
    BOOL isFullScreen;
}

- (id)initWithDocument:(DocumentModel *)document;

@property DocumentModel *documentModel;

@property (weak) IBOutlet PDFView *documentView;
@property (weak) IBOutlet PDFThumbnailView *documentThumbnailView;
@property (weak) IBOutlet NSSplitView *splitView;

@property (strong) IBOutlet NSMenu *mainMenu;


@property NSUInteger currentPageNumber;

// Navigation
- (IBAction)navigateForward:(id)sender;
- (IBAction)navigateBackward:(id)sender;
- (IBAction)navigateGoTo:(id)sender;
- (IBAction)nextPage:(id)sender;
- (IBAction)previousPage:(id)sender;

// Zooming
- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;
- (IBAction)zoomToFit:(id)sender;
- (IBAction)zoomToFitVertically:(id)sender;

// Display Mode
- (IBAction)displaySinglePage:(id)sender;
- (IBAction)displaySinglePageContinuous:(id)sender;
- (IBAction)displayTwoPage:(id)sender;
- (IBAction)displayTwoPageContinuous:(id)sender;

// Searching
@property BOOL searchBackwards;
@property BOOL caseInsensitiveSearch;
@property BOOL searchLiteral;

- (IBAction)search:(id)sender;


@end
