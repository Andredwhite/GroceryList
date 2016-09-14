//
//  BaseViewController.m
//  GroceryList
//
//  Created by Andre White on 7/19/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import "BaseViewController.h"
#import "GroceryListTableTableViewController.h"
#import "AddItemViewController.h"
#import "GroceryList.h"
#import "GroceryItem.h"
#import "GLDataController.h"
@interface BaseViewController ()
@property (strong, nonatomic)GroceryListTableTableViewController* listView;
@property (strong, nonatomic)AddItemViewController* addView;
@end

@implementation BaseViewController
@synthesize theList=_theList;
- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) GroceryListUpdated{
}
-(void) addItem:(GroceryItem *)item withQuantity:(NSNumber *)quantity{
    [_theList addItem:item withQuantity:quantity];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"AddItemSegue"]) {
        GroceryListTableTableViewController* source=[segue sourceViewController];
        
        AddItemViewController* dest=[segue destinationViewController];
        //[dest setDataController:source.dataController];
    }
    
    //_addView.theList=_listView.theList;
}


@end
