//
//  AboutPanelController.m
//  This file is part of ShairPortMenu.
//
//  A Simple OS X GUI wrapper for ShairPort / HairTunes
//
//  Copyright 2011 Robert Carlsen.
//
//  ShairPortMenu is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  ShairPortMenu is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with ShairPortMenu.  If not, see <http://www.gnu.org/licenses/>.
//

#import "AboutPanelController.h"


@implementation AboutPanelController
@synthesize versionLabel;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    self.versionLabel = nil;
    
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [self.versionLabel setStringValue:[NSString stringWithFormat:
                                       NSLocalizedString(@"Version: %@","Version label"),
                                       [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]]];
    
    // set up the about text:
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *aboutTextPath = [bundle pathForResource:@"about" ofType:@"rtf"];
    [aboutTextView readRTFDFromFile:aboutTextPath];
    
    [aboutTextView setAutomaticLinkDetectionEnabled:YES];
    [aboutTextView setAutomaticDataDetectionEnabled:YES];
    
    [aboutTextView setLinkTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSCursor pointingHandCursor], NSCursorAttributeName,
                                          [NSNumber numberWithInt:NSUnderlineStyleSingle], NSUnderlineStyleAttributeName,
                                          [NSColor darkGrayColor], NSForegroundColorAttributeName,
                                          nil]];
}

@end
