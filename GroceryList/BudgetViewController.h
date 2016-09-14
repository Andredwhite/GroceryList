//
//  BudgetViewController.h
//  GroceryList
//
//  Created by Andre White on 8/12/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BudgetViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *budgetLabel;
@property (strong, nonatomic) IBOutlet UIStepper *budgetStepper;

@end
