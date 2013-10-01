//
//  AppDelegate.m
//  SlackrobatReader
//
//  Created by Stuart Johnston on 9/26/13.
//  Copyright (c) 2013 Stuart Johnston. All rights reserved.
//

#import "AppDelegate.h"

#import "DocumentModel.h"
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
        DocumentModel *model = [[DocumentModel alloc] initWithPDFAtURL:[NSURL URLWithString:url]];
        if (model) {
            [loadedItems addObject:model];
        } else {
            NSAlert *alert = [NSAlert alertWithMessageText:[NSString stringWithFormat:@"Failed to load the file %@", url] defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
            [alert runModal];
        }
    }
    
    [self setLibraryItems:loadedItems];
    
    // Subscribe to the selection index so we can disable the remove button when needed
    [[self libraryItemsView] addObserver:self forKeyPath:@"selectionIndexes" options:NSKeyValueObservingOptionNew context:nil];
}


// Saves modifications of the user preferences XXX it's currently being used quite often; maybe only perform this on exit?
- (void)updateUserPreferences {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *urls = [[NSMutableArray alloc] init];
    
    for (DocumentModel *item in libraryItems) {
        [urls addObject:[[item documentURL] absoluteString]];
    }
    
    NSData *itemsData = [NSKeyedArchiver archivedDataWithRootObject:urls];
    [defaults setObject:itemsData forKey:LibraryItemsKey];
    
}

- (void)insertObject:(DocumentModel *)object inLibraryItemsAtIndex:(NSUInteger)index {
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


- (BOOL) validateMenuItem:(NSMenuItem *)menuItem {
    if (menuItem == [self removeItemMenuItem]) {
        // Only enable the remove menu item when we have a selection
        return [[[self libraryItemsView] selectionIndexes] count] > 0;
    }
    
    return YES;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath compare:@"selectionIndexes"] == NSOrderedSame) {
        // Enable/disable remove library item button
        NSIndexSet *indices = change[@"new"];
        
        BOOL removeEnabled = [indices count] > 0;
        [[self removeItemButton] setEnabled:removeEnabled];
    }
}

- (void)collectionItemViewDoubleClick {
    // Open a new document
    NSUInteger index = [[[self libraryItemsView] selectionIndexes] firstIndex];
    DocumentModel *itemModel = libraryItems[index];
    [self openDocument:itemModel];
}


- (void)openDocument:(DocumentModel *)documentModel {
    // Check to see if we have another window open with the document model the user is trying to open
    for (DocumentWindowController *window in [self openDocumentWindows]) {
        if ([[window documentModel] isEqual:documentModel]) {
            [[window window] makeKeyAndOrderFront:window];
            return;
        }
    }
    
    // If the document is not open then create a window to display it in
    DocumentWindowController *documentWindow = [[DocumentWindowController alloc] initWithDocument:documentModel];
    [openDocumentWindows addObject:documentWindow];
    [documentWindow showWindow:self];
}


// Adds a pdf document to the library
- (IBAction)addItem:(id)sender {
    NSOpenPanel * fileDialog = [NSOpenPanel openPanel];
    [fileDialog setAllowsMultipleSelection:NO];
    [fileDialog setCanChooseDirectories:NO];
    [fileDialog setCanChooseFiles:YES];
    [fileDialog setFloatingPanel:YES];
    [fileDialog setAllowedFileTypes:[NSArray arrayWithObjects:@"pdf", nil]];
    
    [fileDialog beginWithCompletionHandler:^(NSInteger result){
        NSURL *url = [fileDialog URLs][0];
        DocumentModel *model = [[DocumentModel alloc] initWithPDFAtURL:url];
        
        if ([libraryItems containsObject:model]) {
            NSAlert *alert = [NSAlert alertWithMessageText:@"That document is already in the library!" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
            [alert runModal];
        } else {
            [self insertObject:model inLibraryItemsAtIndex:[libraryItems count]];
        }
    }];
}

- (IBAction)removeItem:(id)sender {
    // Find the index selected and remove it
    NSIndexSet *indices = [self.libraryItemsView selectionIndexes];
    if ([indices count] > 0) {
        [self removeObjectFromLibraryItemsAtIndex:[indices firstIndex]];
    }
    
    // Unfortunately removing an item does not cause the collection view to update its selection, so we'll deselect everything manually
    [self.libraryItemsView setSelectionIndexes:[NSIndexSet indexSet]];
}

@end
