//
//  AddItemViewController.m
//  GroceryList
//  This class will ONLY CREATE ITEM, for ease. Create Item, send back the created Item. Tell List delegate that something wants to be added.
//  Created by Andre White on 7/19/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import "AddItemViewController.h"
#import "GroceryListTableTableViewController.h"
#import "GroceryItem.h"
#import "GroceryList.h"
#import "UPCScannerViewController.h"
#import "GLDataController.h"
#import "AppDelegate.h"
#import "Item+CoreDataProperties.h"
#import "NSArray+listCategories.h"
#import "GrocerySearchController.h"
@interface AddItemViewController () <UINavigationBarDelegate,  UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

-(void) updateQuantityLabel;
-(void) updateTable;
@property (retain, nonatomic) NSArray* resultsList;
@property (retain, nonatomic) UIBarButtonItem* quantityButton;
@property (retain, nonatomic) UIBarButtonItem* doneButton;
@property (retain, nonatomic) UIBarButtonItem* viewItemButton;
@property (retain, nonatomic) UIBarButtonItem* scanItemButton;
@property (retain, nonatomic) NSDictionary* categoryDict;
@property (assign, nonatomic) NSInteger quantity;
@property (assign, nonatomic) CGFloat yOrigin;
@property (retain, nonatomic) GrocerySearchController* searchController;
@end

@implementation AddItemViewController
@synthesize dataController;
@synthesize resultsTable;
@synthesize selectedItem;
@synthesize itemSearch;


- (void)viewDidLoad {
    [super viewDidLoad];
    itemSearch.delegate=self;
    resultsTable.dataSource=self;
    _searchController=[[GrocerySearchController alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultsIn:) name:@"Results" object:nil];
    resultsTable.delegate=self;
    _yOrigin=resultsTable.frame.origin.y;
    [self initButtons];
}
-(void) resultsIn:(NSNotification*)notification{
    _resultsList=notification.object;
    [self performSelectorOnMainThread:@selector(updateResults) withObject:nil waitUntilDone:NO];
    
}
-(void) initButtons{
    _doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addItemToList)];
    self.navigationItem.rightBarButtonItem = _doneButton;
    _doneButton.enabled=NO;
    self.navigationItem.title=@"Add Item";
    self.definesPresentationContext=YES;
    _quantity=0;
    _quantityButton=[[UIBarButtonItem alloc]initWithTitle:@"Qty" style:UIBarButtonItemStylePlain target:self action:@selector(quantityPlusOne)];
    _quantityButton.enabled=NO;
    _viewItemButton=[[UIBarButtonItem alloc]initWithTitle:@"Favs" style:UIBarButtonItemStylePlain target:self action:@selector(viewItem)];
    _scanItemButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(scanItem)];
    UIBarButtonItem* space=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems=@[_viewItemButton,space,_quantityButton,space, _scanItemButton];
}
-(void) scanItem{
    BOOL autho=[[NSUserDefaults standardUserDefaults] boolForKey:@"CameraAuthorized"];
    if(!autho){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted)
            {
                //Granted access to mediaType
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"CameraAuthorized"];
                
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"CameraAuthorized"];
                //Not granted access to mediaType
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Camera Accesss Denied"
                                                                                   message:@"Go to Settings->GroceryList to allow camera access."
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {
                                                                              [self dismissViewControllerAnimated:YES completion:^{}];
                                                                          }];
                    
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];
                });
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
    }
    else{
        [self performSegueWithIdentifier:@"ScanView" sender:self];
    }
    
}
-(void)viewItem{
    [self performSegueWithIdentifier:@"FavView" sender:self];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_searchController searchForItemByName:searchBar.text];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [itemSearch resignFirstResponder];
    itemSearch.showsScopeBar=NO;
    CGRect rect=resultsTable.frame;
    rect.origin.y=_yOrigin;
    self.resultsTable.frame=rect;
}
-(void) searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    //_resultsList=[_categoryDict objectForKey:[[_categoryDict allKeys] objectAtIndex:selectedScope]];
    _resultsList=[_searchController getListByCategory:selectedScope];
    [self updateTable];
}
-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if (searchBar.scopeButtonTitles) {
        searchBar.showsScopeBar=YES;
        [self adjustTable];
    }
}
#pragma end of Search Bar start of tableView


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_resultsList count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    if(cell== nil)
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    cell.textLabel.text=[_resultsList[indexPath.row] name];
    cell.detailTextLabel.text=[[dataController priceFormat] stringFromNumber:[_resultsList[indexPath.row] priceperitem]];
    [cell.imageView setImage:[_resultsList[indexPath.row] itemThumbImage]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (selectedItem==[_resultsList objectAtIndex:indexPath.row]) {
            _quantity+=1;
    }
    else{
        selectedItem=[_resultsList objectAtIndex:indexPath.row];
        _quantity=1;
    }
    [self updateQuantityLabel];
    _doneButton.enabled=YES;
    _quantityButton.enabled=YES;
   
     [itemSearch resignFirstResponder];
}

-(void) adjustTable{
    CGRect rect=resultsTable.frame;
    if (rect.origin.y==_yOrigin) {
        rect.origin.y+=20;
    }
    self.resultsTable.frame=rect;
}
-(void) updateResults{
    itemSearch.scopeButtonTitles=[_searchController allCategories];
    itemSearch.showsScopeBar=YES;
    [self adjustTable];
    [self updateTable];
}
-(void) addItemToList{
    for (int x=0; x<_quantity; x++) {
        Item* item=[Item itemFromGroceryItem:selectedItem inContext:dataController.managedObjectContext];
        [dataController addItem:item toList:MAIN];
    }
    [[self navigationController] popViewControllerAnimated:YES];
}
-(void)quantityPlusOne{
    _quantity+=1;
    [self updateQuantityLabel];
}
-(void) updateQuantityLabel{
    _quantityButton.title=[NSString stringWithFormat:@"QTY:%ld",(long)_quantity];
}

-(void)updateTable{
    [resultsTable reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects!=nil &&[metadataObjects count]>0) {
        AVMetadataMachineReadableCodeObject* metadataObj= [metadataObjects firstObject];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeEAN13Code]) {
            [[self navigationController] popViewControllerAnimated:YES];
            //[_connection WalmartSearchQuery:[metadataObj stringValue] andType:SEARCHBYNAME];
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ScanView"]) {
        UPCScannerViewController* dest= [segue destinationViewController];
        dest.delegate=self;
    }
    /*
    if([segue.identifier isEqualToString:@"ItemView"]){
        ItemViewController* destController=[segue destinationViewController];
        AddItemViewController* sourController=[segue sourceViewController];
        //destController.groceryItem=sourController.selectedItem;
        //[destController.ItemImageView setImage: sourController.selectedItemImage];
        
    }*/
    //GroceryListTableTableViewController* view=[segue destinationViewController];
    //view.theList=theList;
}


@end
