//
//  DocumentWindowController.h
//  SlackrobatReader
//
//  Created by Stuart Johnston on 9/26/13.
//  Copyright (c) 2013 Stuart Johnston. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

#import "LibraryItemModel.h"

@interface DocumentWindowController : NSWindowController

- (id)initWithDocument:(LibraryItemModel *)documentModel;
@property (weak) IBOutlet PDFView *documentView;
@property (weak) IBOutlet PDFThumbnailView *documentThumbnailView;

@end
