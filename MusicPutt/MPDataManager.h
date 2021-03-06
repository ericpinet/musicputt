//
//  MPDataManager.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-28.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UICurrentPlayingToolBar.h"
#import "UITabBarControllerMain.h"

@class MPMusicPlayerController;
@class CMMotionManager;
@class Playlist;
@class BFNavigationBarDrawer;
@class iToolbar;

/**
 * MPDataManager is the main application data manager. This class maintain all data for
 * the current execution.
 */
@interface MPDataManager : NSObject


/**
 *  Main music player controller.
 */
@property (strong, nonatomic) MPMusicPlayerController* musicplayer;

/**
 *  Toolbar displayed when music playing and the UIMusicViewController is not displayed.
 */
@property (strong, nonatomic) UICurrentPlayingToolBar*  currentPlayingToolbar;

/**
 *  Toolbar displayed when playlist is editing.
 */
@property (strong, nonatomic) iToolbar*  currentEditingPlaylistToolbar;

/**
 *  Current selected itunes playlist select in the playlist navigation bar.
 */
@property (strong, nonatomic) MPMediaPlaylist* currentPlaylist;

/**
 *  Current selected musicputt playlist select in the playlist navigation bar.
 */
@property (strong, nonatomic) Playlist* currentMusicputtPlaylist;

/**
 *  Current song list for the songlist navigation bar.
 */
//@property (strong, nonatomic) NSMutableArray* currentSonglist;

/**
 * Current selected artist collection for the artist navigation bar.
 */
@property (strong, nonatomic) MPMediaItemCollection* currentArtistCollection;

/**
 *  Current selected album collection for the album navigation bar.
 */
@property (strong, nonatomic) MPMediaItemCollection* currentAlbumCollection;

/**
 *  Current selected artist for the artist navigation bar.
 */
@property (strong, nonatomic) MPMediaItem* currentArtist;

/**
 *  Main tabbar controller
 */
@property (strong, nonatomic) UITabBarControllerMain* tabbar;

/**
 *  Current navigation controller. Use by the main tabbar and main menu to pop all view Controller when swith tabbar.
 */
@property (strong, nonatomic) UINavigationController* currentNavController;

/**
 *  Indicate if is needed to reload Display of MediaItem in UIViewCOntrollerMusic.
 */
@property BOOL forceDisplayMediaItem;

/**
 *  Initialise all data for the current execution of the application.
 *
 *  @return True if the initialization succesed.
 */
- (bool) initialise;

/**
 *  Prepare application to gone in background.
 */
- (void) prepareAppDidEnterBackground;

/**
 *  Prepare application to gone in foreground.
 */
- (void) prepareAppWillEnterForeground;

/**
 *  Prepare application to become active
 */
-(void) prepareAppDidBecomeActive;

/**
 *  Prepare application to terminate
 */
-(void) prepareAppWillTerminate;

/**
 *  Return true if the mediaPlayer is initialized.
 *
 *  @return Return true if media player is initialized.
 */
-(bool) isMediaPlayerInitialized;

/**
 *  Indicate if UICurrentPlayingToolBar must be hidden.
 *
 *  @return True if UICurrentPlayingToolBar must be hidden.
 */
- (bool) currentPlayingToolbarMustBeHidden;

/**
 *  Set if UICurrentPlayingToolBar must be hidden.
 *
 *  @param hidden True to hidden UICurrentPlayingToolBar.
 */
- (void) setCurrentPlayingToolbarMustBeHidden:(bool) hidden;

/**
 *  Indicate if playlist is in editing mode. If true, we have to display toolbar editing.
 *
 *  @return True if a playlist is in editing mode.
 */
- (bool) isPlaylistEditing;

/**
 *  Set  state of playlist editing mode.
 *
 *  @param active True to indicate that a playlist is in editing mode.
 */
- (void) setPlaylistEditing:(bool) active;

/**
 *  Set the last playing album
 *
 *  @param albumUid uid of the album
 */
- (void) setLastPlayingAlbum:(NSNumber*) albumUid;

/**
 *  Return last playing album
 *
 *  @return uid of the last playing album
 */
- (NSNumber*) getLastPlayingAlbum;

/**
 *  Return true if last playlist is musicputt type.
 *
 *  @return true if musicputt type. false if itunes type.
 */
- (BOOL) isLastPlaylistMusicPutt;

/**
 *  Set last playing playlist (musicputt type)
 *
 *  @param playlistName Name of the playlist
 */
- (void) setLastPlayingPlaylistMusicPutt:(NSString*) playlistName;

/**
 *  Get last playing playlist (musicputt type)
 *
 *  @return Name of the lastest playlist play.
 */
- (NSString*) getLastPLayingPlaylistMusicPutt;

/**
 *  Set the last playing playlist
 *
 *  @param playlistUid uid of the playlist
 */
- (void) setLastPlayingPlaylist:(NSNumber*) playlistUid;

/**
 *  Return the last playing playlist
 *
 *  @return uid of the last playing playlist
 */
- (NSNumber*) getLastPLayingPlaylist;

/**
 *  Start playing an album.
 *
 *  @param albumUid album uid for starting playing.
 *
 *  @return true if album is starting to playing.
 */
- (bool) startPlayingAlbum:(NSNumber*) albumUid;

/**
 *  Start playing a playlist.
 *
 *  @param playlistUid playlist uid for starting playing.
 *
 *  @return true if playlist is starting to playing.
 */
- (bool) startPlayingPlaylist:(NSNumber*) playlistUid;

/**
 *  Start playing a playlist musicputt.
 *
 *  @param playlistName playlist name for starting playing musicputt playlist.
 *
 *  @return true if playlist is starting to playing.
 */
- (bool) startPlayingPlaylistMusicPutt:(NSString*) playlistName;

/**
 *  Start playing best rating song on the device.
 * 
 *  @return true if start playing is possible.
 */
- (BOOL) startPlayingBestRating;

/**
 *  Set the last media playing item. This action will send item in musicputt server database.
 *
 *  @param item Media item now playing.
 */
- (void) setLastPlayingItem:(MPMediaItem*)item;

/**
 *  Shared CMotionManager.
 *
 *  @return singleton CMotionManager
 */
- (CMMotionManager *)sharedManager;


@end
