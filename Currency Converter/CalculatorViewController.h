//
//  CalculatorViewController.h
//  Currency Converter
//
//  Created by Luís Lira on 06/04/2020.
//  Copyright © 2020 Luís Lira. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CalculatorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *currency1TagLabel;
@property (weak, nonatomic) IBOutlet UILabel *currency1NameLabel;
@property (weak, nonatomic) IBOutlet UITextField *currency1TextField;

@property (weak, nonatomic) IBOutlet UILabel *currency2TagLabel;
@property (weak, nonatomic) IBOutlet UILabel *currency2NameLabel;
@property (weak, nonatomic) IBOutlet UITextField *currency2TextField;

@end

NS_ASSUME_NONNULL_END
