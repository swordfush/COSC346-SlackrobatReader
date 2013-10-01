//
//  LibraryCollectionViewController.m
//  SlackrobatReader
//
//  Created by Maddy Mills on 1/10/13.
//  Copyright (c) 2013 Stuart Johnston. All rights reserved.
//

#import "LibraryCollectionViewController.h"

#import "DocumentModel.h"
#import "LibraryItemViewController.h"

@implementation LibraryCollectionViewController


// Override the creation of collection view items so that we can tell them about the document they represent
- (NSCollectionViewItem *)newItemForRepresentedObject:(id)object {
    // Super class creates an instance of LibraryItemViewController
    LibraryItemViewController *newItem = (LibraryItemViewController *)[super newItemForRepresentedObject:object];
    
    // We then tell the collection view item what path it is representing
    DocumentModel *model = (DocumentModel *)object;
    [newItem setItemPath:[[model documentURL] path]];
    
    return newItem;
}

@end
