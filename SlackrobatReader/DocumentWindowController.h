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

@interface DocumentWindowController : NSWindowController <NSToolbarDelegate> 

- (id)initWithDocument:(DocumentModel *)document;

@property DocumentModel *documentModel;

@property (weak) IBOutlet PDFView *documentView;
@property (weak) IBOutlet PDFThumbnailView *documentThumbnailView;
@property (weak) IBOutlet NSToolbar *toolbar;




- (IBAction)nextPage:(id)sender;
- (IBAction)previousPage:(id)sender;


@end
