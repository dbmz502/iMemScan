//
//  AppController.m
//  MemSearch
//
//  Created by 李良林 on 2020/10/18.
//  Copyright © 2020 李良林. All rights reserved.
//

#import "AppController.h"

@interface PrivateApi_LSApplicationWorkspace
- (NSArray*)allInstalledApplications;
- (bool)openApplicationWithBundleID:(id)arg1;
- (NSArray*)privateURLSchemes;
- (NSArray*)publicURLSchemes;
@end


#pragma mark -

@implementation AppController
{
  PrivateApi_LSApplicationWorkspace* _workspace;
  NSArray* _installedApplications;
}

- (instancetype)init
{
	self = [super init];
	if(self != nil)
	{
		_workspace = [NSClassFromString(@"LSApplicationWorkspace") new];
	}
	
	return self;
}

- (NSArray*)privateURLSchemes
{
    return [_workspace privateURLSchemes];
}

- (NSArray*)publicURLSchemes
{
    return [_workspace publicURLSchemes];
}

- (NSArray*)readApplications
{
	NSArray* allInstalledApplications = [_workspace allInstalledApplications];
	NSMutableArray* applications = [NSMutableArray arrayWithCapacity:allInstalledApplications.count];
	for(id proxy in allInstalledApplications)
	{
		App* app = [App appWithPrivateProxy:proxy];
		if(!app.isHiddenApp)
		{
			[applications addObject:app];
		}
	}
	
	return applications;
}

- (NSArray*)installedApplications
{
	if(nil == _installedApplications)
	{
		_installedApplications = [self readApplications];
	}
	
	return _installedApplications;
}

- (BOOL)openAppWithBundleIdentifier:(NSString *)bundleIdentifier
{
	return (BOOL)[_workspace openApplicationWithBundleID:bundleIdentifier];
}

+ (instancetype)sharedInstance
{
  static dispatch_once_t once;
  static id sharedInstance;
  dispatch_once(&once, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

@end
