//
//  LibraryItemViewController.m
//  SlackrobatReader
//
//  Created by Stuart Johnston on 9/26/13.
//  Copyright (c) 2013 Stuart Johnston. All rights reserved.
//

#import "LibraryItemViewController.h"

#import "LibraryItemView.h"

@interface LibraryItemViewController ()

@end

@implementation LibraryItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)setSelected:(BOOL)flag
{
    [super setSelected:flag];
    [(LibraryItemView *)[self view] setSelected:flag];
    [(LibraryItemView *)[self view] setNeedsDisplay:YES];
}

@end
