//
//  Currency.m
//  Currency Converter
//
//  Created by Luís Lira on 07/04/2020.
//  Copyright © 2020 Luís Lira. All rights reserved.
//

#import "Currency.h"

@implementation Currency


- (id)initWithTag:(NSString *)tag{
    self = [super init];
    if(self){
      self.tag=tag;
      self.image=[UIImage imageNamed:self.tag];
    }
    return self;
}


@end
