//
//  AppDelegate.h
//  SlackrobatReader
//
//  Created by Stuart Johnston on 9/26/13.
//  Copyright (c) 2013 Stuart Johnston. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSUndoManager *libraryUndoManager;
}

@property (assign) IBOutlet NSWindow *window;

@property NSMutableArray *libraryItems;
@property NSMutableArray *openDocumentWindows;

- (IBAction)addItem:(id)sender;
- (IBAction)removeItem:(id)sender;

@property (weak) IBOutlet NSCollectionView *libraryItemsView;
@property (weak) IBOutlet NSButton *removeItemButton;
@property (weak) IBOutlet NSMenuItem *removeItemMenuItem;

@property (weak) IBOutlet NSMenuItem *searchBackwardsMenuItem;
@property (weak) IBOutlet NSMenuItem *matchCaseMenuItem;
@property (weak) IBOutlet NSMenuItem *matchLiteralMenuItem;

@property (weak) IBOutlet NSMenuItem *singlePageMenuItem;
@property (weak) IBOutlet NSMenuItem *singlePageContinuousMenuItem;
@property (weak) IBOutlet NSMenuItem *twoPageMenuItem;
@property (weak) IBOutlet NSMenuItem *twoPageContinuousMenuItem;

@end
