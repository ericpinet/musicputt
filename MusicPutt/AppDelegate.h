//
//  AppDelegate.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-16.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPDataManager.h"
#import "REFrostedViewControllerMain.h"


/**
 *  Application main delegate.
 */
@interface AppDelegate : UIResponder <UIApplicationDelegate>


/**
 *  Main window application.
 */
@property (strong, nonatomic) UIWindow *window;

/**
 *  Object use for maintain data of the current execution of that application.
 */
@property (strong, nonatomic) MPDataManager* mpdatamanager;

/**
 *  Main menu of the application
 */
@property (strong, nonatomic) REFrostedViewControllerMain* mainMenu;


/**
 *  Return version and build.
 *
 *  @return Return the version and build of the applicaiton.
 */
- (NSString *) versionBuild;

@end
