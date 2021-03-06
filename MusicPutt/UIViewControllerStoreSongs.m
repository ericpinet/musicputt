//
//  UIViewControllerStoreSongs.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-08-02.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerStoreSongs.h"

#import "AppDelegate.h"
#import "ITunesSearchApi.h"
#import "UITableViewCellSongStore.h"
#import <AVFoundation/AVFoundation.h>


@interface UIViewControllerStoreSongs () <ITunesSearchApiDelegate, UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate>
{
    NSArray* songResults;
    AVAudioPlayer* audioPlayer;
    ITunesMusicTrack* currentPlaying;
    
    NSInteger currentSongIndex;
    NSInteger currentDownloadingIndex;
    NSInteger currentPlayingIndex;
}

/**
 *  App delegate
 */
@property AppDelegate* del;

/**
 *  Table view of songs
 */
@property (weak, nonatomic) IBOutlet UITableView* tableView;


@end



@implementation UIViewControllerStoreSongs

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // setup app delegate
    self.del = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    // query store for top song of artist
    ITunesSearchApi *store = [[ITunesSearchApi alloc]init];
    [store setDelegate:self];
    [store queryMusicTrackWithArtistId:_storeArtistId asynchronizationMode:true];
    
    // init current downloading displaying
    currentDownloadingIndex = -1;
    currentPlayingIndex = -1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  Ensure that playing preview song is ended
 */
- (void) stopPlaying
{
    [audioPlayer stop];
    [self stopPlayingProgress:[NSNumber numberWithInteger:currentPlayingIndex]];
}

/**
 *  Share button was pressed by the user.
 *
 *  @param sender sender of event.
 */
- (IBAction)sharePressed:(id)sender
{
    NSString* sharedString = [NSString stringWithFormat:@"I'm listening : %@ - %@ @musicputt!", [currentPlaying trackName], [currentPlaying collectionName]];
    NSURL* sharedUrl = [NSURL URLWithString:[currentPlaying trackViewUrl]];
    
    id path = [currentPlaying getArtworkUrlCustomQuality:@"300x300-100"];
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *sharedImage = [[UIImage alloc] initWithData:data];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[sharedString, sharedUrl, sharedImage] applicationActivities:nil];
    controller.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact];
    [self presentViewController:controller animated:YES completion:nil];
}


/**
 *  Click on itunes button.
 *
 *  @param sender <#sender description#>
 */
- (IBAction)itunesButtonPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[songResults objectAtIndex:0] artistLinkUrl]]];
}

/**
 *  Start playing song
 *
 *  @param index <#index description#>
 */
- (void) startPlayingAtIndex:(NSInteger) index
{
    if (songResults.count>index) {
        currentSongIndex = index;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentSongIndex-1 inSection:0];
        [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        //[self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:indexPath];
        
        NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Start playing ", (long)currentSongIndex);
        
        [self startDownloadProgress:currentSongIndex-1];
        
        NSURL *url = [NSURL URLWithString: [[songResults objectAtIndex:index] previewUrl]];
        if (url) {
            NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
                audioPlayer.delegate = self;
                [audioPlayer play];
                
                NSNumber *param = [NSNumber numberWithInteger:currentDownloadingIndex];
                [self performSelectorOnMainThread:@selector(stopDownloadProgress:) withObject:param waitUntilDone:NO];
                
                NSNumber *param2 = [NSNumber numberWithInteger:currentDownloadingIndex];
                [self performSelectorOnMainThread:@selector(startPlayingProgress:) withObject:param2 waitUntilDone:NO];
                
            }];
            [task resume];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"There is no preview for this song!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil,nil];
            [alert show];
            
            [self stopDownloadProgress: [NSNumber numberWithInteger:currentSongIndex-1]];
        }
    }
}

-(void) startDownloadProgress:(NSInteger) index
{
    if (currentDownloadingIndex != -1) {
        // stop already downloding progress
        [self stopDownloadProgress:[NSNumber numberWithInteger:index]];
    }
    
    currentDownloadingIndex = index;
    
    //NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Start downloading progress ", (long)index);
    
    UITableViewCellSongStore *cell = (UITableViewCellSongStore*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if (cell) {
        [cell startDownloadProgress];
    }
}

-(void) stopDownloadProgress:(NSNumber*) index
{
    //NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Stop downloading progress ", (long)[index integerValue]);
    
    UITableViewCellSongStore *cell = (UITableViewCellSongStore*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[index integerValue] inSection:0]];
    if (cell) {
        [cell stopDownloadProgress];
    }
    currentDownloadingIndex = -1;
}

