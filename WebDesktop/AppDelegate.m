//
//  AppDelegate.m
//  WebDesktop
//
//  Created by Main on 1/23/19.
//  Copyright © 2019 Ravbug. All rights reserved.
//

#import "AppDelegate.h"
#import <WebKit/WebKit.h>

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet WKWebView* webkitview;
//used to get the current directory
@property NSFileManager* fileManager;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSDictionary *dict = [[NSDictionary alloc]
                          initWithObjectsAndKeys:
                          @"https://discordapp.com/channels/@me",@"url",
                          [NSNumber numberWithDouble:640],@"width",[NSNumber numberWithDouble:480],@"height",nil];
    
    _fileManager = [NSFileManager new];
    
    [self spawnAppWithData:dict];
    
    NSLog(@"%@", [_fileManager currentDirectoryPath]);
}

/**
 Spawns the app with settings
 @paran data Dictionary with the settings for the instance
 */
- (void)spawnAppWithData:(NSDictionary *)data {
    //get the URL and load it
    NSString* url = [data objectForKey:@"url"];
    
    //laod the error page if the url is not present
    if (url == nil){
        url = @"file:///errorpage.html";
    }
    _webkitview.customUserAgent = @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0.2 Safari/605.1.15";
    [_webkitview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    //set the window size
    [_window setContentSize:NSMakeSize([[data objectForKey:@"width"] doubleValue], [[data objectForKey:@"height"] doubleValue])];
    
    //set the window title
    _window.title = _webkitview.title;
}

//navigation menus hit -- move the navigation backward and forward
- (IBAction)BackHit:(id)sender{
    [_webkitview goBack];
}
- (IBAction)ForwardHit:(id)sender{
    [_webkitview goForward];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
