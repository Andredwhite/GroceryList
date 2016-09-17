//
//  GroceryListTableTableViewController.m
//  GroceryList
//
//  Created by Andre White on 7/19/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import "GroceryListTableTableViewController.h"
#import "AddItemViewController.h"
#import "ItemViewController.h"
#import "GroceryListDelegate.h"
#import "AppDelegate.h"
#import "GLDataController.h"
#import "GroceryItem.h"
#import "Item+CoreDataClass.h"
#import "NSArray+listCategories.h"

@interface GroceryListTableTableViewController ()<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UIBarButtonItem* addButton;
@property (strong, nonatomic) UIBarButtonItem* budgetButton;
@property (strong,nonatomic) GLDataController* dataController;
@property (strong, nonatomic) NSNumber* budget;

@end

@implementation GroceryListTableTableViewController

-(void)viewWillAppear:(BOOL)animated{
    [self updateTable];
    [self updateListPrice];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.navigationController.toolbarHidden=NO;
    AppDelegate* appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    _dataController=[appDelegate dataController];
    [_dataController setBudget:@60];
    [self updateListPrice];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThumb) name:@"ThumbUpdated" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTable) name:@"MainListChanged" object:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.leftBarButtonItem = self.editButtonItem;
}
-(void) updateThumb{
    [[self tableView] reloadData];
    [[self tableView] setNeedsDisplay];
}

-(void)initView{
    _addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItemSegue)];
    self.navigationItem.rightBarButtonItem = _addButton;
    UIBarButtonItem* space=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    _budgetButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(editBudgetSegue)];
    _budgetButton.tintColor=[self colorForBudgetButton];
    self.toolbarItems=@[space,_budgetButton,space];
}
-(UIColor*) colorForBudgetButton{
    if ([_dataController mainListOverBudget]) {
        return [UIColor redColor];
    }
    return [UIColor blackColor];
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
    if (editing) {
        _addButton.enabled = NO;
        _budgetButton.enabled=NO;
    } else {
        _addButton.enabled = YES;
        _budgetButton.enabled=YES;
    }
}

-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void) editTable{
    
}
-(void) updateTable{
    [[self tableView] reloadData];
}
-(void) addItemSegue{
    [self performSegueWithIdentifier:@"AddItemSegue" sender:self];
}
-(void) editBudgetSegue{
    [self performSegueWithIdentifier:@"editBudget" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataController numberOfSectionsForList:MAIN];
}
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[_dataController categoriesForList:MAIN] objectAtIndex:section];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataController numberOfRowsForSection:section InList:MAIN];
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    if(cell== nil)
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


#pragma use StoryBoard for transition.
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //[self performSegueWithIdentifier:@"ViewItem" sender:self];
}
- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    Item* object=[_dataController itemInList:MAIN atIndexPath:indexPath];
    cell.textLabel.text=object.itemName;
    cell.detailTextLabel.text=[[_dataController priceFormat] stringFromNumber:object.itemPrice];
    [cell.imageView setImage:[UIImage imageWithData:object.itemImgThumb]];
    
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(void) updateListPrice{
    
    _budgetButton.title=[[_dataController priceFormat] stringFromNumber:[_dataController getPriceForList:MAIN]];
    _budgetButton.tintColor=[self colorForBudgetButton];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_dataController removeItem:[_dataController itemInList:MAIN atIndexPath:indexPath] fromList:MAIN];
        [self updateTable];
        [self updateListPrice];
        [tableView endEditing:YES];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ViewItem"]) {
        NSIndexPath* indexPath=[[self tableView] indexPathForSelectedRow];
        ItemViewController* dest=[segue destinationViewController];
        [dest setSelectedIndex:indexPath];
        [dest setDataController:_dataController];
    }
    else if ([segue.identifier isEqualToString:@"editBudget"]) {
        
        //
    }
    else{
        AddItemViewController* child=[segue destinationViewController];
        [child setDataController:_dataController];
    }
    
    
}


@end
