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
}

- (id)initWithDocument:(DocumentModel *)document;

@property DocumentModel *documentModel;

@property (weak) IBOutlet PDFView *documentView;
@property (weak) IBOutlet PDFThumbnailView *documentThumbnailView;

@property NSUInteger currentPageNumber;


@property BOOL searchBackwards;
@property BOOL caseInsensitiveSearch;
@property BOOL searchLiteral;

@property BOOL canZoomIn;
@property BOOL canZoomOut;
@property BOOL canZoomToFit;


- (IBAction)navigateForward:(id)sender;
- (IBAction)navigateBackward:(id)sender;
- (IBAction)navigateGoTo:(id)sender;

- (IBAction)search:(id)sender;

@end
