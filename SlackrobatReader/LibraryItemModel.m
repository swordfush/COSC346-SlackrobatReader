//
//  LibraryItemModel.m
//  SlackrobatReader
//
//  Created by Stuart Johnston on 9/26/13.
//  Copyright (c) 2013 Stuart Johnston. All rights reserved.
//

#import "LibraryItemModel.h"

@implementation LibraryItemModel

@synthesize documentFilePath;
@synthesize documentFileName;

- (id)initWithPDFAtPath:(NSString *)filePath {
    self = [super init];
    if (self) {
        documentFilePath = filePath;
        self->documentFileName = [[documentFilePath lastPathComponent] stringByDeletingPathExtension];
    }
    return self;
}



@end
