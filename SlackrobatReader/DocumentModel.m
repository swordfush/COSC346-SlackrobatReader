//
//  LibraryItemModel.m
//  SlackrobatReader
//
//  Created by Stuart Johnston on 9/26/13.
//  Copyright (c) 2013 Stuart Johnston. All rights reserved.
//

#import "DocumentModel.h"

@implementation DocumentModel

@synthesize documentURL;
@synthesize documentFileName;
@synthesize document;

- (id)initWithPDFAtURL:(NSURL *)url {
    // Ensure the path exists
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path] isDirectory:NO]) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        documentURL = url;
        self->documentFileName = [[url lastPathComponent] stringByDeletingPathExtension];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[documentURL path]]) {
            document = [[PDFDocument alloc] initWithURL:url];
        }
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[DocumentModel class]]) {
        DocumentModel *other = object;
        return [[self documentURL] isEqual:[other documentURL]];
    } else {
        // Object's type is unkown
        return NO;
    }
}



@end
