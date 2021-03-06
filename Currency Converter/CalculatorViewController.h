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
@property (strong,nonatomic) NSString *fromCurrency;
@property (strong,nonatomic) NSString *toCurrency;
@property (strong,nonatomic) NSArray *keys;

@end

NS_ASSUME_NONNULL_END
