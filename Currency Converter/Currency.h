//
//  Currency.h
//  Currency Converter
//
//  Created by Luís Lira on 07/04/2020.
//  Copyright © 2020 Luís Lira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Currency : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *tag;
@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) UIImage *image;

- (id)initWithTag:(NSString *)tag;

@end

NS_ASSUME_NONNULL_END
