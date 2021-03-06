//
//  Constants.h
//  Currency Converter
//
//  Created by Luís Lira on 06/04/2020.
//  Copyright © 2020 Luís Lira. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Constants : NSObject
@end

static BOOL const DEBUG_FLAG = NO;
static NSString * const LATEST_RATES_ENDPOINT = @"/latest";
static NSString * const CURRENCY_NAME_ENDPOINT = @"/symbols";
static NSString * const CONVERSION_ENDPOINT = @"/convert";


static NSString * const BASE_URL_API = @"http://data.fixer.io/api";
static NSString * const ACCESS_KEY_API = @"a8c69790793dad335a37bb5e9cfa4233";

static CGFloat const ROW_HEIGHT_RATES = 85.0;

static NSString * const BASE_CURRENCY_EUR = @"EUR";
static NSString * const BASE_CURRENCY_USD = @"USD";

NS_ASSUME_NONNULL_END
