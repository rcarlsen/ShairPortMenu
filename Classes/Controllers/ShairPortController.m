//
//  ShairPortController.m
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

#import "ShairPortController.h"
#import "ShairPortMenuAppDelegate.h"
#import "ShairPortModel.h"

@implementation ShairPortController

@synthesize shairportTask, delegate;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        shairportModel = [(ShairPortMenuAppDelegate*)[NSApp delegate] shairportModel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(incomingData:)
                                                     name:NSFileHandleDataAvailableNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(processStopped:)
                                                     name:NSTaskDidTerminateNotification object:nil];
        
    }
    
    return self;
}

- (void)dealloc
{
    delegate = nil;
    
    [super dealloc];
}



-(void)setServerRunning:(BOOL)state;
{
    if(state) {
        if (shairportTask == nil) {
            shairportTask = [[NSTask alloc] init];
            
            NSBundle *bundle = [NSBundle mainBundle];
            NSString *shairportPath;
            shairportPath = [bundle pathForResource:@"shairport" ofType:@"pl"];
            
            if (shairportPath == nil) {
                NSLog(@"shairport.pl not found. bailing out.");
                [shairportTask release]; shairportTask = nil;
                return;
            }
            
            [shairportTask setLaunchPath: shairportPath];
            
            // TODO: look for other instances, then kill them?
            // ps axwww|grep -v grep |grep shairport.pl
            
            // add args for hostname {optionally, password}
            NSMutableArray *args = [NSMutableArray arrayWithCapacity:4];
            NSString *name = shairportModel.serverName;
            // if (name == nil || [name isEqualToString:@""]) {
            //     name = [[NSProcessInfo processInfo] hostName];
            // }
            if (name != nil && ![name isEqualToString:@""]) {
                [args addObject:@"--apname"];
                [args addObject:name];
            }

            if (shairportModel.usePassword) {
                [args addObject:@"--password"];
                [args addObject:shairportModel.serverPassword];
            }
            
            [shairportTask setArguments:args];
            NSLog(@"command: %@",[[shairportTask arguments] description]);
            
            NSPipe *shairportPipe = [NSPipe pipe];
            readFile = [shairportPipe fileHandleForReading];
            [readFile waitForDataInBackgroundAndNotify];
            
            [shairportTask setStandardOutput:shairportPipe];
            [shairportTask launch];
            
            // fire off a message so the app delegate can update the menu
            if ([delegate respondsToSelector:@selector(shairPortStarted)]) {
                [delegate shairPortStarted];
            }
        }
    }
    else {
        [shairportTask terminate];
        [shairportTask release]; shairportTask = nil;
    }
}

#pragma mark - Notification handlers
-(void)incomingData:(NSNotification*)notification
{
    // TODO: parse the console messages
    // look for pertinent messages...namely connection events and status updates.
    // can we get song information from the stream?
    
    NSData *incomingData = readFile.availableData;
    NSString *logString = [[NSString alloc] initWithData:incomingData encoding:NSUTF8StringEncoding];
    NSLog(@"log: %@",logString);
    
    
    // look for messages:
    // REQ: TEARDOWN
    // ***CHILD EXITED*** disconnection event
    // new connection from fe80::e2f8:47ff:fe08:f2aa    
    
    [logString release];
}

-(void)processStopped:(NSNotification*)notification;
{
    NSLog(@"the task terminated");
    [shairportTask release]; shairportTask = nil;
    
    // tell the app delegate to update the UI
    if ([delegate respondsToSelector:@selector(shairPortStopped)]) {
        [delegate shairPortStopped];
    }
}


@end
