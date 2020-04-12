//
//  CurrencyTableViewCell.h
//  Currency Converter
//
//  Created by Luís Lira on 06/04/2020.
//  Copyright © 2020 Luís Lira. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CurrencyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *currencyImageView;
@property (weak, nonatomic) IBOutlet UILabel *currencyTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedCellImageView;

@end

NS_ASSUME_NONNULL_END
