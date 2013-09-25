//
//  LibraryItemModel.h
//  SlackrobatReader
//
//  Created by Stuart Johnston on 9/26/13.
//  Copyright (c) 2013 Stuart Johnston. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LibraryItemModel : NSObject

- (id)initWithPDFAtPath:(NSString *)filePath;

@property NSString *documentFilePath;

@end
