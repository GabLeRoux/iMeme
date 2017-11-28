//
//  TableViewController.m
//  iMeme
//
//  Created by Michael Fogleman on 11/24/11.
//  Copyright (c) 2011 n/a. All rights reserved.
//

#import "TableViewController.h"
#import "Template.h"

@implementation TableViewController

@synthesize searchField;
@synthesize appDelegate;
@synthesize tableView;

- (id)init {
    self = [super init];
    if (self) {
        allItems = [[NSMutableArray alloc] init];
        NSArray* paths = [[NSBundle mainBundle] pathsForResourcesOfType:@"jpg" inDirectory:nil];
        for (NSString* filename in paths) {
            NSString* path = [[filename lastPathComponent] stringByDeletingPathExtension];
            NSString* name = [path stringByReplacingOccurrencesOfString:@"-" withString:@" "];
            path = [[NSBundle mainBundle] pathForImageResource:path];
            [allItems addObject:[[Template alloc] initWithName:name path:path]];
            filteredItems = allItems.copy;
        }
    }
    return self;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [filteredItems count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    Template* template = [filteredItems objectAtIndex:row];
    NSString* identifier = [tableColumn identifier];
    return [template valueForKey:identifier];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSInteger row = [tableView selectedRow];
    if (row >= 0) {
        Template* template = [filteredItems objectAtIndex:row];
        [appDelegate setPath:[template path]];
    }
}

- (IBAction)updateFilter:(id)sender {
    NSString *filter = [self.searchField stringValue];
    if (filter.length > 0) {
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"self.name CONTAINS[cd] %@", filter];
        filteredItems = [[allItems filteredArrayUsingPredicate:filterPredicate] mutableCopy];
    } else {
        filteredItems = allItems.copy;
    }
    [self.tableView reloadData];
}

@end
