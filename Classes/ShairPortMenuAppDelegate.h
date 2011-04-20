//
//  ShairPortMenuAppDelegate.h
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



#import <Cocoa/Cocoa.h>

#import "ShairPortController.h"
@class ShairPortModel;


@interface ShairPortMenuAppDelegate : NSObject 
<NSApplicationDelegate, ShairPortControllerDelegate>
{
    NSWindow        *window;
    
    NSStatusItem    *statusItem;
    IBOutlet NSMenu *statusMenu;
    IBOutlet NSMenuItem *controlMenuItem;
    IBOutlet NSMenuItem *statusMenuItem;
    
    id aboutPanel;
    id preferencesWindow;
    
    id shairPortController;
    ShairPortModel *shairportModel;
}

@property (assign) IBOutlet NSWindow *window;
@property(nonatomic,retain)ShairPortModel *shairportModel;

-(IBAction)listeningMenu:(id)sender;
-(IBAction)openAboutPanel:(id)sender;
-(IBAction)openPreferencesWindow:(id)sender;

@end
