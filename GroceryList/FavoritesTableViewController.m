//
//  FavoritesTableViewController.m
//  GroceryList
//
//  Created by Andre White on 8/14/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import "FavoritesTableViewController.h"
#import "AppDelegate.h"
#import "GLDataController.h"
#import <CoreData/CoreData.h>
#import "Item+CoreDataProperties.h"
@interface FavoritesTableViewController () <NSFetchedResultsControllerDelegate>
@property (strong,nonatomic) GLDataController* dataController;
@property (strong, nonatomic) UIBarButtonItem* addButton;
@property (strong, nonnull) Item* selected;

@end

@implementation FavoritesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate* appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    _dataController=[appDelegate dataController];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTable) name:@"FavoritesChanged" object:nil];
    [[self navigationItem]setTitle:@"Favorites"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    self.navigationItem.rightBarButtonItem = _addButton;
    _addButton.enabled=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)updateTable{
    [[self tableView] reloadData];
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
}
-(void) addItem{
    [_dataController addItem:[Item itemFromItem:_selected inContext:_dataController.managedObjectContext] toList:MAIN];
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selected=[_dataController itemInList:FAVORITES atIndexPath:indexPath];
    _addButton.enabled=YES;
}
#pragma mark - Table view data source
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[_dataController categoriesForList:FAVORITES]objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_dataController numberOfSectionsForList:FAVORITES];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataController numberOfRowsForSection:section InList:FAVORITES];
}

-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    Item* object=[_dataController itemInList:FAVORITES atIndexPath:indexPath];
    cell.textLabel.text=object.itemName;
    cell.detailTextLabel.text=object.itemSpecs;
    [cell.imageView setImage:[UIImage imageWithData:object.itemImgThumb]];
    
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [_dataController removeItem:[_dataController itemInList:FAVORITES atIndexPath:indexPath] fromList:FAVORITES];
        [self updateTable];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