/**
 *  <#Description#>
 *
 *  @param index <#index description#>
 */
-(void) startPlayingProgress:(NSInteger) index
{
    if (currentPlayingIndex != -1) {
        // stop already downloding progress
        [self stopPlayingProgress:[NSNumber numberWithInteger:currentPlayingIndex]];
    }
    
    currentPlayingIndex = currentSongIndex;
    
    UITableViewCellSongStore *cell = (UITableViewCellSongStore*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentPlayingIndex-1 inSection:0]];
    if (cell) {
        [cell startPlayingProgress];
    }
}

/**
 *  <#Description#>
 *
 *  @param index <#index description#>
 */
-(void) stopPlayingProgress:(NSNumber*) index
{
    //NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Stop downloading progress ", (long)[index integerValue]);
    
    UITableViewCellSongStore *cell = (UITableViewCellSongStore*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[index integerValue]-1 inSection:0]];
    if (cell) {
        [cell stopPlayingProgress];
    }
    currentPlayingIndex = -1;
}


#pragma mark MPServiceStoreDelegate
/**
 *  Implement this methode for recieve result after query.
 *
 *  @param status  Status of the querys
 *  @param type    Type of query sender
 *  @param results resultset of the query
 */
-(void) queryResult:(ITunesSearchApiQueryStatus)status type:(ITunesSearchApiQueryType)type results:(NSArray*) results
{
    if (status!=ITunesSearchApiStatusSucceed || [results count]==0)
    {
        /*
         UIAlertView *message = [[UIAlertView alloc]
         initWithTitle:@"Not found!"
         message:@"Unable to found this album on the iTunes Store."
         delegate:nil
         cancelButtonTitle:@"OK"
         otherButtonTitles:nil];
         
         [message show];
         */
    }
    else
    {
        if (type == QueryMusicTrackWithArtistId)
        {
            songResults = results;
            if (results.count>0)
            {
                //currentPlaying = [results objectAtIndex:1];
                //currentPlayingIndex = 1;
            }
            [_tableView reloadData];
        }
    }
}


#pragma mark - UITableViewDataSource
/**
 *  Number of section in the table view.
 *
 *  @param tableView :
 *
 *  @return          : Number of section.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1; // always 1 section for the current album display
}

/**
 *  The number of rows in the specified section.
 *
 *  @param tableView <#tableView description#>
 *  @param section   : Section's index.
 *
 *  @return          : Number of row of this section.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // get current album select
    if (songResults!=nil && songResults.count>0) {
        return songResults.count-1;
    }
    return 0;
}

/**
 *  Return the cell at a specified location in the talbe view.
 *
 *  @param tableView :
 *  @param indexPath : The path to the cell.
 *
 *  @return
 */
- (UITableViewCellSongStore*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellSongStore* cell = [tableView dequeueReusableCellWithIdentifier:@"SongStore"];
    [cell setMediaItem:[songResults objectAtIndex:indexPath.row+1]];
    
    if (currentPlayingIndex == indexPath.row) {
        [cell startPlayingProgress];
        
        if (currentDownloadingIndex == indexPath.row) {
            [cell stopPlayingProgress];
            [cell startDownloadProgress];
        }
    }
    else{
        [cell stopPlayingProgress];
        [cell stopDownloadProgress];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row+1 == currentPlayingIndex && [audioPlayer isPlaying])
    {
        NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Stop playing ", (long)currentPlayingIndex);
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentPlayingIndex-1 inSection:0];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        [audioPlayer stop];
        
        [self stopPlayingProgress:[NSNumber numberWithInteger:currentSongIndex]];
    }
    else
    {
        [self startPlayingAtIndex:indexPath.row+1];
    }
    
    return indexPath;
}


#pragma mark - AVAudioPlayerDelegate

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Playing ended ", (long)currentPlayingIndex);
    [audioPlayer stop];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentPlayingIndex-1 inSection:0];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self startPlayingAtIndex:currentPlayingIndex+1];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"Error occured");
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
