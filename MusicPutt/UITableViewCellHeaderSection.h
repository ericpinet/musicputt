//
//  UITableViewCellHeaderSection.h
//  MusicPutt
//
//  Created by Qiaomei Wang on 2014-07-15.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCellHeaderSection : UITableViewCell

/**
 *  Album's name.
 */
@property (nonatomic, weak) IBOutlet UILabel* albumName;
/**
 *  Album's information. There are tracks counte and the duration of the album at present.
 */
@property (nonatomic, weak) IBOutlet UILabel* infoAlbum;
/**
 *  The year of the birth of the album.
 */
@property (nonatomic, weak) IBOutlet UILabel* albumYear;
/**
 *  Album's cover.
 */
@property (nonatomic, weak) IBOutlet UIImageView* imageHeader;

@end
