//
//  ShairPortMenuAppDelegate.m
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

#import "ShairPortMenuAppDelegate.h"

#import "ShairPortModel.h"
#import "ShairPortController.h"

#import "ShairPreferencesController.h"
#import "AboutPanelController.h"


@interface ShairPortMenuAppDelegate (private)
-(void)updateMenuForServer:(BOOL)isOn;
-(void)setTooltipStatus:(BOOL)_onOff;
@end


@implementation ShairPortMenuAppDelegate

@synthesize window, shairportModel;


#pragma mark - Application Delegate
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {    
    // set up the app data model
    self.shairportModel = [[ShairPortModel alloc] init];
    shairPortController = [[ShairPortController alloc] init];
    [shairPortController setDelegate:self];
}

-(void)applicationWillTerminate:(NSNotification *)notification
{
    [shairPortController setServerRunning:NO];
    
    [shairPortController release];
    [shairportModel release];

}

-(void)awakeFromNib{
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    [statusItem sendActionOn:NSLeftMouseDraggedMask];
    [statusItem setMenu:statusMenu];

    // use the more modern version which will handle dark menu bar mode with image templates
    if ([statusItem respondsToSelector:NSSelectorFromString(@"button")]) {
        NSImage *buttonImage = [NSImage imageNamed:@"hairplay-on"];
        buttonImage.template = YES;
        statusItem.button.image = buttonImage;
    }
    else {
        // these are deprecated...
        [statusItem setHighlightMode:YES];
        [statusItem setAlternateImage:[NSImage imageNamed:@"hairplay-over"]];
    }

    [self updateMenuForServer:[shairPortController shairportTask].isRunning];
}


#pragma mark - Private methods
-(void)updateMenuForServer:(BOOL)isOn;
{
    [self setTooltipStatus:isOn];
    
    if(isOn){
        if ([statusItem respondsToSelector:NSSelectorFromString(@"button")]) {
            statusItem.button.appearsDisabled = NO;
        }
        else {
            [statusItem setImage:[NSImage imageNamed:@"hairplay-on"]];
        }
        
        [controlMenuItem setTitle:NSLocalizedString(@"Turn ShairPort off", "Menu item title")];
        [controlMenuItem setState:1];
        
        NSString *displayName = ([shairportModel.serverName isEqualToString:@""]) ? 
         NSLocalizedString(@"Default Name","Server default display name") :
         shairportModel.serverName;
        
        [statusMenuItem setTitle:[NSString stringWithFormat:
                                  NSLocalizedString(@"ShairPort: %@", "Menu item title"),
                                  displayName]];
    }
    else {
        [self setTooltipStatus:isOn];
        if ([statusItem respondsToSelector:NSSelectorFromString(@"button")]) {
            statusItem.button.appearsDisabled = YES;
        }
        else {
            [statusItem setImage:[NSImage imageNamed:@"hairplay-off"]];
        }

        [controlMenuItem setTitle:NSLocalizedString(@"Turn ShairPort on", "Menu item title")];
        [controlMenuItem setState:0];
        [statusMenuItem setTitle:NSLocalizedString(@"ShairPort: off", "Menu item title")];        
    }
}



-(void)setTooltipStatus:(BOOL)_onOff;
{
    NSString *tooltipTitle = NSLocalizedString(@"ShairPort Control", "Menulet tool tip title");
    NSString *tooltipStatus = [NSString stringWithFormat:
                               NSLocalizedString(@"HairTunes is %@", "tooltip status"),
                               (_onOff) ? @"on" : @"off" ];
    [statusItem setToolTip:[NSString stringWithFormat:@"%@\n%@",tooltipTitle,tooltipStatus]];
}


#pragma mark - Actions
-(IBAction)listeningMenu:(id)sender;
{
    NSLog(@"Menu option: %ld",[sender state]);
    switch ([sender state]) {
        case 0:
            [shairPortController setServerRunning:YES];
            break;
        case 1:
            [shairPortController setServerRunning:NO];
            break;
        case 2:
            break;
        default:
            break;
    }
}

-(IBAction)openAboutPanel:(id)sender;
{	
    NSLog(@"open about panel");
        
    if (aboutPanel == nil) {
        aboutPanel = [[AboutPanelController alloc] initWithWindowNibName:@"AboutPanel"];
    }

    [aboutPanel showWindow:nil];    
    [NSApp activateIgnoringOtherApps:YES];
}

-(IBAction)openPreferencesWindow:(id)sender;
{
    NSLog(@"open prefs window");
    
    if (preferencesWindow == nil) {
        preferencesWindow = [[ShairPreferencesController alloc] initWithWindowNibName:@"ShairPreferencesWindow"];
    }
    
    [preferencesWindow showWindow:nil];
    [NSApp activateIgnoringOtherApps:YES];
}


#pragma mark - ShairPortController delegate
-(void)shairPortStarted;
{
    [self updateMenuForServer:YES];
}

-(void)shairPortStopped;
{
    [self updateMenuForServer:NO];
}


@end
