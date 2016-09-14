//
//  ItemViewController.h
//  GroceryList
//
//  Created by Andre White on 7/24/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Item;
@class GLDataController;
@interface ItemViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *ItemImageView;
@property (strong, nonatomic) IBOutlet UILabel *ItemNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ItemPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *ItemLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *ItemSpecsLabel;
@property (strong, nonatomic) GLDataController* dataController;
@property (strong, nonatomic) NSIndexPath* selectedIndex;


@property (strong, nonatomic) UIImage* itemImage;

@end
