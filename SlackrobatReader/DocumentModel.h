//
//  LibraryItemModel.h
//  SlackrobatReader
//
//  Created by Stuart Johnston on 9/26/13.
//  Copyright (c) 2013 Stuart Johnston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

@interface DocumentModel : NSObject

- (id)initWithPDFAtURL:(NSURL *)url;

@property (readonly) NSURL *documentURL;
@property (readonly) NSString *documentFileName;
@property PDFDocument *document;

@end
