//
//  AppDelegate.m
//  SlackrobatReader
//
//  Created by Stuart Johnston on 9/26/13.
//  Copyright (c) 2013 Stuart Johnston. All rights reserved.
//

#import "AppDelegate.h"

#import "LibraryItemModel.h"

@implementation AppDelegate

@synthesize libraryItems;
@synthesize openDocumentWindows;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    openDocumentWindows = [[NSMutableArray alloc] init];
}

- (void)awakeFromNib {
    LibraryItemModel *model = [[LibraryItemModel alloc] initWithPDFAtPath:@"test"];
    
    [self setLibraryItems:[NSMutableArray arrayWithObjects:model, nil]];
}

- (void)insertObject:(LibraryItemModel *)object inLibraryItemsAtIndex:(NSUInteger)index {
    [libraryItems insertObject:object atIndex:index];
}

- (void)removeObjectFromLibraryItemsAtIndex:(NSUInteger)index {
    [libraryItems removeObjectAtIndex:index];
}

- (void)setLibraryItems:(NSMutableArray *)x {
    libraryItems = x;
}

- (NSArray *)libraryItems {
    return libraryItems;
}




- (void)openDocument:(NSString *)documentFilePath {
    // TODO
}


- (IBAction)addItem:(id)sender {
    NSOpenPanel * fileDialog = [NSOpenPanel openPanel];
    [fileDialog setAllowsMultipleSelection:NO];
    [fileDialog setCanChooseDirectories:NO];
    [fileDialog setCanChooseFiles:YES];
    [fileDialog setFloatingPanel:YES]; // Test this
    [fileDialog setAllowedFileTypes:[NSArray arrayWithObjects:@"pdf", nil]];
    
    [fileDialog beginWithCompletionHandler:^(NSInteger result){
        NSString *filePath = [fileDialog URLs][0];
        LibraryItemModel *model = [[LibraryItemModel alloc] initWithPDFAtPath:filePath];
        [self insertObject:model inLibraryItemsAtIndex:[libraryItems count]];
    }];
}

- (IBAction)removeItem:(id)sender {
    for (LibraryItemModel *model in libraryItems) {
        NSLog(@"%@", [model documentFilePath]);
    }
    NSLog(@"%li", (unsigned long)[libraryItems count]);
}

@end
