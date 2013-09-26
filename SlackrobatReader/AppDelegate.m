//
//  AppDelegate.m
//  SlackrobatReader
//
//  Created by Stuart Johnston on 9/26/13.
//  Copyright (c) 2013 Stuart Johnston. All rights reserved.
//

#import "AppDelegate.h"

#import "LibraryItemModel.h"
#import "DocumentWindowController.h"

@implementation AppDelegate

@synthesize libraryItems;
@synthesize openDocumentWindows;

NSString * const LibraryItemsKey = @"LibraryItems";

+ (void)initialize {
    // Use preferences to store our library items
    NSData *emptyArrayData = [NSKeyedArchiver archivedDataWithRootObject:[[NSMutableArray alloc] init]];
    NSDictionary *defaultValues = [[NSDictionary alloc] initWithObjectsAndKeys:emptyArrayData, LibraryItemsKey, nil];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    openDocumentWindows = [[NSMutableArray alloc] init];
}

- (void)awakeFromNib {
    // Load stored preferences
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *loadedItemURLs = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:LibraryItemsKey]];
    
    NSMutableArray *loadedItems = [[NSMutableArray alloc] init];
    
    for (NSString *url in loadedItemURLs) {
        [loadedItems addObject:[[LibraryItemModel alloc] initWithPDFAtURL:[NSURL URLWithString:url]]];
    }
    
    [self setLibraryItems:loadedItems];
    
    // Subscribe to the selection index so we can disable the remove button when needed
    [[self libraryItemsView] addObserver:self forKeyPath:@"selectionIndexes" options:NSKeyValueObservingOptionNew context:nil];
}


- (void)updateUserPreferences {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *urls = [[NSMutableArray alloc] init];
    
    for (LibraryItemModel *item in libraryItems) {
        [urls addObject:[[item documentURL] absoluteString]];
    }
    
    NSData *itemsData = [NSKeyedArchiver archivedDataWithRootObject:urls];
    [defaults setObject:itemsData forKey:LibraryItemsKey];
    
}

- (void)insertObject:(LibraryItemModel *)object inLibraryItemsAtIndex:(NSUInteger)index {
    [libraryItems insertObject:object atIndex:index];
    [self updateUserPreferences];
}

- (void)removeObjectFromLibraryItemsAtIndex:(NSUInteger)index {
    [libraryItems removeObjectAtIndex:index];
    [self updateUserPreferences];
}

- (void)setLibraryItems:(NSMutableArray *)x {
    libraryItems = x;
    [self updateUserPreferences];
}

- (NSArray *)libraryItems {
    return libraryItems;
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath compare:@"selectionIndexes"] == NSOrderedSame) {
        NSIndexSet *indices = change[@"new"];
        
        [[self removeItemButton] setEnabled:[indices count] > 0];
    }
}

- (void)collectionItemViewDoubleClick {
    NSUInteger index = [[[self libraryItemsView] selectionIndexes] firstIndex];
    LibraryItemModel *itemModel = libraryItems[index];
    [self openDocument:itemModel];
}



- (void)openDocument:(LibraryItemModel *)documentModel {
    DocumentWindowController *documentWindow = [[DocumentWindowController alloc] initWithDocument:documentModel];
    [openDocumentWindows addObject:documentWindow];
    [documentWindow showWindow:self];
}


- (IBAction)addItem:(id)sender {
    NSOpenPanel * fileDialog = [NSOpenPanel openPanel];
    [fileDialog setAllowsMultipleSelection:NO];
    [fileDialog setCanChooseDirectories:NO];
    [fileDialog setCanChooseFiles:YES];
    [fileDialog setFloatingPanel:YES]; // Test this
    [fileDialog setAllowedFileTypes:[NSArray arrayWithObjects:@"pdf", nil]];
    
    [fileDialog beginWithCompletionHandler:^(NSInteger result){
        NSURL *url = [fileDialog URLs][0];
        LibraryItemModel *model = [[LibraryItemModel alloc] initWithPDFAtURL:url];
        [self insertObject:model inLibraryItemsAtIndex:[libraryItems count]];
    }];
}

- (IBAction)removeItem:(id)sender {
    // Find the index selected and remove it
    NSIndexSet *indices = [self.libraryItemsView selectionIndexes];
    if ([indices count] > 0) {
        [self removeObjectFromLibraryItemsAtIndex:[indices firstIndex]];
    }
}

@end
