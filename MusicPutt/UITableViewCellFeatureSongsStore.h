//
//  UITableViewCellFeatureSongsStore.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-11-29.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCellFeatureSongsStore : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView* image;

@property (weak, nonatomic) IBOutlet UILabel* title;

@property (weak, nonatomic) IBOutlet UILabel* album;

@property (weak, nonatomic) IBOutlet UILabel* artist;

@end
