//
//  CurrencyPickerViewController.h
//  Currency Converter
//
//  Created by Luís Lira on 06/04/2020.
//  Copyright © 2020 Luís Lira. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CurrencyPickerViewController : UIViewController
@property (strong, nonatomic) NSDictionary *currenciesRates;
@property (strong, nonatomic) NSDictionary *currenciesNames;
@property (strong, nonatomic) NSArray *currenciesKeys;
@property (strong, nonatomic) NSNumber *returnFlag;
@property BOOL favoriteFlag;

@end

NS_ASSUME_NONNULL_END
