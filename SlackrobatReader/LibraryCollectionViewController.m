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


- (NSCollectionViewItem *)newItemForRepresentedObject:(id)object {
    // Super class creates an instance of LibraryItemViewController
    LibraryItemViewController *newItem = (LibraryItemViewController *)[super newItemForRepresentedObject:object];
    
    DocumentModel *model = (DocumentModel *)object;
    [newItem setItemPath:[[model documentURL] path]];
    
    return newItem;
}

@end
