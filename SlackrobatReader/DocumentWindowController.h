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

@interface DocumentWindowController : NSWindowController {
    NSUndoManager *navigationUndoManager;
    
    BOOL _continuousDisplay;
}

- (id)initWithDocument:(DocumentModel *)document;

@property DocumentModel *documentModel;

@property (weak) IBOutlet PDFView *documentView;
@property (weak) IBOutlet PDFThumbnailView *documentThumbnailView;

@property (strong) IBOutlet NSMenu *mainMenu;


@property NSUInteger currentPageNumber;

// Navigation
- (IBAction)navigateForward:(id)sender;
- (IBAction)navigateBackward:(id)sender;
- (IBAction)navigateGoTo:(id)sender;

// Zooming
- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;
- (IBAction)zoomToFit:(id)sender;

// Display Mode
@property BOOL continuousDisplay;
@property BOOL displaySinglePage;

- (IBAction)displayModeChanged:(id)sender;

// Searching
@property BOOL searchBackwards;
@property BOOL caseInsensitiveSearch;
@property BOOL searchLiteral;

- (IBAction)search:(id)sender;


@end
