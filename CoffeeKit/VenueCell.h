//
//  VenueCell.h
//  CoffeeKit
//
//  Created by freshlhy on 14-4-19.
//  Copyright (c) 2014年 freshlhy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenueCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *checkinsLabel;

@end
