//
//  ShairPortModel.m
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

#import "ShairPortModel.h"


@implementation ShairPortModel

@synthesize serverName, serverPassword, usePassword;

-(id)init;
{
    self = [super init];
    if(self) {
        // set up the defaults:
        // cleartext passwd:
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"]]];
        
        // init the model
        // TODO: use coding to directly archive the model
        self.serverName = [defaults stringForKey:@"SPServerName"];
        self.serverPassword = [defaults stringForKey:@"SPServerPassword"];
        self.usePassword = [defaults boolForKey:@"SPUsePassword"];
    }
    return self;
}

-(void)dealloc;
{
    [serverName release];
    [serverPassword release];
    
    [super dealloc];
}

@end