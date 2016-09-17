//
//  ItemViewController.m
//  GroceryList
//
//  Created by Andre White on 7/24/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import "ItemViewController.h"
#import "InternetConnection.h"
#import "Item+CoreDataProperties.h"
#import "GLDataController.h"
@interface ItemViewController ()
@property(strong, nonatomic)UIBarButtonItem* trashButton;
@property(strong, nonatomic)UIBarButtonItem* quantityButton;
@property(strong, nonatomic)UIBarButtonItem* upOneButton;
@property(strong, nonatomic)UIBarButtonItem* downOneButton;
@property(strong, nonatomic)UIBarButtonItem* favoritesButton;
@property(assign, nonatomic)NSInteger quantity;
@property (strong, nonatomic) Item* groceryItem;

@end
@implementation ItemViewController
@synthesize ItemImageView;
@synthesize ItemLocationLabel;
@synthesize ItemPriceLabel;
@synthesize ItemNameLabel;
@synthesize itemImage;
@synthesize dataController;
@synthesize selectedIndex;
@synthesize ItemSpecsLabel;


-(void) viewDidLoad{
    [super viewDidLoad];
    _groceryItem=[dataController itemInList:MAIN atIndexPath:selectedIndex];
    _quantity=[dataController quantityForItem:_groceryItem inList:MAIN];
    [self initViewWithItem:_groceryItem];
    [self initButtons];
}
-(void)initButtons{
    _favoritesButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(addItemToFavs)];
    if ([dataController yaFav:_groceryItem]) {
        _favoritesButton.enabled=NO;
    }
    _upOneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    _quantityButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"QTY:%ld",(long)_quantity] style:UIBarButtonItemStylePlain target:self  action:nil];
    UIBarButtonItem* space=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems=@[_favoritesButton, space,_quantityButton,space,_upOneButton];
    _trashButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(removeItem)];
    self.navigationItem.rightBarButtonItem=_trashButton;
}
-(void)initViewWithItem:(Item*)item{
    ItemPriceLabel.text=[[dataController priceFormat] stringFromNumber:_groceryItem.itemPrice];
    ItemLocationLabel.text=item.itemDesc;
    ItemNameLabel.text=item.itemName;
    ItemSpecsLabel.text=item.itemSpecs;
    [ItemImageView setImage:[[UIImage alloc]initWithData:item.itemImgThumb]];
 
}
-(void) addItemToFavs{
    [dataController addItem:[Item itemFromItem:_groceryItem inContext:dataController.managedObjectContext] toList:FAVORITES];
    _favoritesButton.enabled=NO;
}
-(void)removeItem{
    [dataController removeItem:_groceryItem fromList:MAIN];
    [[self navigationController] popViewControllerAnimated:YES];
}


-(void)addItem{
    Item* newItem=[Item itemFromItem:_groceryItem inContext:[dataController managedObjectContext]];
    [dataController addItem:newItem toList:MAIN];
    _quantity+=1;
    _quantityButton.title=[NSString stringWithFormat:@"QTY:%ld",(long)_quantity];
}
@end
