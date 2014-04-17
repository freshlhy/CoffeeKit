//
//  DetailViewController.h
//  CoffeeKit
//
//  Created by freshlhy on 4/16/14.
//  Copyright (c) 2014 freshlhy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
