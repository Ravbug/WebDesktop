//
//  AppDelegate.m
//  WebDesktop
//
//  Created by Main on 1/23/19.
//  Copyright © 2019 Ravbug. All rights reserved.
//

#import "AppDelegate.h"
#import "constants.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet WKWebView* webkitview;
@property (weak) IBOutlet NSToolbar* toolbar;
@property (weak) IBOutlet NSTextField* toolbarTitle;
@property double currentZoom;

//used to get the current directory
@property NSFileManager* fileManager;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSDictionary *dict = [[NSDictionary alloc]
                          initWithObjectsAndKeys:
                          kstart_url,@"url",
                          [NSNumber numberWithDouble:1280],@"width",[NSNumber numberWithDouble:720],@"height",nil];
    
    _fileManager = [NSFileManager new];
	
	_currentZoom = kstartmag;
    
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
	
	_webkitview.navigationDelegate = self;
	_webkitview.UIDelegate = self;
    //_webkitview.customUserAgent = @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0.2 Safari/605.1.15";
    [_webkitview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    //set the window size
    [_window setContentSize:NSMakeSize([[data objectForKey:@"width"] doubleValue], [[data objectForKey:@"height"] doubleValue])];
    
    //set the window title
	_window.titleVisibility = kshow_nav;
	_toolbar.visible = kshow_nav;
	
	[self setTitle:kstart_name];
	
	//set scale factor
	[self setZoomLevel:_currentZoom];
}

/**
 Sets the title bar of the window
 */
-(void)setTitle:(NSString*)newTitle{
	[_toolbarTitle setStringValue:newTitle];
	_window.title = newTitle;
}

- (IBAction)toggleToolbar:(id)sender {
	_window.titleVisibility = !_window.titleVisibility;
	_toolbar.visible = !_toolbar.visible;
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
/**
 Zoom in the web view
 */
- (IBAction)zoomIn:(id)sender {
	
	_currentZoom += 0.05;
	[self setZoomLevel:_currentZoom];
	
}

/**
Zoom out the web view
*/
- (IBAction)zoomOut:(id)sender {
	_currentZoom -= 0.05;
	[self setZoomLevel:_currentZoom];
}

/**
 Set the web view to its initial zoom level
 */
-(IBAction)zoomOrig:(id)sender{
	_currentZoom = kstartmag;
	[self setZoomLevel:_currentZoom];
}
/**
 Zooms the current page a specific amount
 @param level new scale factor
 */
-(void) setZoomLevel:(double) level{
	[_webkitview evaluateJavaScript:[NSString stringWithFormat:@"document.body.style.zoom = '%f'",level] completionHandler:nil];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
	//update the zoom level on each navigation to ensure it stays static
	[self setZoomLevel:_currentZoom];
	
	//set titlebar if applicable
	if (kactivetitle){
		[self setTitle:[[_webkitview URL] absoluteString]];
	}
}
// popup handling: creating a subview
// Handles closing webview
-(void)webViewDidClose:(WKWebView *)webView{
	[webView removeFromSuperview];
}
//creates a popup view displayed on top when the base tries to create a popup window
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
	
	WKWebView* wview = [[WKWebView alloc] initWithFrame:_webkitview.bounds configuration:configuration];
	wview.bounds = _webkitview.bounds;
	wview.autoresizingMask = (NSViewWidthSizable | NSViewHeightSizable );
	wview.navigationDelegate = self;
	wview.UIDelegate = self;
	[_webkitview addSubview:wview];
	
	return wview;
}

@end
