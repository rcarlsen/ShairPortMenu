//
//  ShairPreferencesController.m
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

#import "ShairPreferencesController.h"

#import "ShairPortMenuAppDelegate.h"
#import "ShairPortModel.h"

@implementation ShairPreferencesController
@synthesize model;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        model = (ShairPortModel*)[(ShairPortMenuAppDelegate*)[NSApp delegate] shairportModel];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    [serverNameField.cell setPlaceholderString:[[NSProcessInfo processInfo] hostName]];
    [serverNameField setStringValue:[model serverName]];
    
    [serverPasswordField setStringValue:[model serverPassword]];
    [serverUsePasswordButton setState:[model usePassword]];
}


-(IBAction)savePreferences:(id)sender;
{
    NSLog(@"saving prefs");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // the values for the prefs have bindings to the defaults...
    // do we have to manually read them back in?
    
    [model setServerPassword:serverPasswordField.stringValue];
    [model setServerName:serverNameField.stringValue];
    [model setUsePassword:(BOOL)serverUsePasswordButton.state];
    
    [defaults setValue:[model serverName] forKey:@"SPServerName"];
    [defaults setValue:[model serverPassword] forKey:@"SPServerPassword"];
    [defaults setValue:[NSNumber numberWithBool:[model usePassword]] forKey:@"SPUsePassword"];
    
    [defaults synchronize];
    
    [self.window performClose:nil];
    
    // have to restart the server if the values have changed.
//    if ([shairportTask isRunning]) {
//        [self setServerRunning:NO];
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {
//            sleep(1);
//            [self setServerRunning:YES];
//        });
//    }
}

@end
