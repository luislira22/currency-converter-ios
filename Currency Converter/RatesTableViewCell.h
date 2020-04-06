//
//  RatesTableViewCell.h
//  Currency Converter
//
//  Created by Luís Lira on 06/04/2020.
//  Copyright © 2020 Luís Lira. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RatesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *countryImageView;
@property (weak, nonatomic) IBOutlet UILabel *currencyBigTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyMiniTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

NS_ASSUME_NONNULL_END
