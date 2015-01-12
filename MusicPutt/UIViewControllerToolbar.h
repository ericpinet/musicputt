//
//  UIViewControllerToolbar.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-30.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMWaveViewController.h"
#import "UICurrentPlayingToolBar.h"



/**
 *  Base class for all UIViewController of this application.
 *
 *  This class provide :
 *
 *   - Toolbar mechanism
 *   - Wave effect on transition.
 *
 *  If you inherits from this class your UIViewController will be display a
 *  current playing toolbar automatic. See UICurrentPlayingToolBar.
 *
 *  You can also add a wav effect if you add a visibleCells methode. See AMWaveTransition.
 *
 *  @warning To active wave effect, add this to your UIViewController class
 *
 *          -(NSArray*)visibleCells
 *          {
 *              return [self.tableView visibleCells];
 *          }
 * 
 */
@interface UIViewControllerToolbar : AMWaveViewController
{
    /**
     *  Toolbar to display current playing song.
     */
    UICurrentPlayingToolBar*    currentPlayingToolBar;
    
    /**
     * Toolbar to display edition action during playlist edition
     */
    BFNavigationBarDrawer*      currentEditingPlaylistToolbar;
    
    /**
     *  TableView attach with the current playing song.
     */
    UIScrollView*                scrollView;
}

/**
 *  Show current playing toolbar
 */
-(void) showCurrentPlayingToolbar;

/**
 *  Hide current playing toolbar
 */
-(void) hideCurrentPlayingToolbar;

/**
 *  Show current editing playlist toolbar
 */
-(void) showCurrentEditingPlaylistToolbar;

/**
 *  Hide current editing playlist toolbar
 */
-(void) hideCurrentEditingPlaylistToolbar;

/**
 *  Setup navigation bar
 */
-(void) setupNavigationBar;


@end
